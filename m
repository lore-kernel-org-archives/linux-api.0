From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v17 08/13] namei: LOOKUP_BENEATH: O_BENEATH-like scoped
 resolution
Date: Mon, 25 Nov 2019 17:03:48 +1100
Message-ID: <20191125060348.bkdlxvoacdeyy6od@yavin.dot.cyphar.com>
References: <20191117011713.13032-1-cyphar@cyphar.com>
 <20191117011713.13032-9-cyphar@cyphar.com>
 <20191125002604.GE4203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="n5oan2cpdmv3a5ir"
Return-path: <libc-alpha-return-107328-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20191125002604.GE4203@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, Jonathan Corbet <corbet@lwn.net>, Christian Brauner <christian.brauner@ubuntu.com>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>
List-Id: linux-api@vger.kernel.org


--n5oan2cpdmv3a5ir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-25, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Nov 17, 2019 at 12:17:08PM +1100, Aleksa Sarai wrote:
>=20
> > +	if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
> > +		/*
> > +		 * Do a final check to ensure that the path didn't escape. Note
> > +		 * that this should already be guaranteed by all of the other
> > +		 * LOOKUP_IS_SCOPED checks (and delaying this check this late
> > +		 * does open the door to some possible timing-based attacks).
> > +		 */
> > +		if (WARN_ON(!path_is_under(&nd->path, &nd->root)))
> > +			return -EXDEV;
>=20
> I don't like that.  What it gives is an ability to race that with
> rename(), with user-triggered WARN_ON.  You *can't* promise that result of
> lookup is in a subtree, simply because it can get moved just as you've
> declared it to be in the clear.
>=20
> 	Anyone who relies upon that is delusional; it really can't be done.
> What warranties LOOKUP_IS_SCOPED is really supposed to provide?  That we =
do not
> attempt to walk out of the subtree rooted at the start point?  Fine, but =
this
> is not what this test does.  What are you trying to achieve there?  If it=
's
> "what we'd got was at one point in our subtree", the test is more or less
> right, but WARN_ON isn't.

You're right that (looking at this again) this chunk doesn't make too
much sense -- though I still think it wouldn't be a bad idea to include
it without the WARN_ON.

The reason I added it was as an attempt to have a last-chance check to
make sure we don't hand out a file descriptor to userspace that is
outside nd->root as a result of some yet-unknown namei bug (hence the
WARN_ON). But you're quite right that I overlooked that user-space could
trigger this maliciously.

Regarding the warranties LOOKUP_IS_SCOPED is supposed to provide --
arguably the guarantee is meant to be "you never step outside the root
during lookup" but that should already be implemented with the
handle_dots() checks -- and it's not something you could easily check at
the end of a lookup anyway. The idea was that (if for some reason those
checks were bypassed), at the very least you wouldn't silently get a
file descriptor which is completely outside the root.

Looking at this again, I can see the argument that check this shouldn't
be done at all -- but I will admit that I feel more comfortable with the
guarantees of LOOKUP_IS_SCOPED if we had some kind of last-chance check
to avoid a privileged process opening /etc/shadow on the host. Then
again, libpathrs (which I assume will be the primary consumer of
LOOKUP_IN_ROOT) already does a double-check in userspace after getting
the file descriptor from openat2().

All of that being said, I'd be happy to drop it entirely if you feel
it's unnecessary.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--n5oan2cpdmv3a5ir
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXdtuwQAKCRCdlLljIbnQ
EhgrAQCziGLc25C4Hq/hsTYZTCJzE1b4oLj4e/P/0nPg2wdhrgD9GKxS3kIpRVhT
Rq6CsaKi+Hr4YN+hVfgGVHLHAPRTRQA=
=7pdt
-----END PGP SIGNATURE-----

--n5oan2cpdmv3a5ir--
