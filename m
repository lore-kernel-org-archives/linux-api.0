From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v10 8/9] kselftest: save-and-restore errno to allow for
 %m formatting
Date: Sat, 20 Jul 2019 10:09:30 +1000
Message-ID: <20190720000930.g3jyjupgimptuubl@yavin>
References: <20190719164225.27083-1-cyphar@cyphar.com>
 <20190719164225.27083-9-cyphar@cyphar.com>
 <b32d95a1-8a49-65ef-4ddd-fe86a7ca01d5@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="636rtrosv3xeor7c"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b32d95a1-8a49-65ef-4ddd-fe86a7ca01d5@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <skhan@linuxfoundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger
List-Id: linux-api@vger.kernel.org


--636rtrosv3xeor7c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-07-19, shuah <shuah@kernel.org> wrote:
> On 7/19/19 10:42 AM, Aleksa Sarai wrote:
> > Previously, using "%m" in a ksft_* format string can result in strange
> > output because the errno value wasn't saved before calling other libc
> > functions. The solution is to simply save and restore the errno before
> > we format the user-supplied format string.
> >=20
> > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> [...]
> Hi Aleksa,
>=20
> Can you send this patch separate from the patch series. I will apply
> this as bug fix to 5.3-rc2 or rc3.
>=20
> This isn't part of this series anyway and I would like to get this in
> right away.

Done, and I'll drop it in v11 after the rest gets reviewed.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--636rtrosv3xeor7c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXTJbtgAKCRCdlLljIbnQ
ErjeAQDm5ltY062NGtOMR1eaop8IvTWe5GYu7R+vym5BewUWYgD9HGmujOKl8CQ5
rJXhxSxnaze1/BDj2gUmfSjSP3IJNwo=
=CHUB
-----END PGP SIGNATURE-----

--636rtrosv3xeor7c--
