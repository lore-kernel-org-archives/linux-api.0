From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v16 06/12] namei: LOOKUP_NO_XDEV: block mountpoint crossing
Date: Sun, 17 Nov 2019 04:24:15 +1100
Message-ID: <20191116172415.brmuonasi3ef6leg@yavin.dot.cyphar.com>
References: <20191116002802.6663-1-cyphar@cyphar.com>
 <20191116002802.6663-7-cyphar@cyphar.com>
 <20191116010144.GY26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="zx3lfe7kocslcnhj"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20191116010144.GY26530@ZenIV.linux.org.uk>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Song Liu <songliubraving@fb.com>, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, containers@lists.linux-foundation.org, Christian Brauner <christian.brauner@ubuntu.com>, linux-api@vger.kernel.org, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Daniel Borkmann <daniel@iogearbox.net>, Jiri Olsa <jolsa@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, Yonghong Song <yhs@fb.com>, linux-mips@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.orgl
List-Id: linux-api@vger.kernel.org


--zx3lfe7kocslcnhj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-16, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Nov 16, 2019 at 11:27:56AM +1100, Aleksa Sarai wrote:
>=20
> > @@ -1383,6 +1398,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
> >  				return -ECHILD;
> >  			if (&mparent->mnt =3D=3D nd->path.mnt)
> >  				break;
> > +			if (unlikely(nd->flags & LOOKUP_NO_XDEV))
> > +				return -EXDEV;
> >  			/* we know that mountpoint was pinned */
> >  			nd->path.dentry =3D mountpoint;
> >  			nd->path.mnt =3D &mparent->mnt;
> > @@ -1397,6 +1414,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
> >  			return -ECHILD;
> >  		if (!mounted)
> >  			break;
> > +		if (unlikely(nd->flags & LOOKUP_NO_XDEV))
> > +			return -EXDEV;
> >  		nd->path.mnt =3D &mounted->mnt;
> >  		nd->path.dentry =3D mounted->mnt.mnt_root;
> >  		inode =3D nd->path.dentry->d_inode;
>=20
> I really don't think we should return hard errors from that function.
> Let the caller redo it in refwalk mode.

I suspected as much, though my reason for not changing it was that the
mount_lock check should ensure that the cached status of whether ".." is
a mountpoint crossing is correct. But I guess this is more about being
safe than sorry, rather than an actual bug?

> It's not the fast path, especially for this kind of errors.  Matter of
> fact, I'm not sure about -ENOENT returned in another failure case
> there - it's probably OK, but again, -ECHILD would be just as good.

I can switch the -ENOENT too if you like.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--zx3lfe7kocslcnhj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXdAwvAAKCRCdlLljIbnQ
El+mAP4lkfpULZhCmvlAombEBT8rptRQqzFx9hYmJ6mvvfcYggEAsxV/+HBUu9Ag
hFdzUslyEB9Xm9f8/lXdVVGQVVDH4w4=
=8orS
-----END PGP SIGNATURE-----

--zx3lfe7kocslcnhj--
