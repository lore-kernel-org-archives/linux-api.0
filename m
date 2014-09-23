From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 5/5] drm: panel: simple-panel: add bus format information
 for foxlink panel
Date: Tue, 23 Sep 2014 16:06:13 +0200
Message-ID: <20140923140612.GB5982@ulmo>
References: <1406031827-12432-1-git-send-email-boris.brezillon@free-electrons.com>
 <1406031827-12432-6-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0522690567=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1406031827-12432-6-git-send-email-boris.brezillon@free-electrons.com>
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


--===============0522690567==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 02:23:47PM +0200, Boris BREZILLON wrote:
> Foxlink's fl500wvr00-a0t supports RGB888 format.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel=
/panel-simple.c
> index 42fd6d1..f1e49fd 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -428,6 +428,7 @@ static const struct panel_desc foxlink_fl500wvr00_a0t=
 =3D {
>  		.width =3D 108,
>  		.height =3D 65,
>  	},
> +	.bus_format =3D VIDEO_BUS_FMT_RGB888_1X24,

This is really equivalent to .bpc =3D 8. Didn't you say you had other
use-cases where .bpc wasn't sufficient?

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUIX5UAAoJEN0jrNd/PrOh978P/AwkG0E2cje1IL7DuT0+mMzH
jve3XfrooQ5hvChRzJNawNb/r6qoBrxFsfW5mz4Cd0vduLuvUBhRUfNXefvHTMZO
ERCMz2OjDFwvS91ShBB/DyGlX1puDQgea7KiICjoPTX/Gh9eXzmpqerwQv9K6bRN
82ypV2KEGg49bonJSipHYZNqnQbaRjTR/YfMuN2XRoXTFKLcDnUk0NE7H3N04jsz
eDTBCVQ2Os9E71MEyHFbY+O39HKnA98Hqr/25I+/kV1cV/mRWKMjeZJVXFD7KEgN
QoM4ec0C9uydDIaYuJRuqUUUlc6plXoc40Gx6xNJ5LtisEuBLteQyBZIsOgpy0de
mTzTqA8q3KJtWEZ7Cwjeqo0WYkRHTB5wDs+SOlBDPESMx4a9F2BkQZWoWMdCkZRv
HWE/zecn84NSq92v6W8yHENkjgSfVXl0Wnucd9eui9O3Zd8fadNruo76zh6Q6KIZ
7yMNnNEpCgdz9cix6NNnSwrtKFan9QV42hTtGrGHHXxZBOMU37l7JHPOZ+0F4ydX
OddmQAOAVmuyzjLGMkLFt/YCqOejMCABcviTW6hjAEv4eBMCkxu70caagsYEY5Cu
Cdp3mbuvp+bR7xfU6tGQHqarsauwfAYEmdeZA4COL3A4rATgLvHs+sO+zP6j/oQJ
vvb7FnmpKBg6gCkATnU3
=t+tM
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--

--===============0522690567==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel

--===============0522690567==--
