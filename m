From: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 06/24] fpga: dfl: adds fpga_cdev_find_port
Date: Wed, 14 Feb 2018 12:55:06 -0800
Message-ID: <20180214205506.GA25618@tyrael.ni.corp.natinst.com>
References: <1518513893-4719-1-git-send-email-hao.wu@intel.com>
 <1518513893-4719-7-git-send-email-hao.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518513893-4719-7-git-send-email-hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luwei.kang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hao,

On Tue, Feb 13, 2018 at 05:24:35PM +0800, Wu Hao wrote:
> For feature devices, we need a method to find the port dedicated
> to the device. This patch adds a function fpga_cdev_find_port
> for this purpose. e.g FPGA Management Engine (FME) Partial
> Reconfiguration sub feature, it uses this function to find
> dedicated port on the device for PR function implementation.
>=20
> Signed-off-by: Tim Whisonant <tim.whisonant-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Enno Luebbers <enno.luebbers-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiva Rao <shiva.rao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Christopher Rauer <christopher.rauer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> v3: s/fpga_for_each_port/fpga_cdev_find_port/
>     move fpga_cdev_find_port to fpga-dfl module.
> v4: improve description in commit message.
>     add comments to remind user to put_device after use this function.
> ---
>  drivers/fpga/dfl.c | 34 ++++++++++++++++++++++++++++++++++
>  drivers/fpga/dfl.h | 20 ++++++++++++++++++++
>  2 files changed, 54 insertions(+)
>=20
> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
> index dcfe5ab..38dc819 100644
> --- a/drivers/fpga/dfl.c
> +++ b/drivers/fpga/dfl.c
> @@ -783,6 +783,40 @@ void fpga_remove_feature_devs(struct fpga_cdev *cdev)
>  }
>  EXPORT_SYMBOL_GPL(fpga_remove_feature_devs);
> =20
> +/**
> + * __fpga_cdev_find_port - find a port under given container device
> + *
> + * @cdev: container device
> + * @data: data passed to match function
> + * @match: match function used to find specific port from the port devic=
e list
> + *
> + * Find a port device under container device. This function needs to be
> + * invoked with lock held.
> + *
> + * This function returns NULL if the device doesn't match and non-zero i=
f it
> + * does. If this function returns non-zero and a reference to the platfo=
rm
> + * device of port can be obtained.
> + *
> + * NOTE: you will need to drop the device reference with put_device() af=
ter use.
> + */
> +struct platform_device *
> +__fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
> +		      int (*match)(struct platform_device *, void *))
> +{
> +	struct feature_platform_data *pdata;
> +	struct platform_device *port_dev;
> +
> +	list_for_each_entry(pdata, &cdev->port_dev_list, node) {
> +		port_dev =3D pdata->dev;
> +
> +		if (match(port_dev, data) && get_device(&port_dev->dev))
> +			return port_dev;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(__fpga_cdev_find_port);
> +
>  int fpga_port_id(struct platform_device *pdev)
>  {
>  	void __iomem *base =3D get_feature_ioaddr_by_id(&pdev->dev,
> diff --git a/drivers/fpga/dfl.h b/drivers/fpga/dfl.h
> index 9b19399..d6ecda1 100644
> --- a/drivers/fpga/dfl.h
> +++ b/drivers/fpga/dfl.h
> @@ -356,4 +356,24 @@ struct fpga_cdev {
>  struct fpga_cdev *fpga_enumerate_feature_devs(struct fpga_enum_info *inf=
o);
>  void fpga_remove_feature_devs(struct fpga_cdev *cdev);
> =20
> +/*
> + * need to drop the device reference with put_device() after use port pl=
atform
> + * device returned by __fpga_cdev_find_port and fpga_cdev_find_port func=
tions.
> + */
> +struct platform_device *
> +__fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
> +		      int (*match)(struct platform_device *, void *));
> +
> +static inline struct platform_device *
> +fpga_cdev_find_port(struct fpga_cdev *cdev, void *data,
> +		    int (*match)(struct platform_device *, void *))
> +{
> +	struct platform_device *pdev;
> +
> +	mutex_lock(&cdev->lock);
> +	pdev =3D __fpga_cdev_find_port(cdev, data, match);
> +	mutex_unlock(&cdev->lock);
> +
> +	return pdev;
> +}
>  #endif /* __FPGA_DFL_H */
> --=20
> 2.7.4
>=20

Thanks,
Moritz

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEowQ4eJSlIZpNWnl2UVwKRFcJcNgFAlqEoicACgkQUVwKRFcJ
cNi8lgf8DVZG8kd5D9+MQo+c1/Mgzgok7FgT261n9yUNqlxXBoaOv2pfrasDizK0
LirxHxRVQwNihPtxEy5qU0SNlMB1zg1ab1I+pFrNEexnNi6uNFlb98r9D62DfZjC
RZOAU8JjrhFt/9pOFmEXbNtu5bWnrh8k0QpEOnrXoywksf6x3pptC7i/iBjsJYY/
JHrdPxhR0h5dU/fVAI97wwi7Fh47VkK5v0QETuuwLU3vsgIsepyACMzlBVJ272XW
75evaFyLufgeVcJQBFrpHI6lxcOBOmETv/gtxU6zdT4b05z5U52FtvCJ8dv9TavD
Nmo58GqObWu7noL1Mpsg7g4KiHPDDg==
=BgP7
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
