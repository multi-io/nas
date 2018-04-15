data/password: data/password.asc
	gpg -o $@ --decrypt $<

.PHONY: clean

clean:
	rm -f data/password
