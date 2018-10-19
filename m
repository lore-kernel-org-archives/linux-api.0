From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] uapi: get rid of STATX_ALL
Date: Thu, 18 Oct 2018 19:45:42 -0600
Message-ID: <0D6DD0B3-038B-4B71-9170-9D0B4F3DF3FA@dilger.ca>
References: <20181018131125.6303-1-mszeredi@redhat.com>
 <20181018131125.6303-2-mszeredi@redhat.com>
 <875zxzxuo9.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DD612644-90ED-48E1-A7B5-4B1E2963187D";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <875zxzxuo9.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_DD612644-90ED-48E1-A7B5-4B1E2963187D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


> On Oct 18, 2018, at 7:15 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
>=20
> * Miklos Szeredi:
>=20
>> #define STATX__RESERVED		0x80000000U	/* Reserved for =
future struct statx expansion */
>=20
> What about this?  Isn't it similar to STATX_ALL in the sense that we
> don't know yet what it will mean?

No, this means that this last bit will be used for increasing the size =
of the
stx_mask field at some point in the future.  IMHO, this is present as a =
reminder
to any developer who is adding fields in the future not to use the last =
flag.

Cheers, Andreas






--Apple-Mail=_DD612644-90ED-48E1-A7B5-4B1E2963187D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlvJN0cACgkQcqXauRfM
H+Dw4A//SnFFHram0lK6mF0/fJJR8V/m3TMHlh04irQNChXF2k/K3Km17uIAiKdB
NYf9hl63pjNuUb96hKQwNVy+Q4mvh5hf1WbzRn6E+Sw1mjrjuwLc8L79xd/UoxSP
1tJcetX4SIAvzDFEE4LYaiOykM5FgaoFCalxM7i92bg6vU07QGcfUTYd+Nzc+c8h
GQLHmigmhfKdNaBte+8iQ29V7ZjKK31idulCRkPOXMzbrDINrgmarluiNQh9XSg2
/j/LfcWaaQlwVSWOT50yyK3m9y202RjCKISO7kN7/Nal44iMgAZm575iJmXOUCBg
Db7gLHh55ogjx4jpf0PByL4Iq+0nu+5lRjO2XhzfLQEKu4zoWhCUfelR/SWhbxSv
JqxR0eDPvQW0L34h/7HLH1jAQHnXCeANhjDOyc1ZxB3oSgg8pPNfUmvyTYJ3JF0N
Rhzi9teyZyEP0wM8VSjlsiNo/n2Xqkx2Nsgx18tHy7246PKJmOX867RoleK8YZB0
J3Ak5i6xh6wQpPpIFpZ5X8vdLKmtCM7svukw5jAtLJxPUG+dH4dVDzTpaqu8Ytv7
I9FmDlXciyYVKUiIRJKD3/ZAOW9k1YRTneqVox+ejo79kOmX0Riv+CQVVHnD02x/
jPdRs60BFlHeOKoEH2OFrJB5uSS0+tKA2jDuPf7mTStbgVYl1Kk=
=6UQp
-----END PGP SIGNATURE-----

--Apple-Mail=_DD612644-90ED-48E1-A7B5-4B1E2963187D--
