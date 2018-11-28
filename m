From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Wed, 28 Nov 2018 11:45:34 -1000
Message-ID: <20181128214534.xxqoyy7mi5dw54kj@gmail.com>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z6lftnd4otlm67ut"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119103241.5229-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>, Joey Pabalinas <joeypabalinas@gmail.com>
List-Id: linux-api@vger.kernel.org


--z6lftnd4otlm67ut
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 19, 2018 at 11:32:39AM +0100, Christian Brauner wrote:
> +	if (info) {
> +		ret =3D __copy_siginfo_from_user(sig, &kinfo, info);
> +		if (unlikely(ret))
> +			goto err;

What's the reason you don't propagate up the errors from __copy_siginfo_fro=
m_user()?
Granted, I admit that -E2BIG is kind of weird to return, but -EFAULT seems =
like a
fairly sane error.

Or is there some reason it's more useful to just return -EINVAL for all of =
the
failure cases here?

--=20
Cheers,
Joey Pabalinas

--z6lftnd4otlm67ut
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEENpTlWU2hUK/KMvHp2rGdfm9DtVIFAlv/DH0ACgkQ2rGdfm9D
tVJCLRAAx/hb15R5NTBk/RrIx/ZB+Ftn5+bixm6/+Ihy7Q3aJGoxmWlwS0nBkWaB
lHMsrBtxihHOo4za4ttgCawNnrdL1pooh04owHU+3YEVIJOZ5tdQLVvSVGtIPi4Z
Hclg6orB1w5f/RGCYLKARyrMnNpNstNb8zvdLswfKu8g4Wl44uBj603IaO3h47Or
rbsTWfBpuF2s8iS7KlFMKMjboYkOI8Gv9wsv79CcvFhGmTR+hTnT4xqvUk/hULbI
shCz/jfsNf0mu3FoAW/ac9tl/xswoT+Yr1L26KOeQGyB7D3Pme0f89JXwgBELAVD
LXnzvBzDxzm0Ly2Va57SVcqfn7lCxifLpG2FwHWohedG7CIbba0A+bUk/ZvN6AAI
3r7aVxUSEsRBRKXSKvv0uCI59GaetcZK3Cc4cmc+bbQNdKMBLSHxuAzKFhsjo5HV
2hXFnKZDEBApNRFcHZZdiZzczgd4VNabY5AA73iHqgiai43wHew8VfjiqyHKRwoa
6q7LEiA/MbxLMH84p4V5QbmjvFh/TxVX813YoHr0ZKmm+iRHSswPkYnRUF/KPalc
DW8JtP8gm0dX3GiIpKthB9VzTa/opcQEjVeUFWu8o2tD4yT/bMB8Xfqg/Rbt9ioJ
zfdX/lhZxVXFqM81qWlBeYAGMZKO3+ui+1jFjal5OLwHWnUwNAM=
=1lIC
-----END PGP SIGNATURE-----

--z6lftnd4otlm67ut--
