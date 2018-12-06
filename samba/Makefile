data/password: data/password.gpg
	gpg -o $@ --decrypt $<

.PHONY: clean

clean:
	rm -f data/password
