import io/Reader, structs/[HashMap, ArrayList]

BValue: abstract class {
    print: func { toString() print() }
    toString: abstract func -> String
    toShorterString: func -> String { toString() }

    _: String {
	get{ toShorterString() }
    }

    __: String {
	get { toString() }
    }

}

BInt: class extends BValue {
    value: LLong
    init: func (=value) {}
    toString: func -> String { value toString() }
}

BString: class extends BValue {
    value: String
    init: func (=value) {}
    toString: func -> String {
	sb := Buffer new()
	sb append('"')
	if (value length() < 128) {
	    sb append(value)
	} else {
	    sb append("<binary value>")
	}
	sb append('"')
	sb toString()
    }
    toShorterString: func -> String { value }
}

BDict: class extends BValue {
    map := HashMap<String, BValue> new()
    toString: func -> String {
	sb := Buffer new()
	sb append("{ ")
	map each(|key, val|
	    sb append(key)
	    sb append(": ")
	    sb append(val toString())
	    sb append(", ")
	)
	sb append(" }")
	sb toString()
    }
}

BList: class extends BValue {
    list := ArrayList<BValue> new()
    toString: func -> String {
	sb := Buffer new()
	sb append("[ ")
	list each(|val|
	    sb append(val toString())
	    sb append(", ")
	)
	sb append(" ]")
	sb toString()
    }
}

MalformedBencoding: class extends Exception {
    init: super func
}

BDecoder: class {

    r: Reader

    init: func (=r)

    read: func -> BValue {
	match(r peek()) {
	    case 'i' => readInt()
	    case 'l' => readList()
	    case 'd' => readDict()
	    case     => readString()
	}
    }

    readInt: func -> BInt {
	first := r read()
	if (first != 'i') {
	    MalformedBencoding new("Expected i, got %c" format(first)) throw()
	}
	num := r readUntil('e')
	BInt new(num toLLong())	
    }

    readString: func -> BString {
	length := r readUntil(':') toInt()
	buffer := Buffer new(length)
	r read(buffer data, 0, length)
	buffer setLength(length)
	BString new(buffer toString())
    }

    readList: func -> BList {
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
	    list list add(read())
	}
	list
    }

    readDict: func -> BDict {
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
	    key := readString()
	    value := read()
	    dict map put(key value, value)
	}
	dict
    }
}

extend BValue {
    each: func ~list (f: Func(BValue)) {
	match this {
	    case list: BList =>
		// this is the kind of workaround I wish we didn't have to do
		list list each(|v| f(v)) 
	    case =>
		Exception new("Called each~list on %s: '%s'" format(class name, _)) throw()
	}
    }

    each: func ~dict (f: Func(String, BValue)) {
	match this {
	    case dict: BDict =>
		// this is the kind of workaround I wish we didn't have to do (bis)
		dict map each(|k, v| f(k, v)) 
	    case =>
		Exception new("Called each~dict on %s: '%s'" format(class name, _)) throw()
	}
    }
}

operator [] (val: BValue, str: String) -> BValue {
    match val {
	case dict: BDict =>
	    result := dict map get(str)
	    if(!result) Exception new("Key '%s' not found in dict '%s'" format(str, val toString())) throw()
	    result 
	case =>
	    Exception new("Using operator [] on non-dictionary '%s'" format(val toString())) throw()
	    null
    }
}


