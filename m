From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PATCH resend] define convenient securebits masks for prctl
 users
Date: Thu, 29 Oct 2009 13:33:06 +1100
Message-ID: <20091029133306.0cb87521.sfr@canb.auug.org.au>
References: <20091028140236.GA8157@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091028140236.GA8157-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Serge,

On Wed, 28 Oct 2009 09:02:36 -0500 "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wro=
te:
>
> [ Are there any objections to exporting securebits.h?  If not,
> can this patch be pushed to linux-next? ]

I am not sure which tree this belongs in?  Maybe security-testing (James
cc'd)?

> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> index d2c5ed8..9ad109e 100644
> --- a/include/linux/securebits.h
> +++ b/include/linux/securebits.h
> @@ -1,6 +1,13 @@
>  #ifndef _LINUX_SECUREBITS_H
>  #define _LINUX_SECUREBITS_H 1
> =20
> +/* Each securesetting is implemented using two bits. One bit specifies
> +   whether the setting is on or off. The other bit specify whether the
> +   setting is locked or not. A setting which is locked cannot be
> +   changed from user-level. */
> +#define issecure_mask(X)	(1 << (X))
> +#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))

You want this second define protected by ifdef __KERNEL__ ...

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkro/uIACgkQjjKRsyhoI8yk8QCeOoAWptTrIocoGY3N4tFvjm8V
x6IAn1cgPDdSHCN1l5R4jjupgbkeSAyw
=9xpe
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Oct_2009_13_33_06_+1100_5x.aSldZ3w=VkIqU--
