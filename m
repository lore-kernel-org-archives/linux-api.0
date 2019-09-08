From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v12 11/12] open: openat2(2) syscall
Date: Mon, 9 Sep 2019 02:24:19 +1000
Message-ID: <20190908162419.yrzm2s7rflqgdxig@yavin>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-12-cyphar@cyphar.com>
 <7236f382d72130f2afbbe8940e72cc67e5c6dce0.camel@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gzznbyzuni6ynbc5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7236f382d72130f2afbbe8940e72cc67e5c6dce0.camel@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander
List-Id: linux-api@vger.kernel.org


--gzznbyzuni6ynbc5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-07, Jeff Layton <jlayton@kernel.org> wrote:
> On Thu, 2019-09-05 at 06:19 +1000, Aleksa Sarai wrote:
> > + * @flags: O_* flags.
> > + * @mode: O_CREAT/O_TMPFILE file mode.
> > + * @upgrade_mask: UPGRADE_* flags (to restrict O_PATH re-opening).
> > + * @resolve: RESOLVE_* flags.
> > + */
> > +struct open_how {
> > +	__u32 flags;
> > +	union {
> > +		__u16 mode;
> > +		__u16 upgrade_mask;
> > +	};
> > +	__u16 resolve;
> > +};
> > +
> > +#define OPEN_HOW_SIZE_VER0	8 /* sizeof first published struct */
> > +
>=20
> Hmm, there is no version field. When you want to expand this in the
> future, what is the plan? Add a new flag to indicate that it's some
> length?

The "version number" is the size of the struct. Any extensions we make
are appended to the struct (openat2 now takes a size_t argument), and
the new copy_struct_{to,from}_user() helpers handle all of the
permutations of {old,new} kernel and {old,new} user space.

This is how clone3(), sched_[gs]etattr() and perf_event_open() all
operate (all of the sigset syscalls operate similarly but don't
gracefully handle different kernel vintages -- you just get -EINVAL).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--gzznbyzuni6ynbc5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXXUrMAAKCRCdlLljIbnQ
EgC+AQCVKXVqUiPLaSjLjt+ByWrSsopM/OM3NwCHHZ5oD+CB1gD/cSuQohVmXskg
v8dQLpd9K1QW//8GG3Aa/FRHhqPAfAU=
=G4Hw
-----END PGP SIGNATURE-----

--gzznbyzuni6ynbc5--
