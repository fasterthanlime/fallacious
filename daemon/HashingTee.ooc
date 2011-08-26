import crypt, io/Reader

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

