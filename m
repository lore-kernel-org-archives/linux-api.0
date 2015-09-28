From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 02/15] power: bq24257: Remove IRQ config through
 stat-gpios
Date: Mon, 28 Sep 2015 18:38:26 +0200
Message-ID: <20150928163825.GD3660@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-3-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443196460-26156-3-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 25, 2015 at 10:54:07AM -0500, Andreas Dannenberg wrote:
> At the time the driver was written GpioInt resources in ACPI were not
> passed to the driver in client->irq, as opposed to DT enumeration. To
> accommodate this use case, a "stat-gpios" property was introduced to
> allow configuring the IRQ.
>=20
> However this issue with ACPI was fixed in commit "845c877 i2c / ACPI:
> Assign IRQ for devices that have GpioInt automatically" and makes this
> workaround no longer necessary, hence we can remove the support for the
> "stat-gpios" property and the associated code from the bq24257 driver.

Thanks, queued.

-- Sebastian

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCW0BAAoJENju1/PIO/qaUOsP/AslesqcRf3DIzhbbZik7xR2
1j6fMTnWqkVOT+tGk5gFF+DhWJwXKmfibPG04yNNojuMZ1FXjY9CVsqrIl5ncUWP
cvjDRde1wRwibtnxhMjIDw14B3gxk3wVGEHRELCSTFiMpISsKL83PbqqdIKMJpKW
me0p0BpS0u1xq4DGRsnw7XFE5TB+DRj/Is9SPt9ErjWIxHKxQEAsSWalk+oX3c4v
ZSf/oLnoj/iuXLMOindPuhYKS6HWadoJjxKfJV6/cxvPw9nLeVLTJk1NJ1itlo9E
N6rCj6wTNcMdacD05kEJGIzJoShdpUxgcfXwqOXJXPGGocmJPpRUaFlF3QPeb9ii
pLI8qz/5ljIGeSh7tG29ziyqm6IWPNINzupWgjL4ljKuYR5Bqpiw2iVInCt6dMAy
ImCpWZLc2OYOw/aGaORthe+DHRPsp7lGbppEmwYNkjvysvDxxjbKm+HahxDr/2kA
490K3EeYpQVXzKFHHRJpqWUwcYaxi8VWlbpjCSaaSt4s/GPh6iL/Rr0xBdBXDkco
D+jW+Gm+FA/ox+ct0nQME4inHXvynFOEu8vencRUfE1LrXMaVLhTRvDven6BfePr
ttUMGqzpGfsC9iVnZJ2I4sVy/1lUMs9ZBVR9dAS2GGtvGPX099Pcds9CPAA0ch9G
QNKe5csieX/OaTkx4GLB
=RlQL
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
