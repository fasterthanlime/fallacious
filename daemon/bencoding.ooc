import io/Reader, structs/[HashMap, ArrayList]

BValue: abstract class {
    print: abstract func
}

BInt: class extends BValue {
    value: LLong
    init: func (=value) {}
    print: func { value toString() print() }
}

BString: class extends BValue {
    value: String
    init: func (=value) {}
    print: func {
	'"' print()
	if (value length() < 128) {
	    value print()
	} else {
	    "<binary data>" print()
	}
	'"' print()
    }
}

BDict: class extends BValue {
    map := HashMap<String, BValue> new()
    print: func {
	"{ " print()
	map each(|key, val|
	    key print(); ": " print(); val print(); ", " print()
	)
	" }" print()
    }
}

BList: class extends BValue {
    list := ArrayList<BValue> new()
    print: func {
	"[ " print()
	list each(|val|
	    val print(); ", " print()
	)
	" ]" print()
    }
}

MalformedBencoding: class extends Exception {
    init: super func
}

BDecoder: class {

    read: static func (r: Reader) -> BValue {
	match(r peek()) {
	    case 'i' => BDecoder readInt(r)
	    case 'l' => BDecoder readList(r)
	    case 'd' => BDecoder readDict(r)
	    case     => BDecoder readString(r)
	}
    }

    readInt: static func (r: Reader) -> BInt {
	first := r read()
	if (first != 'i') {
	    MalformedBencoding new("Expected i, got %c" format(first)) throw()
	}
	num := r readUntil('e')
	BInt new(num toLLong())	
    }

    readString: static func (r: Reader) -> BString {
	length := r readUntil(':') toInt()
	buffer := Buffer new(length)
	r read(buffer data, 0, length)
	buffer setLength(length)
	BString new(buffer toString())
    }

    readList: static func (r: Reader) -> BList {
	first := r read()
	if (first != 'l') {
	    MalformedBencoding new("Expected l, got %c" format(first)) throw()
	}
	list := BList new()
	while (true) {
	    if (r peek() == 'e') {
		r skip(1)
		break
	    }
	    list list add(read(r))
	}
	list
    }

    readDict: static func (r: Reader) -> BDict {
	first := r read()
	if (first != 'd') {
	    MalformedBencoding new("Expected d, got %c" format(first)) throw()
	}
	dict := BDict new()
	while (true) {
	    if (r peek() == 'e') {
		r skip(1)
		break
	    }
	    key := readString(r)
	    value := read(r)
	    dict map put(key value, value)
	}
	dict
    }
}
