From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 02/24] Add a SysRq option to lift kernel lockdown
Date: Fri, 13 Apr 2018 22:22:23 +0200
Message-ID: <20180413202222.GA4396@amd>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346389240.4030.11187964053014260180.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152346389240.4030.11187964053014260180.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-04-11 17:24:52, David Howells wrote:
> From: Kyle McMartin <kyle@redhat.com>
>=20
> Make an option to provide a sysrq key that will lift the kernel lockdown,
> thereby allowing the running kernel image to be accessed and modified.
>=20
> On x86 this is triggered with SysRq+x, but this key may not be available =
on
> all arches, so it is set by setting LOCKDOWN_LIFT_KEY in asm/setup.h.
> Since this macro must be defined in an arch to be able to use this facili=
ty
> for that arch, the Kconfig option is restricted to arches that support it.
>=20
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: x86@kernel.org

Is that good idea? Magic sysrq was meant for debugging, not for
toggling options like that. Distros are expected to turn it off.

It also works over serial consoles etc, being able to toggle security
options from serial is surprising...

> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -487,6 +487,7 @@ static struct sysrq_key_op *sysrq_key_table[36] =3D {
>  	/* x: May be registered on mips for TLB dump */
>  	/* x: May be registered on ppc/powerpc for xmon */
>  	/* x: May be registered on sparc64 for global PMU dump */
> +	/* x: May be registered on x86_64 for disabling secure boot */
>  	NULL,				/* x */

What about x86-32?

> +static struct sysrq_key_op lockdown_lift_sysrq_op =3D {
> +	.handler	=3D sysrq_handle_lockdown_lift,
> +	.help_msg	=3D "unSB(x)",
> +	.action_msg	=3D "Disabling Secure Boot restrictions",
> +	.enable_mask	=3D SYSRQ_DISABLE_USERSPACE,
> +};

I'd remove secure boot mentions here.
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrREX4ACgkQMOfwapXb+vLYtgCfRYyFGIL5TIvishDq7IHED0qR
epcAnR6WOidNb9YAVPgOJSkYW2tiiKVf
=oF26
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
