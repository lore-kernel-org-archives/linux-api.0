From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] arm: sunxi: input: RFC: Add sysfs voltage for
 sun4i-lradc driver
Date: Tue, 27 Jan 2015 10:18:29 +0100
Message-ID: <20150127091829.GD7200@lukather>
References: <1422291516-24895-1-git-send-email-plaes@plaes.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422291516-24895-1-git-send-email-plaes-q/aMd4JkU83YtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Priit Laes <plaes-q/aMd4JkU83YtjvyW6yDsg@public.gmane.org>
Cc: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:ARM/Allwinner A1X..." <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:SUN4I LOW RES ADC..." <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 26, 2015 at 06:58:32PM +0200, Priit Laes wrote:
> ---

Like Hans was pointing out, commit log and signed-off-by please

>  .../ABI/testing/sysfs-driver-input-sun4i-lradc     |  4 ++
>  drivers/input/keyboard/sun4i-lradc-keys.c          | 49 ++++++++++++++++=
+-----
>  2 files changed, 43 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-input-sun4i-lr=
adc
>=20
> diff --git a/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc b/D=
ocumentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> new file mode 100644
> index 0000000..e4e6448
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> @@ -0,0 +1,4 @@
> +What:		/sys/class/input/input(x)/device/voltage
> +Date:		February 2015
> +Contact:	Priit Laes <plaes-q/aMd4JkU83YtjvyW6yDsg@public.gmane.org>
> +Description:	ADC output voltage in microvolts or 0 if device is not open=
ed.

Why is it returning 0 when "device is not opened" ? What does that
even mean? You can't read that file without opening it.

> diff --git a/drivers/input/keyboard/sun4i-lradc-keys.c b/drivers/input/ke=
yboard/sun4i-lradc-keys.c
> index cc8f7dd..c0ab8ec 100644
> --- a/drivers/input/keyboard/sun4i-lradc-keys.c
> +++ b/drivers/input/keyboard/sun4i-lradc-keys.c
> @@ -79,10 +79,27 @@ struct sun4i_lradc_data {
>  	u32 vref;
>  };
> =20
> +static u32 sun4i_lradc_read_voltage(struct sun4i_lradc_data *lradc)
> +{
> +	u32 val =3D readl(lradc->base + LRADC_DATA0) & 0x3f;
> +	return val * lradc->vref / 63;
> +};
> +
> +static ssize_t
> +sun4i_lradc_dev_voltage_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct sun4i_lradc_data *lradc =3D dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", sun4i_lradc_read_voltage(lradc));
> +}
> +
> +static const DEVICE_ATTR(voltage, S_IRUGO, sun4i_lradc_dev_voltage_show,=
 NULL);
