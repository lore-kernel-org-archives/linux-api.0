From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH] openat2: switch to __attribute__((packed)) for open_how
Date: Mon, 16 Dec 2019 07:55:39 +1100
Message-ID: <20191215205539.ly2ns5wglautu47u@yavin.dot.cyphar.com>
References: <20191213222351.14071-1-cyphar@cyphar.com>
 <87o8w9bcaf.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lhbbxkijknkbhl5m"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87o8w9bcaf.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--lhbbxkijknkbhl5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-15, Florian Weimer <fw@deneb.enyo.de> wrote:
> * Aleksa Sarai:
>=20
> > diff --git a/tools/testing/selftests/openat2/helpers.h b/tools/testing/=
selftests/openat2/helpers.h
> > index 43ca5ceab6e3..eb1535c8fa2e 100644
> > --- a/tools/testing/selftests/openat2/helpers.h
> > +++ b/tools/testing/selftests/openat2/helpers.h
> > @@ -32,17 +32,16 @@
> >   * O_TMPFILE} are set.
> >   *
> >   * @flags: O_* flags.
> > - * @mode: O_CREAT/O_TMPFILE file mode.
> >   * @resolve: RESOLVE_* flags.
> > + * @mode: O_CREAT/O_TMPFILE file mode.
> >   */
> >  struct open_how {
> > -	__aligned_u64 flags;
> > +	__u64 flags;
> > +	__u64 resolve;
> >  	__u16 mode;
> > -	__u16 __padding[3]; /* must be zeroed */
> > -	__aligned_u64 resolve;
> > -};
> > +} __attribute__((packed));
> > =20
> > -#define OPEN_HOW_SIZE_VER0	24 /* sizeof first published struct */
> > +#define OPEN_HOW_SIZE_VER0	18 /* sizeof first published struct */
> >  #define OPEN_HOW_SIZE_LATEST	OPEN_HOW_SIZE_VER0
>=20
> A userspace ABI that depends on GCC extensions probably isn't a good
> idea.  Even with GCC, it will not work well with some future
> extensions because it pretty much rules out having arrays or other
> members that are access through pointers.  Current GCC does not carry
> over the packed-ness of the struct to addresses of its members.

Right, those are also good points.

Okay, I'm going to send a separate patch which changes the return value
for invalid __padding to -E2BIG, and moves the padding to the end of the
struct (along with open_how.mode). That should fix all of the warts I
raised, without running into the numerous problems with
__attribute__((packed)) of which I am now aware.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--lhbbxkijknkbhl5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXfadxgAKCRCdlLljIbnQ
EnZkAQDEI0SqPaVjZ0DfeCNK/Oej24PSHHnlQslkzD1ijil74QD/aTyeW+1lV5OQ
nKYasufz04VrST6LL+l0ZOId14X/AAE=
=y9fv
-----END PGP SIGNATURE-----

--lhbbxkijknkbhl5m--
