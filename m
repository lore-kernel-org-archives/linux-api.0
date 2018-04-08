From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Sun, 8 Apr 2018 10:23:06 +0200
Message-ID: <20180408082306.GB4965@amd>
References: <CALCETrUFOdrH5ShCCd8yguGjC2NtG8fJY7AW26HH467-02UVGA@mail.gmail.com>
 <CACdnJut31+ZtiR40nkOjm89cfUxS0EM=w-oG69PtWHbXYJQxPg@mail.gmail.com>
 <CALCETrXeVod=kNpG-M7yKAMM0-n+PMg_OakN6ecWrTPmKXgMLg@mail.gmail.com>
 <9758.1522775763@warthog.procyon.org.uk>
 <CALCETrWHS9p1My=j07=V=OP7v4SwQkW-kJ3JOx6EbPU8fb_XEQ@mail.gmail.com>
 <13189.1522784944@warthog.procyon.org.uk>
 <CALCETrX4CuHVpn38R24TCcJgCBLSbh-sOD-qcD5kYF8Zo53ZJw@mail.gmail.com>
 <9349.1522794769@warthog.procyon.org.uk>
 <CALCETrV6E+r942K+fu-ALNf-x6qOZ3o1hNKGeu7qEMvr8sMP9A@mail.gmail.com>
 <10718.1522798745@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10718.1522798745@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Justin Forbes <jforbes@redhat.com>, linux-man <linux-man@vger.kernel.org>, joeyli <jlee@suse.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-04-04 00:39:05, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
> > The same thing is true of some lockdown patch. Maybe it's a good thing
> > in general. But whether it's a good thing is _entirely_ independent of
> > any secure boot issue. I can see using secure boot without it, but I
> > can very much also see using lockdown without secure boot.
> >=20
> > The two things are simply entirely orthogonal. They have _zero_
> > overlap. I'm not seeing why they'd be linked at all in any way.
>=20
> I'm not sure I agree.  Here's my reasoning:
>=20
>  (1) Lockdown mode really needs to activated during kernel boot, before
>      userspace has a chance to run, otherwise there's a window of opportu=
nity
>      in which the kernel *isn't* locked down.
>=20
>  (2) If the kernel isn't booted in secure boot mode, then there's the
>      opportunity to tamper before the kernel even starts booting.
>=20
>  (3) There doesn't seem any point in booting in secure boot mode if you d=
on't
>      protect the running kernel image against tampering.  What does it me=
an to
>      be in "secure boot mode" in that case?  If the kernel can be tampered
>      with, it would seem to be, by definition, insecure.

This one is not true, either.

If kernel does "printk(KERN_CRIT "loading unsigned module");
mdelay(10000);", it is useful for secure boot and provides way to
owner to play.

Nokia N9 / N950 uses this kind of "security" for example. It is rather
annoying but better than not being able to run custom kernels at all.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrJ0WoACgkQMOfwapXb+vIUpgCfQTVxgQuJIcDh2bJZRy8WyNou
NOMAmwboHWl217wYf3zGmTVqyXi9sm4P
=judE
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
