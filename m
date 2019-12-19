From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH 0/2] openat2: minor uapi cleanups
Date: Fri, 20 Dec 2019 00:41:17 +1100
Message-ID: <20191219134117.cd2vlgudkzke2koa@yavin.dot.cyphar.com>
References: <20191219105533.12508-1-cyphar@cyphar.com>
 <20191219111949.auriw6biphxxvdng@wittgenstein>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mutewvojgxffecmv"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191219111949.auriw6biphxxvdng@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, Florian Weimer <fweimer@redhat.com>, David Laight <david.laight@aculab.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--mutewvojgxffecmv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-19, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> On Thu, Dec 19, 2019 at 09:55:28PM +1100, Aleksa Sarai wrote:
> > While openat2(2) is still not yet in Linus's tree, we can take this
> > opportunity to iron out some small warts that weren't noticed earlier:
> >=20
> >   * A fix was suggested by Florian Weimer, to separate the openat2
> >     definitions so glibc can use the header directly. I've put the
> >     maintainership under VFS but let me know if you'd prefer it belong
> >     ot the fcntl folks.
> >=20
> >   * Having heterogenous field sizes in an extensible struct results in
> >     "padding hole" problems when adding new fields (in addition the
> >     correct error to use for non-zero padding isn't entirely clear ).
> >     The simplest solution is to just copy clone(3)'s model -- always use
> >     u64s. It will waste a little more space in the struct, but it
> >     removes a possible future headache.
>=20
> Am I imagining things or did I get the same patch series twice?

Not unless it's a coincidence -- I accidentally ran

  % git send-email *.patch [some flags] *.patch

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--mutewvojgxffecmv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXft9+QAKCRCdlLljIbnQ
EtyNAQCti3thklGHsV++rCfcqbFMf3f1fnX3p/5obp2AXE01PwD9HwJsBnRPdbWJ
duHYCyjYbDaPG5aWWq59zoWJ9d+MxQ8=
=NFwv
-----END PGP SIGNATURE-----

--mutewvojgxffecmv--
