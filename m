From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH RESEND v5 0/5] namei: vfs flags to restrict path
 resolution
Date: Tue, 26 Mar 2019 00:04:29 +1100
Message-ID: <20190325130429.dbrgjxnvq3w5cpb3@yavin>
References: <20190320143717.2523-1-cyphar@cyphar.com>
 <CALCETrV-Q4qZXGeavBPQbF6-VVz7hqvjRkbhFeYmbGiQgu5Omg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="57yveyjfb6o3za6g"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV-Q4qZXGeavBPQbF6-VVz7hqvjRkbhFeYmbGiQgu5Omg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-fo>
List-Id: linux-api@vger.kernel.org


--57yveyjfb6o3za6g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-03-21, Andy Lutomirski <luto@kernel.org> wrote:
> On Wed, Mar 20, 2019 at 7:38 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> > Now that the holiday break is over, it's time to re-send this patch
> > series (with a few additions, due to new information we got from
> > CVE-2019-5736 -- which this patchset mostly protected against but had
> > some holes with regards to #!-style scripts).
>=20
> I generally like this, but, as Linus pointed out, it will be
> unfortunate if application authors see this as just another
> non-portable weird Linux API and don't use it.  Would it be worthwhile
> to put some thought into making it an API that other OSes might be
> willing to implement?  As it stands, the openat(2) flags are getting
> rather crazy in this patch set.
>=20
> Aleksa had a resolveat(2) proposal that really didn't seem too bad.

I agree having a bunch of O_* flags for resolution feels quite ugly (and
crazy) -- but the last time I pitched resolveat(2) the reaction was
lukewarm to say the least. It's basically an O_PATHv2 and I don't know
how popular that suggestion might be. I wouldn't mind pitching it again
though (now that I have a better idea of how to handle some of the UX
worries I had).

But, if we have a resolveat(2) we'll need to add O_EMPTYPATH support for
openat(2) so that you can open scoped paths without using the
/proc/self/fd/$n trick. However, you run into reopening permission
issues (as we saw in CVE-2019-5736 and countless other CVEs). There
might be a solution for this which Andy and I have talked about
off-list.

There is also the problem of the execveat(2) attack -- which is dealt
with in patch 5 of this series. In order to scope #!-script resolution
we need to have AT_* flags for the same resolution restriction
(defeating the point of a resolveat(2) slightly).

There is an argument that we shouldn't need AT_THIS_ROOT or AT_BENEATH
support (because ideally you should be doing execve(2) in a pivot_root
anyway) but AT_NO_MAGICLINKS is pretty important -- since it allows you
to block the circumvention mm->dumpable in certain situations (as we saw
in CVE-2019-5736).

The solution Andy and I have discussed is a way to make fd-reopening (a
seemingly little-known trick outside of container runtimes) much safer
such that we don't need mitigations like AT_NO_MAGICLINKS on
execveat(2). If we assume that idea works out (I'm still trying to get a
working patch for that idea) then resolveat(2) would be sufficient and
we don't need AT_* flags on execveat(2).

tl;dr: I think resolveat(2) is much nicer, and assuming it's not an
	   unpopular idea I think we should go for it. But there are several
	   other threads of discussion that we might want to have first
	   (such as how to improve the fd-reopening design so it's safer
	   before we expose it to everyone).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--57yveyjfb6o3za6g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb6Gz4/mhjNy+aiz1Snvnv3Dem58FAlyY0doACgkQSnvnv3De
m5/H1Q//S6p57BAirsEx/gjAUOkKIGGK1zQ034Jjplmx7/gAOWKECS86LhV9c6We
IBDVMVXfeG+iL7yRT7lk2wRTwpeB4DBrqrqD2lpDj2dhzB8b8yzPU4rY027k5r+e
L/caAoPI6X0NX1nyFiK3MkuQtUNR0GbBI1LOwdwcxFDH0SrCNOrJMCD2VSOtVo5Z
ktHED0T7KIEDdwS9ZTvEw4yhaxyWhoNGj/V5uU8av1Hbceq8MIxW+Y7aUytr9l4d
XT0VJWaC9cjEuZWzmZDuZlqTFKFuiupHgE22O4prPJZOAhOMiqrQr76hbSz1ChbN
iFsHU7JYnUcFd1rPhKwI25kKq2eGWvaj0VLCylQ/ZluMRLPrD3blYJYB9BYIaSss
XVn9rjdRJG5t3tNKOMEDF9GYuVAE5w9Y+ZZJ1l8eZlUf3C7V6jISDkzvtfYu7xs+
ish7dFWE3CKrrMJR9eR2zQ0ZoFicCPxBkp7beThQ7JVV24gno7EMS+wF7NdNHKFc
HwWq6hk1e9wh2FHxQfvloBlFr2FV+lGWhFNFdZ0LzOFJu5Swa1BsPn93KoHi2T7F
5XK+WAQBtzWuq7J8GN8T9LlhMlXs11QH6FKzt/vsuwEV35M3F4tKgur81bfkdsau
w+prkX7aetu9qGthO9AFicPDXOXY6HyBcPTDMbGNkHz2/zILvpY=
=Hj/g
-----END PGP SIGNATURE-----

--57yveyjfb6o3za6g--
