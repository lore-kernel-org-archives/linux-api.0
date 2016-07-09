From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Fri, 8 Jul 2016 20:15:28 -0700
Message-ID: <20160709031528.GA25507@odin.tremily.us>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
 <87r3b7pxja.fsf@x220.int.ebiederm.org>
 <CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
 <20160706141348.GB20728@mail.hallyn.com>
 <CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
 <20160707133631.GA2994@mail.hallyn.com>
 <1467903712.2347.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467903712.2347.16.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 07, 2016 at 08:01:52AM -0700, James Bottomley wrote:
> In theory, we could get nsfs to show this information as an option
> (just add a show_options entry to the superblock ops), but the
> problem is that although each namespace has a parent user_ns,
> there's no way to get it without digging in the namespace specific
> structure.  Probably we should restructure to move it into
> ns_common, then we could display it (and enforce all namespaces
> having owning user_ns) but it would be a reasonably large (but
> mechanical) change.

It sounds like everyone is either positive or or neutral on this
groundwork, even if we haven't decided if/how to expose the
information to userspace.  I'm happy to work up a patch while the rest
of the discussion continues.  I'm also happy to let someone else work
up the patch, if anyone else is chomping at the bit ;).

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXgGxOAAoJEBBpoQVgXJg1aUAP/1qCWdapkP+W0y7Xw67xYqt6
94zwHNSp0H2dbfyKzdkhJbdT3BKT2P9NVwADgZD3wieh+mWL/916g/90gaw71Ejb
fhMqHl4Sx6U5cXW307rG2OogXLKoH2WCh0KbPPlQcFe1GP5ql1uQiXYNgmp2Z7jE
Thze0Ck4wlYCvcW+V2O92KKUfrMbUtYUvndDXxDI9fETJWr3jeUHOZrh+Vqgbgxx
M2dUocYM91o/sd6nA3IQ2MZ/Y4jZsEVlMGs+OM7Zn1BSvwsCqa9U80UmrxpL8hrV
z/jt9+yaOVLqEK2+vRHH3h3btj7c6DFRfZfGMG0hJMVZUld1dD9WgKoooye4nb82
dBw81Exq8WiYJqvGbfEofXxI6L6+tnialV/IWCUyK64BEdIFX2gIYAUJLnIzQvtf
BGazx8k5/MzXABZw+bCFizzEjhFEH+fpoUbXKHlNKr8leH6cWuzerH9Ne4laB4gk
ZG2zPlWy/grgBLTHcA9XRwwJIvSrl4KbxRB4R/ysy38LbxQnbPZ9MvS4INXhZ6m1
Tcugr54wYUYumjCB5lSqK6JpWa2d4SwGYDu9Z0saDyrNBDE/fyjUv9Q+FxW1i6mX
vPfcV+rb6Lsj09YZd1bcO5faxJaKLWIXaGatGaO1ugu6bOYdJ01lYXWrL+/Lavvn
ebJxePdGQj35EpYmXfF0
=KEOz
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
