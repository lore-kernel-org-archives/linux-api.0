From: Richard Yao <ryao-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Mon, 01 Dec 2014 23:31:27 -0500
Message-ID: <547D409F.7090004@gentoo.org>
References: <20141129063416.GE32286@woodpecker.gentoo.org> <20141201142311.37c81ff1@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141201142311.37c81ff1-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/01/2014 09:23 AM, One Thousand Gnomes wrote:
>> told quite plainly that such distributions are not worth consideration=
=2E If kdbus
>> is merged despite concerns about security and backward compatibility, =
could we
>> at least have the shim moved to libc netural place, like Linus' tree?
>=20
> I would expect any other libc would fork the shim anyway (or just not
> bother with systemd in most cases).

If the shim were in glibc, then that would be reasonable, but the shim
is in systemd. That would make the systemd developers the gate keepers
ta kernel interface. If we are going to enforce Linus' stable API
policy, then the shim should be in a repository that has a track record
for interface stability, which the systemd developers simply do not
have. It was not that long ago that firmware loading was moved into the
kernel because they had caused problems. I do not think that the systemd
developers are the correct ones to assume stewardship over such code. If
kdbus is merged, I think the best situation would be to move it into
Linus' tree.


--tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUfUCtAAoJECDuEZm+6ExkSlEQAJqpYK86k19nl/6ETvzkS0Np
Il9FpkT91xfhQq+Ur35ex7fdrGAgFTk+Fl5zDyQT9goSPN3G2z3wDBpgcsCGlPK9
JGFWcUOXfccOSpn361UkoYsh0LoNdvO427uHpAw8gLJH+xo19nPJpQqjeQx050gT
4ricEEFs2RfPwYUBi0/8vSBTaOtTZNBC/TnuuiFDGTj71DguRirmOpeOd+U2KQMm
s4ztABqMtm7RnCdyAVsjiiKz/c6DNSaQ0hRidQHVPNnzNr6vhJZUFt3Dvw3zmFQq
YPTy6DCqEMOOd3YligsVf1UNepWWAVsm/BtoNfMBMrcGJbpHjCDw7hC/R5sUfaRB
1FerHJAOf9Ldk9pFf0V75JyUALvPL3Wb0LJcHt1udBBP2kFdsu/DlZOpL2so16BI
/jYSdAwkBUaH7T/g0fvem9Nt4daTc+cvwTP6XthCr6vsEZc4C2EyKkZSCUzywcqa
rBI8kMDEtGStaLKZV+QaFtUi+v22QdYLu9jc1FKkD5Ljaxb3nX0InpxoQGzXC0li
kfw1PXjbBGj7MDJtoXoByulg5bU/afxU6TolXtSmfD2iJiTUJL5NR2wjJEwWrFaM
UHCgzvVUdfbS4toiUpTKdMazKNQuzNTSKUY+VwTM9WQyiI8C2hIOfellx0E/timO
HHtAeSi+JvInBYL9vV5/
=N/OZ
-----END PGP SIGNATURE-----

--tS9NJEJItXTghmmhX0AdBmqND2G4KcK7g--
