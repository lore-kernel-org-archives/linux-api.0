From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH] binfmt_elf: Extract .note.gnu.property from an ELF
 file
Date: Thu, 4 Jul 2019 21:50:25 +0200
Message-ID: <20190704195024.GA4013@amd>
References: <20190628172203.797-1-yu-cheng.yu@intel.com>
 <CAG48ez0rHHfcRgiVZf5FP0YOzxsXigvpg6ci790cmiN6PBwkhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez0rHHfcRgiVZf5FP0YOzxsXigvpg6ci790cmiN6PBwkhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, the arch/x86 maintainers <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@c>
List-Id: linux-api@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> > +static int scan(u8 *buf, u32 buf_size, int item_size, test_item_fn tes=
t_item,
> > +               next_item_fn next_item, u32 *arg, u32 type, u32 *pos)
> > +{
> > +       int found =3D 0;
> > +       u8 *p, *max;
> > +
> > +       max =3D buf + buf_size;
> > +       if (max < buf)
> > +               return 0;
>=20
> How can this ever legitimately happen? If it can't, perhaps you meant
> to put a WARN_ON_ONCE() or something like that here?
> Also, computing out-of-bounds pointers is UB (section 6.5.6 of C99:
> "If both the pointer operand and the result point to elements of the
> same array object, or one past the last element of the array object,
> the evaluation shall not produce an overflow; otherwise, the behavior
> is undefined."), and if the addition makes the pointer wrap, that's
> certainly out of bounds; so I don't think this condition can trigger
> without UB.

Kernel assumes sane compiler. We pass flags to get it... C99 does not
quite apply here.
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0eWIAACgkQMOfwapXb+vLSMgCcC98TTx9pMIkokJGKGUu3i6ME
o+AAn3TIA7Pjz5wBcK19BycwV2+shMN6
=83sj
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
