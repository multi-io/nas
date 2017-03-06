encrypt:

echo -n 'xxxpassword' | gpg --quiet --keyid-format LONG --group encryption='<public key name (email)>' --no-tty --recipient encryption --trust-model always --yes --output - --encrypt - >password.gpg

