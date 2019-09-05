From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Thu, 5 Sep 2019 21:27:18 +1000
Message-ID: <20190905112718.ojg3znly6x3m4mjq@yavin.dot.cyphar.com>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905110915.4vvhicg4ldmpi5u6@wittgenstein>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nkbo7v76ghbobp4m"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190905110915.4vvhicg4ldmpi5u6@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg
List-Id: linux-api@vger.kernel.org


--nkbo7v76ghbobp4m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-05, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> On Thu, Sep 05, 2019 at 06:19:22AM +1000, Aleksa Sarai wrote:
> > A common pattern for syscall extensions is increasing the size of a
> > struct passed from userspace, such that the zero-value of the new fields
> > result in the old kernel behaviour (allowing for a mix of userspace and
> > kernel vintages to operate on one another in most cases). This is done
> > in both directions -- hence two helpers -- though it's more common to
> > have to copy user space structs into kernel space.
> >=20
> > Previously there was no common lib/ function that implemented
> > the necessary extension-checking semantics (and different syscalls
> > implemented them slightly differently or incompletely[1]). A future
> > patch replaces all of the common uses of this pattern to use the new
> > copy_struct_{to,from}_user() helpers.
> >=20
> > [1]: For instance {sched_setattr,perf_event_open,clone3}(2) all do do
> >      similar checks to copy_struct_from_user() while rt_sigprocmask(2)
> >      always rejects differently-sized struct arguments.
> >=20
> > Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
>=20
> I would probably split this out into a separate patchset. It can very
> well go in before openat2(). Thoughts?

Yeah, I'll split this and the related patches out -- though I will admit
I'm not sure how you're supposed to deal with multiple independent
patchsets that depend on each other. How will folks reviewing openat2(2)
know to include the lib/struct_user.c changes?

Also, whose tree should it go through?

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--nkbo7v76ghbobp4m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXXDxEwAKCRCdlLljIbnQ
EqovAQD8WBncNVUTEL0Y3xtDhqYMDFHga+X5xWtEwl2PAh4uVQEAhuzdaAU+gBqt
VqtP9IF4PFfoqMmGbekI1BKCWI4gmgo=
=UsGw
-----END PGP SIGNATURE-----

--nkbo7v76ghbobp4m--
