From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 09/15] power: bq24257: Add SW-based approach for Power
 Good determination
Date: Mon, 28 Sep 2015 18:02:41 +0200
Message-ID: <20150928160241.GA3660@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-10-git-send-email-dannenberg@ti.com>
 <20150927202025.GA2051@earth>
 <20150928120412.GA12676@borg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150928120412.GA12676@borg>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 28, 2015 at 07:04:12AM -0500, Andreas Dannenberg wrote:
> On Sun, Sep 27, 2015 at 10:20:26PM +0200, Sebastian Reichel wrote:
> > On Fri, Sep 25, 2015 at 10:54:14AM -0500, Andreas Dannenberg wrote:
> > > @@ -651,15 +670,18 @@ static int bq24257_power_supply_init(struct bq2=
4257_device *bq)
> > >  	return PTR_ERR_OR_ZERO(bq->charger);
> > >  }
> > > =20
> > > -static int bq24257_pg_gpio_probe(struct bq24257_device *bq)
> > > +static void bq24257_pg_gpio_probe(struct bq24257_device *bq)
> > >  {
> > > -	bq->pg =3D devm_gpiod_get_index(bq->dev, BQ24257_PG_GPIO, 0, GPIOD_=
IN);
> > > +	bq->pg =3D devm_gpiod_get_optional(bq->dev, BQ24257_PG_GPIO, GPIOD_=
IN);
> > > +
> > >  	if (IS_ERR(bq->pg)) {
> > > -		dev_err(bq->dev, "could not probe PG pin\n");
> > > -		return PTR_ERR(bq->pg);
> > > +		dev_err(bq->dev, "error probing PG pin\n");
> > > +		bq->pg =3D NULL;
> > > +		return;
> > >  	}
> >=20
> > You should handle -EPROBE_DEFER here.
>=20
> Hi Sebastian. From having a quick look at the Kernel tree it seems like
> this error shouldn't get exposed to the user (which it doesn't since it
> would get zeroe'd out) and the error itself suggests that I should
> "retry" which none of the things I looked at in the Kernel through "git
> grep" seemed to do. So before making any assumptions I wanted to see if
> I'm missing something or you could give me any pointers how to proceed.

If you return -EPROBE_DEFER from your driver's probe function, the
driver probe will fail. In opposit to other error codes it will be
marked for retry at a later point, though. You will get
EPROBE_DEFER, if you try to access a GPIO from a not-yet initialized
GPIO controller (e.g. if you load the charger driver before the
gpio driver).

Correct handling is simple: Just forward it, making sure, that all
non-devm probed resources are correctly free'd.

-- Sebastian

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCWSeAAoJENju1/PIO/qa/4UP/2f2L1oagbaEL9taSdzarAlA
jYPaYQbSezevnLTVH2hsVWvyLYi31Vd7/QaiP+rcSFD6B7K0bNg78iM0k5IOb+5Q
OeSXvwxngUvlyLtxxFuXIWtJSJmJynSfu3tDLwBt0Mao8zy9qtw5XAChzLqTQXie
K7ZoHBFBtOi9NE8uNIRUdIvs+yljBXGRXy4z5KmoIOZap6ewSWRob4s4j1cLX/Pa
gSFHfLUvQW/dzUo7IKbSiFoy4dktrS+l9P4lDEuPiUm6YGMb1zAXDX7ABKqekVYL
PWhjxcf9lef7suJu0SzhOhXlAD5TojOTzz1BQiQYZA4wihmTMK+g9vjHt+9FhWz2
PicrMFYeUoqDSWC7T2pcZYoQqCk/nC60p6Em5rNvCOUHGWOVZlPG9piC99opTETt
+iZpKIk/zDYReBHhi0o06UJRoy3JhmVkctS5RyMkxbcsNwxF7O4N+eIrEw/0j+qc
Wlg6y91TW6dnHmKMdvUTxXdaR1/v7FP8BqNx73u1qCmZUXN2GlPkUEAF0pymqGwg
ynDC170yKXNjw/okLBGNM+JIaH1xqW/S2vCQ4X2L5YQkmjm9IYf0iG+IJdzrWrlb
KSsusuE3+S3SeI24vbT6v/FtrXPEJiKZgaCvOq9fF/CsNej2P2DI+adzIYD4ufJc
Q+J0qUn3n+paOsXQZ6+v
=SF88
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
