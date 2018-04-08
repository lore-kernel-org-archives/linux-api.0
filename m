From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Sun, 8 Apr 2018 10:10:50 +0200
Message-ID: <20180408081050.GA4965@amd>
References: <4136.1522452584@warthog.procyon.org.uk>
 <alpine.LRH.2.21.1803311145180.7769@namei.org>
 <186aeb7e-1225-4bb8-3ff5-863a1cde86de@kernel.org>
 <30459.1522739219@warthog.procyon.org.uk>
 <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CA+55aFy5EPxAyqyGGaYUUyakuLbjXHiseWCkz-oNdo=Y-878tg@mail.gmail.com>
 <CACdnJuuXOP5T-BRAwMvc7XF8S49wyvp4ZYgcU=EZkaGNgPAQig@mail.gmail.com>
 <CA+55aFzGFZT68ih446DeQbB69Fyk_wT6b7PGq0iz-gctUGQq_A@mail.gmail.com>
 <CACdnJuvheCbuvTLyDWMQWcUytc4EvuSUaEKywfEX8Kp6qYL9dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACdnJuvheCbuvTLyDWMQWcUytc4EvuSUaEKywfEX8Kp6qYL9dg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2018-04-03 21:08:54, Matthew Garrett wrote:
> On Tue, Apr 3, 2018 at 2:01 PM Linus Torvalds
> <torvalds@linux-foundation.org>
> wrote:
>=20
> > On Tue, Apr 3, 2018 at 1:54 PM, Matthew Garrett <mjg59@google.com> wrot=
e:
> > >
> > >> .. maybe you don't *want* secure boot, but it's been pushed in your
> > >> face by people with an agenda?
> > >
> > > Then turn it off, or build a self-signed kernel that doesn't do this?
>=20
> > Umm. So you asked a question, and then when you got an answer you said
> > "don't do that then".
>=20
> > The fact is, some hardware pushes secure boot pretty hard. That has
> > *nothing* to do with some "lockdown" mode.
>=20
> Secure Boot ensures that the firmware will only load signed bootloaders. =
If
> a signed bootloader loads a kernel that's effectively an unsigned
> bootloader, there's no point in using Secure Boot - you should just turn =
it
> off instead, because it's not giving you any meaningful
> security. Andy's

Not true.

I have kernel with printk() enabled. Yes, once userland is started,
you can boot another kernel, maybe.

Maybe my kernel is locked down with exception of kexec, and it does
printk(KERN_CRIT "kexecing") followed by mdelay(5000). That's pretty
good security.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrJzooACgkQMOfwapXb+vJyawCgucLLA8QbmX8zLUT7nIWXw5P+
p/sAoI5s8z1MIYAXdUMjuXLq63vVHR7v
=llcn
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
