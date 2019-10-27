From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH RESEND v14 2/6] namei: LOOKUP_IN_ROOT: chroot-like path
 resolution
Date: Mon, 28 Oct 2019 02:41:15 +1100
Message-ID: <20191027154115.ex55njkysey4m6pu@yavin.dot.cyphar.com>
References: <20191026185700.10708-1-cyphar@cyphar.com>
 <20191026185700.10708-3-cyphar@cyphar.com>
 <CAHk-=wjPPWvm5_eR4uaHJaU1isTUk-4iXQV3Z2Px9A+w6j2nHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x254sstnuxqz6cbi"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wjPPWvm5_eR4uaHJaU1isTUk-4iXQV3Z2Px9A+w6j2nHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>Alexander Shishkin <a>
List-Id: linux-api@vger.kernel.org


--x254sstnuxqz6cbi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-27, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Sat, Oct 26, 2019 at 2:58 PM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >
> > +       /* LOOKUP_IN_ROOT treats absolute paths as being relative-to-di=
rfd. */
> > +       if (flags & LOOKUP_IN_ROOT)
> > +               while (*s =3D=3D '/')
> > +                       s++;
> > +
> >         /* Figure out the starting path and root (if needed). */
> >         if (*s =3D=3D '/') {
> >                 error =3D nd_jump_root(nd);
>=20
> So I'm still hung up on this.
>=20
> I guess I can't help it, but I look at the above, and it makes me go
> "whoever wrote those tests wasn't thinking".
>=20
> It just annoys me how it tests for '/' completely unnecessarily.
>=20
> If LOOKUP_IN_ROOT is true, we know the subsequent test for '/' is not
> going to match, because we just removed it. So I look at that code and
> go "that code is doing stupid things".

Okay, fair enough.

> That's why I suggested moving the LOOKUP_IN_ROOT check inside the '/' tes=
t.
>=20
> Alternatively, just make the logic be
>=20
>         if (flags & LOOKUP_IN_ROOT) {
>                .. remove '/'s ...
>         } else if (*s =3D=3D '/') {
>                 .. handl;e root ..
>=20
> and remove the next "else" clause

I've gone with the latter since I think it reads better.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--x254sstnuxqz6cbi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXbW6lwAKCRCdlLljIbnQ
EoPNAP0TH7raCw5NCLFnqJEAJ2bl+pDz8oGtxQKGtoXC7HohOQEAqFv71cuFJjle
mvHPyKwhvNv8coIv55o8qUxny+XxIAg=
=0iVb
-----END PGP SIGNATURE-----

--x254sstnuxqz6cbi--
