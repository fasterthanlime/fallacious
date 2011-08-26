import crypt

h := Hasher new(Algo SHA1)
txt := "This is the thing we want to hash"
h write(txt toCString(), txt length())

hash := h read(Algo SHA1)

"SHA-1 hash of '%s' is: " printf(txt)
for(i in 0..20) {
    "%02x" printf(hash[i])
}
println()
