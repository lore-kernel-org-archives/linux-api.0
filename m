From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Sun, 22 Feb 2015 15:32:11 +0100
Message-ID: <20150222143211.GX25269@lukather>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com>
 <54E78A31.9020306@linaro.org>
 <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7WMexqIhC8AwFtpM"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--7WMexqIhC8AwFtpM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 20, 2015 at 04:01:55PM -0600, Rob Herring wrote:
> [...]
>=20
> >>> +=3D Data consumers =3D
> >>> +
> >>> +Required properties:
> >>> +
> >>> +eeproms: List of phandle and data cell specifier triplet, one triplet
> >>> +        for each data cell the device might be interested in. The
> >>> +        triplet consists of the phandle to the eeprom provider, then
> >>> +        the offset in byte within that storage device, and the length
> >>> +        in byte of the data we care about.
> >>
> >>
> >> The problem with this is it assumes you know who the consumer is and
> >> that it is a DT node. For example, how would you describe a serial
> >> number?
> >
> > Correct me if I miss understood.
> > Is serial number any different?
> > Am hoping that the eeprom consumer would be aware of offset and size of
> > serial number in the eeprom
> >
> > Cant the consumer do:
> >
> > eeprom-consumer {
> >         eeproms =3D <&at24 0 4>;
> >         eeprom-names =3D "device-serial-number";
>=20
> Yes, but who is "eeprom-consumer"?

Any device that should lookup values in one of the EEPROM.

> DT nodes generally describe a h/w block, but it this case, the
> consumer depends on the OS, not the h/w.=20

Not really, or at least, not more than any similar binding we
currently have.

The fact that a MAC-address for the first ethernet chip is stored at a
given offset in a given eeprom has nothing to do with the OS.

> I'm not saying you can't describe where things are, but I don't
> think you should imply who is the consumer and doing so is
> unnecessarily complicated.

If you only take the case of a serial number, indeed. If you take
other usage into account, you can't really do without it.

> Also, the layout of EEPROM is likely very much platform specific.

Indeed, which is why it should be in the DT.

> Some could have a more complex structure perhaps with key ids and
> linked list structure.

Then just request the size of the whole list, and parse it afterwards
in your driver?

> I would do something more simple that is just a list of keys and their
> location like this:
>=20
> device-serial-number =3D <start size>;
> key1 =3D <start size>;
> key2 =3D <start size>;

I'm sorry, but what's the difference?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7WMexqIhC8AwFtpM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJU6ehqAAoJEBx+YmzsjxAgzvoP/3krU3TAK3RrWI6sp78v0ccX
AOae/LuZTMjoxWRi7qebL5ffSoC9CKDahg7fVtFM3EDj9NOutEgJJgZsfbfCgTWS
i1J0NG1rLSWXMNKJbwQ+28Mc7LEoxxsf4BmSrGW4zRGslzbkcytVhW3irW1kS9Je
j0quEjm/cfMYuEMn5DUpBnO4gsNEFRFZYbxtfyG72AXZIBjPGXkOa+Hu99b1BVgp
H3D80FcNP0z4EVeU+vZm/w0wOwcP9vB4yiVfXf8Y1S/4YTinfgQ2NyM5mfphB7Ax
9gtyvo8oHebXPlQM412y1tiYzLPn+GQKALk/vNkI5RmyqfP8pGDQRoAjJz2bvhY6
Yu7pWIDjxkp+zW12kXvAlaO2nVPmhQNu4XBPLufGD6hHHLeBnw6qpyQvP2twhQdl
Y34Ttj/dU+VapjMWBZXkiP0L9VwPpqvuTdfXZ7jNG3czy+N3xCkixSmNDvpQKMkI
v4xzcxoIZppX0XaFthHoORntHdi87yZqjtP7VAxqFDs2Tvmvcvs8wWryHE0MovJB
Or94janCx80k0VRq+i9PLKOf6N+gLahbFATYI8Chv1HljfmlsXRrlbEHj4W6rLyl
R6FXh5CFdfkBJOLILYHGj3nv/O/pjvXy68L53VehhB8Mn3h/pWuPlVdy1lDHi75O
t67tr2HpzgriH8YSP9Tp
=vjrF
-----END PGP SIGNATURE-----

--7WMexqIhC8AwFtpM--
