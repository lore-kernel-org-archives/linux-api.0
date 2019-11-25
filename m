From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v17 10/13] namei: LOOKUP_{IN_ROOT,BENEATH}: permit
 limited ".." resolution
Date: Tue, 26 Nov 2019 00:21:45 +1100
Message-ID: <20191125132145.btaxuurs2w3ldyxf@yavin.dot.cyphar.com>
References: <20191117011713.13032-1-cyphar@cyphar.com>
 <20191117011713.13032-11-cyphar@cyphar.com>
 <20191125003501.GF4203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xfjlpf4rp232ejv4"
Return-path: <libc-alpha-return-107345-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20191125003501.GF4203@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, Jonathan Corbet <corbet@lwn.net>, Christian Brauner <christian.brauner@ubuntu.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org


--xfjlpf4rp232ejv4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-25, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Nov 17, 2019 at 12:17:10PM +1100, Aleksa Sarai wrote:
> > +		if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
> > +			/*
> > +			 * If there was a racing rename or mount along our
> > +			 * path, then we can't be sure that ".." hasn't jumped
> > +			 * above nd->root (and so userspace should retry or use
> > +			 * some fallback).
> > +			 */
> > +			if (unlikely(read_seqretry(&mount_lock, nd->m_seq)))
> > +				return -EAGAIN;
> > +			if (unlikely(read_seqretry(&rename_lock, nd->r_seq)))
> > +				return -EAGAIN;
> > +		}
>=20
> Looks like excessive barriers to me - it's
> 	rmb
> 	check mount_lock.sequence
> 	rmb
> 	check rename_lock.sequence

If you like, I can switch this to

	smp_rmb();
	if (unlikely(__read_seqcount_retry(&mount_lock.seqcount, nd->m_seq)))
		return -EAGAIN;
	if (unlikely(__read_seqcount_retry(&rename_lock.seqcount, nd->r_seq)))
		return -EAGAIN;

Though I think it makes it more noisy (and this code-path will only be
hit for ".." and LOOKUP_IS_SCOPED).

> > @@ -2266,6 +2274,10 @@ static const char *path_init(struct nameidata *n=
d, unsigned flags)
> >  	nd->last_type =3D LAST_ROOT; /* if there are only slashes... */
> >  	nd->flags =3D flags | LOOKUP_JUMPED | LOOKUP_PARENT;
> >  	nd->depth =3D 0;
> > +
> > +	nd->m_seq =3D read_seqbegin(&mount_lock);
> > +	nd->r_seq =3D read_seqbegin(&rename_lock);
>=20
> Same here, pretty much (fetch/rmb/fetch/rmb)

Unless I'm mistaken, wouldn't we have to do
seqcount_lockdep_reader_access() explicitly -- so it would end up
looking something like:

	seqcount_lockdep_reader_access(&mount_lock.seqcount);
	nd->m_seq =3D __read_seqcount_begin(&mount_lock.seqcount);
	seqcount_lockdep_reader_access(&mount_lock.seqcount);
	nd->r_seq =3D __read_seqcount_begin(&rename_lock.seqcount);
	smp_rmb();

Given this code only runs once at the start of each lookup, I'm not sure
it makes much sense to expand it like that and make it look uglier.

If you really want to avoid the duplicate memory barriers in the common
case I could instead gate the rename_lock grab behind LOOKUP_IS_SCOPED
(since that's the only time it's used).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--xfjlpf4rp232ejv4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXdvVZQAKCRCdlLljIbnQ
EloCAP9GizB7Q/AkzjQ85bGLdovCLYKdqf/qIT7xsbiqpcFyAgD/QswcZX+n5/jN
nekkrDU5Lj+ZmT9lPOf3tS+I4Q4wogM=
=viit
-----END PGP SIGNATURE-----

--xfjlpf4rp232ejv4--
