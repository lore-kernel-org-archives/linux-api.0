From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v2 25/27] x86/cet: Add PTRACE interface for CET
Date: Sat, 14 Jul 2018 08:27:37 +0200
Message-ID: <20180714062737.GA13242@amd>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
 <20180710222639.8241-26-yu-cheng.yu@intel.com>
 <20180711102035.GB8574@gmail.com>
 <1531323638.13297.24.camel@intel.com>
 <20180712140327.GA7810@gmail.com>
 <20180713062804.GA6905@amd>
 <20180713133357.GB13602@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180713133357.GB13602@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2018-07-13 15:33:58, Ingo Molnar wrote:
>=20
> * Pavel Machek <pavel@ucw.cz> wrote:
>=20
> >=20
> > > > > to "CET" (which is a well-known acronym for "Central European Tim=
e"),
> > > > > not to CFE?
> > > > >=20
> > > >=20
> > > > I don't know if I can change that, will find out.
> > >=20
> > > So what I'd suggest is something pretty simple: to use CFT/cft in ker=
nel internal=20
> > > names, except for the Intel feature bit and any MSR enumeration which=
 can be CET=20
> > > if Intel named it that way, and a short comment explaining the acrony=
m difference.
> > >=20
> > > Or something like that.
> >=20
> > Actually, I don't think CFT is much better -- there's limited number
> > of TLAs (*). "ENFORCE_FLOW"? "FLOWE"? "EFLOW"?
>=20
> Erm, I wanted to say 'CFE', i.e. the abbreviation of 'Control Flow Enforc=
ement'.
>=20
> But I guess I can live with CET as well ...

Yeah, and I am trying to say that perhaps we should use something
longer than three letters. It will make code longer but easier to
read.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltJl9kACgkQMOfwapXb+vJ/zwCglPFXsNNzgW0ML/M0vPlj5C0a
To0AoJ4qd5n1bRykjwlqyW6Hs34O+tnJ
=7LRO
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
