data/password: data/password.gpg
	gpg --quiet --keyid-format LONG --no-tty --output $@ --decrypt $<

.PHONY: clean

clean:
	rm -f data/password