> +
>  static irqreturn_t sun4i_lradc_irq(int irq, void *dev_id)
>  {
>  	struct sun4i_lradc_data *lradc =3D dev_id;
> -	u32 i, ints, val, voltage, diff, keycode =3D 0, closest =3D 0xffffffff;
> +	u32 i, ints, voltage, diff, keycode =3D 0, closest =3D 0xffffffff;
> =20
>  	ints  =3D readl(lradc->base + LRADC_INTS);
> =20
> @@ -97,8 +114,7 @@ static irqreturn_t sun4i_lradc_irq(int irq, void *dev_=
id)
>  	}
> =20
>  	if ((ints & CHAN0_KEYDOWN_IRQ) && lradc->chan0_keycode =3D=3D 0) {
> -		val =3D readl(lradc->base + LRADC_DATA0) & 0x3f;
> -		voltage =3D val * lradc->vref / 63;
> +		voltage =3D sun4i_lradc_read_voltage(lradc);
> =20
>  		for (i =3D 0; i < lradc->chan0_map_count; i++) {
>  			diff =3D abs(lradc->chan0_map[i].voltage - voltage);
> @@ -156,7 +172,7 @@ static void sun4i_lradc_close(struct input_dev *dev)
>  }
> =20
>  static int sun4i_lradc_load_dt_keymap(struct device *dev,
> -				      struct sun4i_lradc_data *lradc)
> +				    struct sun4i_lradc_data *lradc)
>  {
>  	struct device_node *np, *pp;
>  	int i;
> @@ -168,8 +184,8 @@ static int sun4i_lradc_load_dt_keymap(struct device *=
dev,
> =20
>  	lradc->chan0_map_count =3D of_get_child_count(np);
>  	if (lradc->chan0_map_count =3D=3D 0) {
> -		dev_err(dev, "keymap is missing in device tree\n");
> -		return -EINVAL;
> +		dev_info(dev, "keymap is missing in device tree\n");
> +		return 0;
>  	}
> =20
>  	lradc->chan0_map =3D devm_kmalloc_array(dev, lradc->chan0_map_count,
> @@ -185,19 +201,19 @@ static int sun4i_lradc_load_dt_keymap(struct device=
 *dev,
> =20
>  		error =3D of_property_read_u32(pp, "channel", &channel);
>  		if (error || channel !=3D 0) {
> -			dev_err(dev, "%s: Inval channel prop\n", pp->name);
> +			dev_err(dev, "%s: Invalid 'channel' property\n", pp->name);
>  			return -EINVAL;
>  		}
> =20
>  		error =3D of_property_read_u32(pp, "voltage", &map->voltage);
>  		if (error) {
> -			dev_err(dev, "%s: Inval voltage prop\n", pp->name);
> +			dev_err(dev, "%s: Invalid 'voltage' property\n", pp->name);
>  			return -EINVAL;
>  		}
> =20
>  		error =3D of_property_read_u32(pp, "linux,code", &map->keycode);
>  		if (error) {
> -			dev_err(dev, "%s: Inval linux,code prop\n", pp->name);
> +			dev_err(dev, "%s: Invalid 'linux,code' property\n", pp->name);
>  			return -EINVAL;
>  		}
> =20
> @@ -257,14 +273,26 @@ static int sun4i_lradc_probe(struct platform_device=
 *pdev)
>  	if (error)
>  		return error;
> =20
> -	error =3D input_register_device(lradc->input);
> +	error =3D device_create_file(dev, &dev_attr_voltage);

As I told you already, if you're going to expose this an ADC in the
end, the proper solution is to use the IIO framework, not adding a
custom sysfs file.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx1flAAoJEBx+YmzsjxAgiWQP/1ayv3bVxxZbpJvu4909x0Ls
UO8f5eE/MiFhCc3Bwdg9cCxa2M/9waDSR2/j0QHe2xagNeQ1pCzl/SZ7MT3AGe7s
kQ67kuo8+SJ8g0KFBmHoQWZp1XhR8YnyJMEfDecGwn7fW2Nmo1K6MvYocIcKa8gt
geUqNpNkLX3mqs44DD0U1DrxPGc2F7ICRbexXxpTEEb/cqMFeqtuMtDaAbO4AQLj
feULJZI2IxKyrVLWvKNUz2QY7yKiTg8KUBawaejHjHQULk4lS1uLDW3+KoijiQfD
WVcViFiIfz0hrAMwgisdei3xHV+Wr7T/p+UZAklDnARdSwBVLaKkEEKmOG5OLUnu
DFQ0J1VvzSGQzECyS3EergD4wG3RNPKreFMT7QM0A/rMUCmMGGy5V57E3aOqwJug
uDAXkqhkYZJ+6XUL4xkd/erei4TmHJySDvZR/pp2kxYol9KTAF3g3snP+IZAMU/I
YoN3l9ejWbKpvkKDu6rd3t16RvoH6UnCPEWg20lrUARQKcHhRrUW++CKV9g1yraj
aY28y1NdqzCqrYkEOAECxLzVLEVq2HONo4xGjiqyEqh/M3TyYPZAQ6DpgNjKEvfM
BpVKSdgBrusA1kaXvm9MhSadx0U7QF41ZZJHEwdy62Af2WzHZqGPmDV+R167L1uk
YiefwoNmYDmcZcb/RCJP
=zl8g
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
