import io/Reader


bdecode: func (r: Reader) -> BValue {
}


BValue: class {
    print: func ~noTab { print("") }
    print: abstract func (tab: String)
}

BInt: class extends BValue {
    value := 0
    print: func (tab: String) { tab print(); value toString() print() }
}

BString: class extends BValue {
    value := ""
    print: func (tab: String) { value print() }
}

BDict: class extends BValue {
    map := HashMap<String, BValue> new()
    print: func (tab: String) {
	tab print(); '{' println()
	newTab := tab + "  "
	map each(|key, val|
	    tab print(); key print(newTab); ': ' print(); val print(newTab); println()
	)
	tab print(); '}' println()
    }
}

BList: 

BDecoder: class {

    read: static func (r: reader) -> BValue {
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
	    MalformedBencoding new('Expected i, got %c' format(first)) throw()
	}
	num := readUntil('e')
	
    }

}
