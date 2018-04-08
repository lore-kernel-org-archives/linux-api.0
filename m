From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [GIT PULL] Kernel lockdown for secure boot
Date: Mon, 9 Apr 2018 00:00:30 +0200
Message-ID: <20180408220030.GC4965@amd>
References: <CA+55aFzYbpRAdma0PvqE+9ygySuKzNKByqOzzMufBoovXVnfPw@mail.gmail.com>
 <CACdnJuv-VpdhjEe1cMysdHb6Oy67jQqg-_TVHbUrOfH9GmCVvg@mail.gmail.com>
 <CA+55aFwvuoSHhKnn82VnDndZ6oXMJgwHF604gZ=h3ehHyC600A@mail.gmail.com>
 <CA+55aFzJ2sQR13T+20MKEJ5co-f3Ev8rRxQkRCWVaeDSUU3yhQ@mail.gmail.com>
 <CACdnJuti5Riqoi1sesqPALYHq9LT87o4MFj-0Y5BZqqzJ5579g@mail.gmail.com>
 <CA+55aFwhi=gz3HLoGST9--n1_kLJNP6jsf8GSesSFxTDCdPdtQ@mail.gmail.com>
 <CACdnJuuek-sS3esmomNOkjBMV_6VPL2NFCzRd+UGxbZrMe=4nw@mail.gmail.com>
 <CA+55aFxgrh5eeG9MRSEsJtyL5yTe0TehZ=BS2josGJaLxoMMBQ@mail.gmail.com>
 <CACdnJutuBaE3RaDx0KM5vDF9Sinrp=3tG9csrS-H3eU-J7-Utw@mail.gmail.com>
 <20180404125743.GB16242@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180404125743.GB16242@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Matthew Garrett <mjg59@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, luto@kernel.org, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, jmorris@namei.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jforbes@redhat.com, linux-man@vger.kernel.org, jlee@suse.com, LSM List <linux-security-module@vger.kernel.org>, linux-api@vger.kernel.org, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > What I'm afraid of is this turning into a "security" feature that ends =
up
> > being circumvented in most scenarios where it's currently deployed - eg,
> > module signatures are mostly worthless in the non-lockdown case because=
 you
> > can just grab the sig_enforce symbol address and then kexec a preamble =
that
> > flips it back to N regardless of the kernel config.
>=20
> Whoa.  Why doesn't lockdown prevent kexec?  Put another away, why
> isn't this a problem for people who are fearful that Linux could be
> used as part of a Windows boot virus in a Secure UEFI context?
>=20
> If lockdown simply included a requirement for a signed kernel for
> kexec --- and if kernel signing aren't available, to simply not alow
> kexec, wouldn't that take care of this case?
>=20
> This wouldn't even be all that much of a burden for non-distro users
> with lockdown enabled, since in my experience outside of enterprise
> and data center use cases, kexec isn't used --- and in fact, very
> often kexec doesn't even work outside of a very carefully selected and
> bug-fixed set of device drivers.  (It often doesn't work in non-distro
> kernels because very few upstream developers really care about kexec.)

I do have Motorola Droid 4 here (cellphone). It uses safestrap.. and
than it turn kexec's a lot (so that you can select Android vs. Jolla
vs. ... during boot).

So yes, kexec shows even in unexpected places.

And BTW.. the cellphone thingie is a situation where manufacturer
works against it users. Motorola does _not_ want me to run my own
kernels here.

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrKkP4ACgkQMOfwapXb+vLuTQCeMDzahlxtiWb+VZ8CP3Jf2Hqu
XcQAn2whnLxOBGlx1Qn+icDsL2hhrHIX
=WLuA
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
