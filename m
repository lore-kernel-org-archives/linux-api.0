From: Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Why no flag to unlink a file on creation?
Date: Tue, 27 Mar 2012 15:29:30 +0200
Message-ID: <1332854971.15139.10.camel@Jann-PC.fritz.box>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Ku/9p2O4K6NUQD4ZpSkt"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-Ku/9p2O4K6NUQD4ZpSkt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,
I'm not too familiar with the internals of the kernel, so this question
might be stupid, and I'm not sure whether this is the right place to ask
about it, but anyway:
Why is there no flag for the "open" syscall to specify that you want the
file you're opening to be deleted? I think that it would be very useful
in combination with O_CREAT - you could create temporary files without
actually leaving files on the filesystem, given that the filesystem
supports it.

Jann Horn

--=-Ku/9p2O4K6NUQD4ZpSkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPccC6AAoJEGhmizV0f2d1UkwP/24n40Duxjb7OwkCWY5og69V
/9k2AI0uDNzRhUjrUlCn3GHkINu26E3eoyBUZ8SedETLccaHvJqAGBT3Acnj4w/1
tJTMcPbH4nnFRu+auhgnUXZfsqDk1P4wOA33Up2CzrRRUFTW9aT0F69SjHHhpMke
cIAKlGsoVfkKS8R9HMyBYu82edSeoOZQPcPbhFU5H2WapfyzoQ8Z8xMvERyDaV4d
mKx9WKiPy+sBtmfoGTrJ2S6UFQXJ7PUb1PTgshTbhCvo+lUnOlUUqg4R/2C4DQMk
SON6bO10oJGL5EH+wfuLN1sIg4one1ceizZFcAzNWP6L8W6suFo4PJjYN+XQNfkC
pwuEBPq8yY3uMML2Jis2qnLF8N+44i0mIVZ0zbj5ULGO3W3sqXGStd/9A86xlCbz
GlbniUZScpC7d77V5Od5DxuWmirj9wwhIwjuwh1Y1s6X0Gabdd93D/kf1ftqPwp0
0wtjQ1JWnLgWanV67kIt0Bt4wS7jjT3k2nD0I5wFisdc03g7RTd/eTRHhNqXh+tk
1tkt3aU6EW/6iJQIVzcEN1Isqquv2RTVMKgEIDZEeJ2ji2TSi9fipqqzwMTG6vmJ
PtZZmZCO7CB9NmZx6Sk1WF5LX2/WTkfulk8tlq2tshI4R8mQGRBPCJp7kebv05YP
TWz0J2GEK0PQhiJCyR12
=ONia
-----END PGP SIGNATURE-----

--=-Ku/9p2O4K6NUQD4ZpSkt--
