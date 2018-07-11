From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v2 05/27] Documentation/x86: Add CET description
Date: Wed, 11 Jul 2018 10:27:39 +0200
Message-ID: <20180711082739.GA18919@amd>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-6-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180710222639.8241-6-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2018-07-10 15:26:17, Yu-cheng Yu wrote:
> Explain how CET works and the no_cet_shstk/no_cet_ibt kernel
> parameters.
>=20

> --- /dev/null
> +++ b/Documentation/x86/intel_cet.txt
> @@ -0,0 +1,250 @@
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Control Flow Enforcement Technology (CET)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

We normally use .rst for this kind of formatted text.


> +[6] The implementation of the SHSTK
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +SHSTK size
> +----------
> +
> +A task's SHSTK is allocated from memory to a fixed size that can
> +support 32 KB nested function calls; that is 256 KB for a 64-bit
> +application and 128 KB for a 32-bit application.  The system admin
> +can change the default size.

How does admin change that? We already have ulimit for stack size,
should those be somehow tied together?

$ ulimit -a
=2E..
stack size              (kbytes, -s) 8192


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltFv3sACgkQMOfwapXb+vJCUwCfRHq9+RCMp+u2Y1KcEeEwRWQo
uw4AoKTNBubkPzJE8R3PcwGC3r8tTOI2
=YfD9
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
