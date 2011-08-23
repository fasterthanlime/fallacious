import io/Reader, structs/[HashMap, ArrayList]

BValue: abstract class {
    print: abstract func
}

BInt: class extends BValue {
    value := 0
    print: func { value toString() print() }
}

BString: class extends BValue {
    value := ""
    print: func { value print() }
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

BDecoder: class {

    read: static func (r: Reader) -> BValue {
	match(r peek()) {
	    case 'i' => BDecoder readInt(r)
	    case 'l' => BDecoder readList(r)
	    case 'd' => BDecoder readDict(r)
	    case     => BDecoder readString(r)
	}
    }

    readInt: static func (r: Reader) -> BValue {
	first := r read()
	if (first != 'i') {
	    MalformedBencoding new("Expected i, got %c" format(first)) throw()
	}
	num := readUntil('e')
	BInt new(num toInt())	
    }

    readString: static func (r: Reader) -> BValue {
	length := readUntil(':') toInt()
	buffer := Buffer new(length)
	r read(buffer data, 0, length)
	BString new(buffer toString())
    }

}
