From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v12 01/12] lib: introduce copy_struct_{to,from}_user
 helpers
Date: Fri, 6 Sep 2019 10:09:08 +1000
Message-ID: <20190906000908.xpvkuhun7v6onp6w@yavin.dot.cyphar.com>
References: <20190904201933.10736-1-cyphar@cyphar.com>
 <20190904201933.10736-2-cyphar@cyphar.com>
 <20190905180750.GQ1131@ZenIV.linux.org.uk>
 <20190905230003.bek7vqdvruzi4ybx@yavin.dot.cyphar.com>
 <20190905234944.GT1131@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45flctx23d2mffx4"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190905234944.GT1131@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Alexander
List-Id: linux-api@vger.kernel.org


--45flctx23d2mffx4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-06, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 06, 2019 at 09:00:03AM +1000, Aleksa Sarai wrote:
> > > > +			return -EFAULT;
> > > > +	}
> > > > +	/* Copy the interoperable parts of the struct. */
> > > > +	if (__copy_to_user(dst, src, size))
> > > > +		return -EFAULT;
> > >=20
> > > Why not simply clear_user() and copy_to_user()?
> >=20
> > I'm not sure I understand what you mean -- are you asking why we need to
> > do memchr_inv(src + size, 0, rest) earlier?
>=20
> I'm asking why bother with __ and separate access_ok().

Ah right, it was a dumb "optimisation" (since we need to do access_ok()
anyway since we should early -EFAULT in that case). I've dropped the __
usages in my working copy.

> > > 	if ((unsigned long)addr & 1) {
> > > 		u8 v;
> > > 		if (get_user(v, (__u8 __user *)addr))
> > > 			return -EFAULT;
> > > 		if (v)
> > > 			return -E2BIG;
> > > 		addr++;
> > > 	}
> > > 	if ((unsigned long)addr & 2) {
> > > 		u16 v;
> > > 		if (get_user(v, (__u16 __user *)addr))
> > > 			return -EFAULT;
> > > 		if (v)
> > > 			return -E2BIG;
> > > 		addr +=3D2;
> > > 	}
> > > 	if ((unsigned long)addr & 4) {
> > > 		u32 v;
> > > 		if (get_user(v, (__u32 __user *)addr))
> > > 			return -EFAULT;
> > > 		if (v)
> > > 			return -E2BIG;
> > > 	}
> > > 	<read the rest like you currently do>
>=20
> Actually, this is a dumb way to do it - page size on anything
> is going to be a multiple of 8, so you could just as well
> read 8 bytes from an address aligned down.  Then mask the
> bytes you don't want to check out and see if there's anything
> left.
>=20
> You can have readability boundaries inside a page - it's either
> the entire page (let alone a single word) being readable, or
> it's EFAULT for all parts.
>=20
> > > would be saner, and things like x86 could trivially add an
> > > asm variant - it's not hard.  Incidentally, memchr_inv() is
> > > an overkill in this case...
> >=20
> > Why is memchr_inv() overkill?
>=20
> Look at its implementation; you only care if there are
> non-zeroes, you don't give a damn where in the buffer
> the first one would be.  All you need is the same logics
> as in "from userland" case
> 	if (!count)
> 		return true;
> 	offset =3D (unsigned long)from & 7
> 	p =3D (u64 *)(from - offset);
> 	v =3D *p++;
> 	if (offset) {	// unaligned
> 		count +=3D offset;
> 		v &=3D ~aligned_byte_mask(offset); // see strnlen_user.c
> 	}
> 	while (count > 8) {
> 		if (v)
> 			return false;
> 		v =3D *p++;
> 		count -=3D 8;
> 	}
> 	if (count !=3D 8)
> 		v &=3D aligned_byte_mask(count);
> 	return v =3D=3D 0;
>=20
> All there is to it...

Alright, will do (for some reason I hadn't made the connection that
memchr_inv() is doing effectively the same word-by-word comparison but
also detecting where the first byte is).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--45flctx23d2mffx4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXXGjoAAKCRCdlLljIbnQ
EpC9AP0R1Y7fvOkhCrlqhEeSXH2/w/eSafFO51uuSnY7m3dVegEAm16vVXT68ypo
Z7fWiISgwHeOk0U5O9VS4cZGMgtS3ws=
=nF2N
-----END PGP SIGNATURE-----

--45flctx23d2mffx4--
