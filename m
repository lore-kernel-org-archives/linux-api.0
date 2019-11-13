From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v15 6/9] namei: LOOKUP_{IN_ROOT,BENEATH}: permit limited
 ".." resolution
Date: Wed, 13 Nov 2019 18:52:27 +1100
Message-ID: <20191113075227.lu5b5uvc2nuk76uk@yavin.dot.cyphar.com>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-7-cyphar@cyphar.com>
 <20191113020917.GC26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qprdfpbfkuvffdu5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191113020917.GC26530@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian.brauner@ubuntu.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org


--qprdfpbfkuvffdu5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-13, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Nov 05, 2019 at 08:05:50PM +1100, Aleksa Sarai wrote:
>=20
> > One other possible alternative (which previous versions of this patch
> > used) would be to check with path_is_under() if there was a racing
> > rename or mount (after re-taking the relevant seqlocks). While this does
> > work, it results in possible O(n*m) behaviour if there are many renames
> > or mounts occuring *anywhere on the system*.
>=20
> BTW, do you realize that open-by-fhandle (or working nfsd, for that matte=
r)
> will trigger arseloads of write_seqlock(&rename_lock) simply on d_splice_=
alias()
> bringing disconnected subtrees in contact with parent?

I wasn't aware of that -- that makes path_is_under() even less viable.
I'll reword it to be clearer that path_is_under() isn't a good idea and
why we went with -EAGAIN over an in-kernel retry.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--qprdfpbfkuvffdu5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXcu2OAAKCRCdlLljIbnQ
EtqZAQCjNdiANKBF7WCOTHUeD48U+o/7WczR7I/1WTsCcSBp9gEA6HgEdHKRHmol
+5Fvn3Eg1Tya83fWQgWoVLu8i6CUUwE=
=voMa
-----END PGP SIGNATURE-----

--qprdfpbfkuvffdu5--
