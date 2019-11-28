From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v17 10/13] namei: LOOKUP_{IN_ROOT,BENEATH}: permit
 limited ".." resolution
Date: Thu, 28 Nov 2019 21:10:23 +1100
Message-ID: <20191128101023.zozsfq4kbhjyethg@yavin.dot.cyphar.com>
References: <20191117011713.13032-1-cyphar@cyphar.com>
 <20191117011713.13032-11-cyphar@cyphar.com>
 <20191125003501.GF4203@ZenIV.linux.org.uk>
 <20191125132145.btaxuurs2w3ldyxf@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cht5i7oy766zupq7"
Return-path: <libc-alpha-return-107499-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20191125132145.btaxuurs2w3ldyxf@yavin.dot.cyphar.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, Jonathan Corbet <corbet@lwn.net>, Christian Brauner <christian.brauner@ubuntu.com>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org


--cht5i7oy766zupq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-26, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2019-11-25, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sun, Nov 17, 2019 at 12:17:10PM +1100, Aleksa Sarai wrote:
> > > +		if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
> > > +			/*
> > > +			 * If there was a racing rename or mount along our
> > > +			 * path, then we can't be sure that ".." hasn't jumped
> > > +			 * above nd->root (and so userspace should retry or use
> > > +			 * some fallback).
> > > +			 */
> > > +			if (unlikely(read_seqretry(&mount_lock, nd->m_seq)))
> > > +				return -EAGAIN;
> > > +			if (unlikely(read_seqretry(&rename_lock, nd->r_seq)))
> > > +				return -EAGAIN;
> > > +		}
> >=20
> > Looks like excessive barriers to me - it's
> > 	rmb
> > 	check mount_lock.sequence
> > 	rmb
> > 	check rename_lock.sequence
>=20
> If you like, I can switch this to
>=20
> 	smp_rmb();
> 	if (unlikely(__read_seqcount_retry(&mount_lock.seqcount, nd->m_seq)))
> 		return -EAGAIN;
> 	if (unlikely(__read_seqcount_retry(&rename_lock.seqcount, nd->r_seq)))
> 		return -EAGAIN;
>=20
> Though I think it makes it more noisy (and this code-path will only be
> hit for ".." and LOOKUP_IS_SCOPED).
>=20
> > > @@ -2266,6 +2274,10 @@ static const char *path_init(struct nameidata =
*nd, unsigned flags)
> > >  	nd->last_type =3D LAST_ROOT; /* if there are only slashes... */
> > >  	nd->flags =3D flags | LOOKUP_JUMPED | LOOKUP_PARENT;
> > >  	nd->depth =3D 0;
> > > +
> > > +	nd->m_seq =3D read_seqbegin(&mount_lock);
> > > +	nd->r_seq =3D read_seqbegin(&rename_lock);
> >=20
> > Same here, pretty much (fetch/rmb/fetch/rmb)
>=20
> Unless I'm mistaken, wouldn't we have to do
> seqcount_lockdep_reader_access() explicitly -- so it would end up
> looking something like:
>=20
> 	seqcount_lockdep_reader_access(&mount_lock.seqcount);
> 	nd->m_seq =3D __read_seqcount_begin(&mount_lock.seqcount);
> 	seqcount_lockdep_reader_access(&mount_lock.seqcount);
> 	nd->r_seq =3D __read_seqcount_begin(&rename_lock.seqcount);
> 	smp_rmb();

Actually, looking it again (unless I'm mistaken) the following should be
acceptable and it also avoids the extra fetch+rmb of mount_lock for
LOOKUP_ROOT. The only downside is that we don't get lockdep information
but path_init() already ignores lockdep when grabbing d_seq.

I will include the following in v18, but let me know if I'm missing
something obvious:

 >>	nd->m_seq =3D __read_seqcount_begin(&mount_lock);
 >>	nd->r_seq =3D __read_seqcount_begin(&rename_lock);
 >>	smp_rmb();

	if (flags & LOOKUP_ROOT) {
		struct dentry *root =3D nd->root.dentry;
		struct inode *inode =3D root->d_inode;
		if (*s && unlikely(!d_can_lookup(root)))
			return ERR_PTR(-ENOTDIR);
		nd->path =3D nd->root;
		nd->inode =3D inode;
		if (flags & LOOKUP_RCU) {
 >>			nd->seq =3D raw_read_seqcount_begin(&nd->path.dentry->d_seq);
			nd->root_seq =3D nd->seq;
		} else {
			path_get(&nd->path);
		}
		return s;
	}

I could also move the smp_rmb() to after LOOKUP_ROOT (and add an
smp_rmb() at the end of LOOKUP_ROOT) which would avoid a double-rmb for
LOOKUP_ROOT -- but it makes it harder to read IMHO.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--cht5i7oy766zupq7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXd+dDAAKCRCdlLljIbnQ
EreMAP9MQFDKw7S61GLLYRtaPZcDlVuOaaxmgShfXuqNXAGMGwD9EZ9ag0BaUOMg
K4PtLhUUkb1jF+Ff2LBWG3EOxsSD2AY=
=bnEH
-----END PGP SIGNATURE-----

--cht5i7oy766zupq7--
