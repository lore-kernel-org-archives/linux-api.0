From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 1/1] Corsair Vengeance K90 driver
Date: Fri, 4 Sep 2015 15:27:02 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1509041518580.30132@pobox.suse.cz>
References: <cover.1440853951.git.clement.vuchener@gmail.com> <55E1BBC8.9010303@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E1BBC8.9010303@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Cl=E9ment_Vuchener?= <clement.vuchener@gmail.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 29 Aug 2015, Cl=E9ment Vuchener wrote:


This is missing changelog and Signed-off-by: line. I know that you have=
=20
provided that in your cover letter, but cover letter never make it to t=
he=20
actual GIT commits.

So please fix that and resend the patch, thanks.

> ---
>  Documentation/ABI/testing/sysfs-class-k90_profile  |  55 ++
>  .../ABI/testing/sysfs-driver-hid-corsair-k90       |  15 +
>  drivers/hid/Kconfig                                |  10 +
>  drivers/hid/Makefile                               |   1 +
>  drivers/hid/hid-core.c                             |   1 +
>  drivers/hid/hid-corsair-k90.c                      | 690
> +++++++++++++++++++++
>  drivers/hid/hid-ids.h                              |   3 +
>  7 files changed, 775 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-k90_profile
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-corsai=
r-k90
>  create mode 100644 drivers/hid/hid-corsair-k90.c
>=20
> diff --git a/Documentation/ABI/testing/sysfs-class-k90_profile
> b/Documentation/ABI/testing/sysfs-class-k90_profile
> new file mode 100644
> index 0000000..3275c16
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-k90_profile
> @@ -0,0 +1,55 @@
> +What:		/sys/class/k90_profile/<profile>/profile_number
> +Date:		August 2015
> +KernelVersion:	4.2
> +Contact:	Clement Vuchener <clement.vuchener@gmail.com>
> +Description:	Get the number of the profile.
> +
> +What:		/sys/class/k90_profile/<profile>/bindings
> +Date:		August 2015
> +KernelVersion:	4.2
> +Contact:	Clement Vuchener <clement.vuchener@gmail.com>
> +Description:	Write bindings to the keyboard on-board profile.
> +		The data structure is:
> +		 - number of bindings in this structure (1 byte)
> +		 - size of this data structure (2 bytes big endian)
> +		 - size of the macro data written to
> +		   /sys/class/k90_profile/<profile>/data (2 bytes big endian)
> +		 - array of bindings referencing the data from
> +		   /sys/class/k90_profile/<profile>/data, each containing:
> +		   * 0x10 for a key usage, 0x20 for a macro (1 byte)
> +		   * offset of the key usage/macro data (2 bytes big endian)
> +		   * length of the key usage/macro data (2 bytes big endian)
> +

This looks like violation of one-value-per-attribute rule for sysfs ABI=
=2E=20
Could you please think about it once again with this aspect on mind?

[ ... snip ... ]
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index e6fce23..f0d9125 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1807,6 +1807,7 @@ static const struct hid_device_id
> hid_have_special_driver[] =3D {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY,
> USB_DEVICE_ID_CHICONY_WIRELESS) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY,
> USB_DEVICE_ID_CHICONY_WIRELESS2) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_AK1D)=
 },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K90) =
},
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS,
> USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_CP2112)=
 },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,
> USB_DEVICE_ID_CYPRESS_BARCODE_1) },

Your mail client is corrupting long lines, making tha patch application=
=20
impossible. Please fix that for your following submissions.

> diff --git a/drivers/hid/hid-corsair-k90.c b/drivers/hid/hid-corsair-=
k90.c
> new file mode 100644
> index 0000000..67c1095
> --- /dev/null
> +++ b/drivers/hid/hid-corsair-k90.c
> @@ -0,0 +1,690 @@
> +/*
> + * HID driver for Corsair Vengeance K90 Keyboard

Usually we try to be a little bit more generic, and name the driver=20
according to the vendor (and fold all the vedor-specific stuff into the=
=20
one driver).

So my suggestion would be to name the driver hid-corsair, keeping the=20
possibility for adding more devices later open.

[ ... snip ... ]
> +static int k90_init_special_functions(struct hid_device *dev)
> +{
> +	int ret, i;
> +	struct usb_interface *usbif =3D to_usb_interface(dev->dev.parent);
> +	struct usb_device *usbdev =3D interface_to_usbdev(usbif);
> +	char data[8];
> +	struct k90_drvdata *drvdata =3D
> +	    kzalloc(sizeof(struct k90_drvdata), GFP_KERNEL);
> +	size_t name_sz;
> +	char *name;
> +	struct k90_led *led;
> +
> +	if (!drvdata) {
> +		ret =3D -ENOMEM;
> +		goto fail_drvdata;
> +	}
> +	hid_set_drvdata(dev, drvdata);
> +
> +	/* Get current status */
> +	ret =3D usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0),
> +			      K90_REQUEST_STATUS,
> +			      USB_DIR_IN | USB_TYPE_VENDOR |
> +			      USB_RECIP_DEVICE, 0, 0, data, 8,
> +			      USB_CTRL_SET_TIMEOUT);

So you apparently also depend on USB ...

> +	if (ret < 0) {
> +		hid_warn(dev, "Failed to get K90 initial state (error %d).\n",
> +			 ret);
> +		drvdata->backlight.brightness =3D 0;
> +		drvdata->current_profile =3D 1;
> +	} else {
> +		drvdata->backlight.brightness =3D data[4];
> +		drvdata->current_profile =3D data[7];
> +	}
> +	/* Get current mode */
> +	ret =3D usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0),
> +			      K90_REQUEST_GET_MODE,
> +			      USB_DIR_IN | USB_TYPE_VENDOR |
> +			      USB_RECIP_DEVICE, 0, 0, data, 2,
> +			      USB_CTRL_SET_TIMEOUT);
> +	if (ret < 0)
> +		hid_warn(dev, "Failed to get K90 initial mode (error %d).\n",
> +			 ret);
> +	else {
> +		switch (data[0]) {
> +		case K90_MACRO_MODE_HW:
> +			drvdata->macro_mode =3D 1;
> +			break;
> +		case K90_MACRO_MODE_SW:
> +			drvdata->macro_mode =3D 0;
> +			break;
> +		default:
> +			hid_warn(dev, "K90 in unknown mode: %02x.\n",
> +				 data[0]);
> +		}
> +	}
> +
> +	/* Init LED device for backlight */
> +	name_sz =3D
> +	    strlen(dev_name(&dev->dev)) + sizeof(K90_BACKLIGHT_LED_SUFFIX);
> +	name =3D devm_kzalloc(&dev->dev, name_sz, GFP_KERNEL);
> +	if (!name) {
> +		ret =3D -ENOMEM;
> +		goto fail_backlight;
> +	}
> +	snprintf(name, name_sz, "%s" K90_BACKLIGHT_LED_SUFFIX,
> +		 dev_name(&dev->dev));
> +	led =3D &drvdata->backlight;
> +	led->cdev.name =3D name;
> +	led->cdev.max_brightness =3D 3;
> +	led->cdev.brightness_set =3D k90_brightness_set;
> +	led->cdev.brightness_get =3D k90_brightness_get;
> +	INIT_WORK(&led->work, k90_backlight_work);
> +	ret =3D led_classdev_register(&dev->dev, &led->cdev);

=2E.. and also on LED subsystem, but this dependency is not expressed i=
n=20
Kconfig.

Thanks,

--=20
Jiri Kosina
SUSE Labs
