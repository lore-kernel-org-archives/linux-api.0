From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 0/2] N900 Modem Speech Support
Date: Tue, 31 Mar 2015 22:33:41 +0200
Message-ID: <20150331203340.GA5450@earth>
References: <1426964957-5023-1-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426964957-5023-1-git-send-email-sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>, Kai Vehmanen <kvcontact-nQfqiRJ1PMYxHbG02/KK1g@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Pali Rohar <pali.rohar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aaro Koskinen <aaro.koskinen-X3B1VOXEql0@public.gmane.org>, Ivaylo Dimitrov <ivo.g.dimitrov.75-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Mar 21, 2015 at 08:09:15PM +0100, Sebastian Reichel wrote:
> This patchset contains the missing speech data support for the
> Nokia N900 modem.
>
> [...]
>
>   HSI: cmt_speech: Add cmt-speech driver
>   HSI: nokia-modem: Add cmt-speech support
>=20
>  drivers/hsi/clients/Kconfig          |   12 +-
>  drivers/hsi/clients/Makefile         |    1 +
>  drivers/hsi/clients/cmt_speech.c     | 1456 ++++++++++++++++++++++++++++=
++++++
>  drivers/hsi/clients/nokia-modem.c    |   32 +-
>  include/uapi/linux/hsi/Kbuild        |    2 +-
>  include/uapi/linux/hsi/cs-protocol.h |  113 +++
>  6 files changed, 1613 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/hsi/clients/cmt_speech.c
>  create mode 100644 include/uapi/linux/hsi/cs-protocol.h

I added the patches to my linux-hsi.git for-next branch aimed for
4.1.

-- Sebastian


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVGwShAAoJENju1/PIO/qaW6cQAI4gTKtou6io7CgSWWLL8XhR
IwyPWmkzk3B1iCLs0S1yqz63FFCe3sQ6Yk4WvHloBAvLUXRAxi5tTSTnuvB7oVk2
L6bFxW9o1GOSBnWxtSq7HaaPFZOK93ZC4awQNiEz461K5w43xKuBBpw2c1hAdU4W
iK+htqKSOWe+bmh5hhMEne4UaKe9YihBqke821hJkrxtN6nYCvsv847KYpiVDt0N
Ozexj1tvzocAvQTW9lOyNYX7yq8nASMbRGplaDBHEd7jEtmR8FVqAHbM/jE4tp2T
+ANBldZZNQ+m99uoY0bzJ2foVnCL7EZgyNdtvGlq712vNZCEoxtB9ads0RcyPYde
qTnAsLivIdLhSwL2XlQpdYwKbZ6Ivbv5y+npeGVvLX63WvH1MdMCIQ6rWlk10Nm5
82MWYwBxBi9SkIvY72jqdPbG79eco37ogmmPGfZCm0O1zosAxDatLWKPjGy/7akI
yqJBGGZur6p+2pBiQ4v4T7RsGirFjvR+qwkhU7Zl/a+ptia6tMgTLMGMYm8lFAof
brIyCLRG4ighPbBUwE+W3MzrLohwf+PfHLl9VL5JYzBmloQA1CpyqLgGNLJVhdEf
sL31dN1HnULsGc+3Ts3fw/QdFLwBJOhbXhJ6Qm9WVU0BeuTBxWCU1DdwL7/y9BbA
srvx/natcKS1l1vGt+DB
=KR0s
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
