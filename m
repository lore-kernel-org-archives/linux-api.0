From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v9 08/10] open: openat2(2) syscall
Date: Fri, 19 Jul 2019 12:19:31 +1000
Message-ID: <20190719021931.ypwvcvp3imbgjjx6@yavin>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-9-cyphar@cyphar.com>
 <20190719015933.GA18022@altlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g4nevyq6aunc32xc"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190719015933.GA18022@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-f
List-Id: linux-api@vger.kernel.org


--g4nevyq6aunc32xc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-07-19, Dmitry V. Levin <ldv@altlinux.org> wrote:
> On Sun, Jul 07, 2019 at 12:57:35AM +1000, Aleksa Sarai wrote:
> [...]
> > +/**
> > + * Arguments for how openat2(2) should open the target path. If @extra=
 is zero,
> > + * then openat2(2) is identical to openat(2).
> > + *
> > + * @flags: O_* flags (unknown flags ignored).
>=20
> What was the rationale for implementing this semantics?
> Ignoring unknown flags makes potential extension of this new interface
> problematic.  This has bitten us many times already, so ...

I am mirroring the semantics of open(2) and openat(2).

To be clear, I am in favour of doing it -- and it would definitely be
possible to implement it with -EINVAL (you would just mask off
~VALID_OPEN_FLAGS for the older syscalls). But Linus' response to my
point about (the lack of) -EINVAL for unknown open(2) flags gave me the
impression he would be against this idea (though I might be
misunderstanding the point he was making).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--g4nevyq6aunc32xc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXTEorwAKCRCdlLljIbnQ
Eop3AQDsS+JxsKMay74AdwHvqjPK3crvN47y0krPsv6vGBsWhQD/f+ChPlnwx226
SbxKk/nCjHvnDSJga0WPUznn7tBxUQQ=
=7H8a
-----END PGP SIGNATURE-----

--g4nevyq6aunc32xc--
