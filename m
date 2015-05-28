From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PATCH] mei: fix up uuid matching
Date: Fri, 29 May 2015 00:40:45 +1000
Message-ID: <20150529004045.63dbd39b@canb.auug.org.au>
References: <1432741333-11889-1-git-send-email-tomas.winkler@intel.com>
	<20150527165054.GB3533@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B3C4A2C8C@hasmsx109.ger.corp.intel.com>
	<20150527172919.GA5525@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B3C4A2CDF@hasmsx109.ger.corp.intel.com>
	<20150527231420.GA29446@kroah.com>
	<20150527232254.GA8737@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B3C4A3096@hasmsx109.ger.corp.intel.com>
	<20150528001727.GB2033@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/a6MsKUCfgywkka2EgJljgTt"; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528001727.GB2033-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--Sig_/a6MsKUCfgywkka2EgJljgTt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 27 May 2015 17:17:27 -0700 Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wro=
te:
>
> From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
>=20
> A previous commit, c93b76b34b4d ("mei: bus: report also uuid in module
> alias") caused a build error as I missed applying a needed patch to add
> some macros to uapi/linux/uuid.h.  Instead of those additional macros,
> change the mei code to use the existing uuid structure directly.
>=20
> Fixes: c93b76b34b4d
> Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

I added this to linux-next today (well, yesterday now :-)).
--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Sig_/a6MsKUCfgywkka2EgJljgTt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVZyjzAAoJEMDTa8Ir7ZwVu5MQAJE+R+te51L8jLel1yIg4iM6
wbxXXVoBHmj196Q+8GKUHQjFFmkoQKHtZa6GDp9dqVYB2xciCDbeFzJzuQYrLQlL
/SqHPnxKysdriYF2dM5N1XA2L0log3MJ8FH1TdY7JRL+Vjn94drNRnAfdAeHQafo
ay9N4bsmGYZROzsMZnGiC7QVwafHxBBHPjHY5UVy9fMkq5UzYgaHk9lbZums0qfr
B6bWa5gNUNsfGdi30zaLV6UnYWw/qQXnNym2B2uFQ7HHzaQMa4MMbFPaulj/uscW
fuzDJgbiCyMAzYlLcJgihZlBv9pelAs1MV/0lmOBAPDfDHNJYGmVcfq8GXLcYPNY
YkFuX6gZA+uD/rH6AikQWCCOiOz4ep6fcIFHjNxZKSBaxqBAS4TZIiUYohPGeHIC
g95xs0ShQEleC5S5MMQ8kA9Meb53S3EI6Jcq8pYsaLSvp4aG40KoXVoQeq8d/bhR
t3etdLG0YjJ9vKQ/tU8tK2W95jEzFbKpLVo7sFHy4wnfBSwS+9i1kRSUcoHh9H9D
bSmSyi8RfHyZqSAuktkZ7wehAGp0myCOVQffTMvnMqR8VYo19mNEyru6nFpQnvty
Nb/udK3u9G7odxKuHgcjMfLDtxiL98rI7REHh2qWArZ1kgLMDCi2vJychXy9LoSm
6S/Z/ZK9IYEB1AcdGXma
=SIbK
-----END PGP SIGNATURE-----

--Sig_/a6MsKUCfgywkka2EgJljgTt--
