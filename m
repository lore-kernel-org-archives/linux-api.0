From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 3/5] drm: add bus_formats and nbus_formats fields to
 drm_display_info
Date: Tue, 23 Sep 2014 16:04:40 +0200
Message-ID: <20140923140439.GA5982@ulmo>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
 <1406031827-12432-4-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0463042538=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1406031827-12432-4-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>
List-Id: linux-api@vger.kernel.org


--===============0463042538==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 02:23:45PM +0200, Boris BREZILLON wrote:
> Add bus_formats and nbus_formats fields and
> drm_display_info_set_bus_formats helper function to specify the bus
> formats supported by a given display.
>=20
> This information can be used by display controller drivers to configure
> the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> RGB or LVDS busses).
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/gpu/drm/drm_crtc.c | 28 ++++++++++++++++++++++++++++
>  include/drm/drm_crtc.h     |  8 ++++++++
>  2 files changed, 36 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index c808a09..50c8395 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -825,6 +825,34 @@ static void drm_mode_remove(struct drm_connector *co=
nnector,
>  	drm_mode_destroy(connector->dev, mode);
>  }
> =20
> +/*
> + * drm_display_info_set_bus_formats - set the supported bus formats
> + * @info: display info to store bus formats in
> + * @fmts: array containing the supported bus formats
> + * @nfmts: the number of entries in the fmts array
> + *
> + * Store the suppported bus formats in display info structure.
> + */
> +int drm_display_info_set_bus_formats(struct drm_display_info *info,
> +				     const enum video_bus_format *fmts,
> +				     int nfmts)

Can you make nfmts unsigned please?

> +{
> +	enum video_bus_format *formats =3D NULL;
> +
> +	if (fmts && nfmts) {
> +		formats =3D kmemdup(fmts, sizeof(*fmts) * nfmts, GFP_KERNEL);
> +		if (!formats)
> +			return -ENOMEM;
> +	}
> +
> +	kfree(info->bus_formats);
> +	info->bus_formats =3D formats;
> +	info->nbus_formats =3D formats ? nfmts : 0;

And perhaps check for formats =3D=3D NULL && nfmts !=3D 0 since that's not a
valid pair of values. Then you can simply assign this directly without
relying on the value of formats.

Also other variable names use "num_" as a prefix instead of "n", so if
you're going to respin anyway might as well make the names more
consistent.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(drm_display_info_set_bus_formats);
> +
>  /**
>   * drm_connector_init - Init a preallocated connector
>   * @dev: DRM device
> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> index e529b68..957729b 100644
> --- a/include/drm/drm_crtc.h
> +++ b/include/drm/drm_crtc.h
> @@ -31,6 +31,7 @@
>  #include <linux/idr.h>
>  #include <linux/fb.h>
>  #include <linux/hdmi.h>
> +#include <linux/video-bus-format.h>
>  #include <drm/drm_mode.h>
>  #include <drm/drm_fourcc.h>
>  #include <drm/drm_modeset_lock.h>
> @@ -121,6 +122,9 @@ struct drm_display_info {
>  	enum subpixel_order subpixel_order;
>  	u32 color_formats;
> =20
> +	const enum video_bus_format *bus_formats;
> +	int nbus_formats;

unsigned int here too, please.

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUIX33AAoJEN0jrNd/PrOhp0EP/i4QLBT0OdxOEFBG0fiIlmJ8
Jc17bgilP41zsiFppJ3EYalrk54kwz8OAsNlX1hIkYw45WW32ZZ22gOMXIZvZBWB
/9bHmS5+MRM3uoOWfI4iZci2k1y5rrZsySLTz4llgMoImVYuO+I064UWgyU68QTO
/VJDCcUsSQ4YNE0a8aJ4w8GFztzD2xV3Q9hofdPsEgb4D//4oy0n/xc3h20tUT3V
jkEmHPmD5dJ/E6GJ4PO8iVoQ87L0PeJ5Pkb6chNxXBXg4jnouQyo9KWGHfTx2ABe
B83ONBrbatqa3wUzjTsmMbg6iNsIGp4C1GDBuio5CAdTODe5eF+q9xwxejDcfRfo
RZSOQdDJwtKPpEm7gMVfQsaJGOo9ECh223JqYvib6EAPSlbrGkCsdT5fnGWr9kq2
SkVHI2soPpxNLVI9FeRCmnd2ac82gwPonqvjBG7i+7T6hdBMDrCnoU8g2PaAqVfM
P/6kVKqxUoVthEXKTlGjspxp6ZE6XUytW7xqtGRA4exL/eGapBuIWQa5X9Al2dt7
IaNLiSlojF9HbERpqmj6YfOidJoOx25H49lJzBFS/j8oNeSOaK0bPvMFdHNighKQ
4J2TeRqRq5McCc1lE2FoPCM5NDXxtEDa98cp4abvcwVv0coqZIx+wwuM0BwHEiGU
zry7PlQb417kMZ4kIKZv
=VfKp
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--

--===============0463042538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============0463042538==--
