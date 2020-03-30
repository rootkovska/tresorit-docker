#!/bin/sh

# Before the signature, the file should always look like "#!/bin/sh\nSIGNATURE="
(echo "#!/bin/sh"; echo -n "SIGNATURE=") > tresorit_installer.run.beginning
if ! (head -c20 tresorit_installer.run | cmp tresorit_installer.run.beginning); then
	echo "Verification Failure"
	rm tresorit_installer.run.beginning
	exit 1
fi
rm tresorit_installer.run.beginning

# After the signature, there should be a single "\n" character that is not yet part of the signed data
echo > tresorit_installer.run.aftersig
if ! (head -c1045 tresorit_installer.run | tail -c1 | cmp tresorit_installer.run.aftersig); then
	echo "Verification Failure"
	rm tresorit_installer.run.aftersig
	exit 1
fi
rm tresorit_installer.run.aftersig

# We always use the following RSA4096 public key to sign the installers
cat >tresorit_installer.run.pubkey <<EOF
-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA46jwuhBANq+z/HLdYloM
oX90z8UXccdTjHTKHYmPcPrgccWqA7sXqq/fyBUJ/awbHEE1m9lga/3S1YbyFYae
R67i6GnAv7wDDJhGxGqvALZtS26f16ndLGtb50YsrmPmCXgdIPHg3StHjresSt3+
YeIBUGRozujUPh4H03Y60IfyB0JyppcwKWVLIH3iSgUwTRqy9XM+BHHOyKgvO9zg
9+70isP9e9zDdEOxQmI//jfJD0B/iMDPO+6NZq2q/z92qwmZoZF1hQ/AKtqoA32t
8hpQH/d4IAFDfnCTGtUvWj8h/Q6JZAhldJy3DVKoGvbCV+zjqx387Qkbl/S4M7/Z
FYxzGSC2SO2TsstxfgEetWTMpME506P/Xqv5/maK8BoR3wEr8naM50ItFyXFqb2h
t28gqvkF383wu1sfASp0S/HjQT5AgdeAo6cTOwijSN4cOeUtwnfPGm6g+5MBIJ2e
Hm5elqahcUfjEsO43UrE7MCjCN9ADtoFuwz57yCyn8iTvUI0MWvOs8D23/7/ndck
5y1dOHJh0m1TZem5A+g2Qc6Sc2fcv1JR9Jm6WmLEmPShCEBNol6ET1dOA/MJu5NP
eIkhUW4uIlBOj1OXBCNxXsxMenSlpqKPBHQDl6GeLKLCMyDykdiq8xLpnWof7KJ7
Kt2BpQeap4WYLKGo3MukKfcCAwEAAQ==
-----END PUBLIC KEY----- 
EOF

# The signature is always at character position 21..1044 in hex form
head -c1044 tresorit_installer.run | tail -c+20 | xxd -r -p > tresorit_installer.run.signature

# We have to check the validity of the rest of the file
# This openssl call will print either "Verified OK" or "Verification Failure"
tail -c+1046 tresorit_installer.run | openssl sha512 -verify tresorit_installer.run.pubkey -sigopt rsa_padding_mode:pss -sigopt rsa_pss_saltlen:-1 -signature tresorit_installer.run.signature
rm tresorit_installer.run.signature
rm tresorit_installer.run.pubkey
