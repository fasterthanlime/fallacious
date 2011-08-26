import crypt, bencoding, HashingTee, io/Reader

TorrentDecoder: class extends BDecoder {

    infoHash: UChar*

    init: func (r: Reader) {
	super(r)
    }

    readDict: func -> BDict {
	first := r read()
	if (first != 'd') {
	    MalformedBencoding new("Expected d, got %c" format(first)) throw()
	}
	dict := BDict new()

	originalR := r

	while (true) {
	    if (r peek() == 'e') {
		r skip(1)
		break
	    }
	    key := readString()
	    value: BValue

	    if(key value == "info" && r peek() == 'd') {
		// create Hasher and swap reader
		h := Hasher new(Algo SHA1)
		r = HashingTee new(r, h)

		value = read()

		// restore original reader and store hash
		r = originalR
		infoHash = h read()
	    } else {
		value = read()
	    }
	    dict map put(key value, value)
	}
	dict
    }

}

