From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v2 1/3] vt: add cursor blink interval escape sequence
Date: Fri, 27 Mar 2015 20:35:03 -0400
Message-ID: <20150328003503.GB27135@vapier>
References: <alpine.DEB.2.11.1501262034380.1945@localhost.localdomain>
 <alpine.DEB.2.11.1501262040380.2052@localhost.localdomain>
 <20150225094946.GA24627@amd>
 <alpine.LNX.2.11.1502252319330.276@localhost>
 <20150226220243.GC9935@amd>
 <alpine.LNX.2.11.1502271905580.4212@localhost>
 <alpine.LNX.2.11.1502271911380.4248@localhost>
 <20150325111949.GA24230@kroah.com>
 <alpine.DEB.2.11.1503261341260.2164@local>
 <alpine.DEB.2.11.1503261352200.2411@local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1503261352200.2411@local>
Sender: linux-kernel-owner@vger.kernel.org
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Jiri Slaby <jslaby@suse.cz>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Pavel Machek <pavel@ucw.cz>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26 Mar 2015 13:54, Scot Doyle wrote:
> Add an escape sequence to specify the current console's cursor blink
> interval. The interval is specified as a number of milliseconds until
> the next cursor display state toggle, from 50 to 65535. /proc/loadavg
> did not show a difference with a one msec interval, but the lower
> bound is set to 50 msecs since slower hardware wasn't tested.

if they want to be crazy, why not let them ?  it's not like we generally pr=
event=20
the user from destroying their machine.  i.e. just require the value to be =
> 0=20
(unless you want to let 0 disable things).
-mike

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVFfc3AAoJEEFjO5/oN/WBHCoP/jO8/MZ5+A4hCgPNMX23x0ZR
G9UlQ+tbWPQOVpHmVQW80CS+CMp0Wf7xbybZuU5XLt4Z+e41GR4SO4AeiMUjSwTM
pr7w8xq66Q+PYk4hn3rImjsVVCSaERLMRVqvwm6cE4APXXitPrQX3zWCmUOy6O9M
7kKl0UZK5yAh8Oo8teW8OTKlb3GSeSnsEn9glXuqUJ/Md7Wkprh/okyClm5oBF9D
LveiSK8xMAogir6sWcg5dZTRz76oEzjSKRPRqo0eSYHfX5qETdkUaPrIAj5y0jsU
EnYwjluMnxsY6GhmNsSUl1EuwR9EKheM5L18a5ntYJJiuC4e9SuIJz7xGLXM1lBV
Vsz9/PefqsT6vcIbJDxK+AWLPTp7/kVlvxVpeJlGe0NuWVnFSTNGnMh588TrJQch
JXLwU1Os89w8K5KgVR82EXYmCp6JTm8d+wop+vBn3Bqpe2tAJ+BLz77ESIa9SF37
VyYXh4XsjBT3PbH7x6OHB8v+AurxhhAY+fSTQt3FjJFzloqkNeKkTP3G6B3H9Hiy
APbCTEo4lWbROhCf87O+oNgMt0L9s2F5QHuhPJr94CWoNG1SrMJ0qp1PNIe0NAXB
yo48/y+WeI7dTZHO6NVq7fFc9XPXIYFxS4mXvNCuoEEZQpFg6zejCITP7WJ+DcrI
AnzBfH5q2eWiFI5LrClD
=L86v
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
