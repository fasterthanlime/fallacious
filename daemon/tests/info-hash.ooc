import crypt, bencoding, io/[FileReader, Reader]

/**
 * A simple tee that reads input from in when asked to,
 * and writes it out to a Hasher while doing so.
 */
HashingTee: class extends Reader {
    in : Reader
    out: Hasher

    init: func (=in, =out)

    read: func (chars: Char*, offset: Int, count: Int) -> SizeT {
	in read(chars, offset, count)
	out write(chars + offset, count)
    }

    read: func ~char -> Char {
	c := in read()
	out write(c&, 1)
	c
    }
    
    peek: func -> Char {
	in peek()
    }

    hasNext?: func -> Bool {
	in hasNext?()
    }

    rewind: func (offset: Int) -> Bool {
	Exception new("rewind not supported in HashingTee") throw()
    }

    mark: func -> Bool {
	Exception new("mark not supported in HashingTee") throw()
    }

    reset: func (marker: Long) {
	Exception new("reset not supported in HashingTee") throw()
    }

    close: func {
	in close()
    }
}

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

td := TorrentDecoder new(FileReader new("samples/Adventureland.torrent"))
td read() _ println()

"Hash = " print()
for(i in 0..20) {
    "%02x" printf(td infoHash[i]) 
}
println()

