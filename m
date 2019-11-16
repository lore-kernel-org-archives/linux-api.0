From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v16 09/12] namei: LOOKUP_{IN_ROOT,BENEATH}: permit
 limited ".." resolution
Date: Sun, 17 Nov 2019 03:38:46 +1100
Message-ID: <20191116163846.gy7q5py5w2p5pgz6@yavin.dot.cyphar.com>
References: <20191116002802.6663-1-cyphar@cyphar.com>
 <20191116002802.6663-10-cyphar@cyphar.com>
 <20191116010327.GZ26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="jveret2iy2nocuo2"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20191116010327.GZ26530@ZenIV.linux.org.uk>
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


--jveret2iy2nocuo2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-16, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Nov 16, 2019 at 11:27:59AM +1100, Aleksa Sarai wrote:
>=20
> > +		if (unlikely(nd->flags & LOOKUP_IS_SCOPED)) {
> > +			bool m_retry =3D read_seqretry(&mount_lock, nd->m_seq);
> > +			bool r_retry =3D read_seqretry(&rename_lock, nd->r_seq);
> > +
> > +			/*
> > +			 * If there was a racing rename or mount along our
> > +			 * path, then we can't be sure that ".." hasn't jumped
> > +			 * above nd->root (and so userspace should retry or use
> > +			 * some fallback).
> > +			 */
> > +			if (unlikely(m_retry || r_retry))
> > +				return -EAGAIN;
> > +		}
> >  	}
> >  	return 0;
>=20
> Elaborate...  Do these boolean variables make any sense now, really?

You're quite right, they don't make sense any more. I'll drop them.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--jveret2iy2nocuo2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXdAmEwAKCRCdlLljIbnQ
EmzcAP9tyUNvqW5Zg4vIz0RSlWzF9h1gwHR6LfkIIKqg1KM7QgEArxHmVCll9gd7
wAho9+kZCEx+tsCxFLjGmYzXP0S9KgI=
=OgPb
-----END PGP SIGNATURE-----

--jveret2iy2nocuo2--
