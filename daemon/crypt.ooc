use gcrypt
include gcrypt

Algo: enum {
    SHA1: extern(GCRY_MD_SHA1) 
    // TODO: add other algorithms here? feeling lazy.
}

gcry_md_hd_t: extern cover {}

// Lazy powa
gcry_md_open: extern func (...)
gcry_md_write: extern func (...)
gcry_md_read: extern func (...) -> UChar* 

Hasher: class {
    hd: gcry_md_hd_t
    algo: Algo

    init: func (=algo, flags := 0) {
	gcry_md_open(hd&, algo, flags)
    }

    write: func (data: Pointer, len: SizeT) {
	gcry_md_write(hd, data, len)
    }

    read: func -> UChar* { read(algo) }

    read: func ~algo (algo: Algo) -> UChar* {
	gcry_md_read(hd, algo)	
    }
}

