From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH v3] gpio: lib-sysfs: Add 'wakeup' attribute
Date: Mon, 1 Dec 2014 10:21:40 -0800
Message-ID: <51327750bb694f229ecb1c229cb80b21@BN1AFFO11FD023.protection.gbl>
References: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot <gnurou@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Another month past. Any updates on this?

	Thanks,
	S=C3=B6ren

On Mon, 2014-10-27 at 11:30AM -0700, Soren Brinkmann wrote:
> Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> marking/unmarking a GPIO as wake IRQ.
> The file 'wakeup' is created in each exported GPIOs directory, if an =
IRQ
> is associated with that GPIO and the irqchip implements set_wake().
> Writing 'enabled' to that file will enable wake for that GPIO, while
> writing 'disabled' will disable wake.
> Reading that file will return either 'disabled' or 'enabled' depening=
 on
> the currently set flag for the GPIO's IRQ.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> v3:
>  - add documentation
> v2:
>  - fix error path to unlock mutex before return
>=20
> As additional reference, these are the email threads of the v2 and v1
> submission:
> https://lkml.org/lkml/2014/10/13/481
> https://lkml.org/lkml/2014/9/4/496
> ---
>  Documentation/ABI/testing/sysfs-gpio |  1 +
>  Documentation/gpio/sysfs.txt         |  8 ++++
>  drivers/gpio/gpiolib-sysfs.c         | 77 ++++++++++++++++++++++++++=
+++++++---
>  3 files changed, 80 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-gpio b/Documentation/ABI=
/testing/sysfs-gpio
> index 80f4c94c7bef..4cc7f4b3f724 100644
> --- a/Documentation/ABI/testing/sysfs-gpio
> +++ b/Documentation/ABI/testing/sysfs-gpio
> @@ -20,6 +20,7 @@ Description:
>  	    /value ... always readable, writes fail for input GPIOs
>  	    /direction ... r/w as: in, out (default low); write: high, low
>  	    /edge ... r/w as: none, falling, rising, both
> +	    /wakeup ... r/w as: enabled, disabled
>  	/gpiochipN ... for each gpiochip; #N is its first GPIO
>  	    /base ... (r/o) same as N
>  	    /label ... (r/o) descriptive, not necessarily unique
> diff --git a/Documentation/gpio/sysfs.txt b/Documentation/gpio/sysfs.=
txt
> index c2c3a97f8ff7..f703377d528f 100644
> --- a/Documentation/gpio/sysfs.txt
> +++ b/Documentation/gpio/sysfs.txt
> @@ -97,6 +97,14 @@ and have the following read/write attributes:
>  		for "rising" and "falling" edges will follow this
>  		setting.
> =20
> +	"wakeup" ... reads as either "enabled" or "disabled". Write these
> +		strings to set/clear the 'wakeup' flag of the IRQ associated
> +		with this GPIO. If the IRQ has the 'wakeup' flag set, it can
> +		wake the system from sleep states.
> +
> +		This file exists only if the pin can generate interrupts and
> +		the driver implements the required infrastructure.
> +
>  GPIO controllers have paths like /sys/class/gpio/gpiochip42/ (for th=
e
>  controller implementing GPIOs starting at #42) and have the followin=
g
>  read-only attributes:
> diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysf=
s.c
> index 5f2150b619a7..7588b6d5ba94 100644
> --- a/drivers/gpio/gpiolib-sysfs.c
> +++ b/drivers/gpio/gpiolib-sysfs.c
> @@ -286,6 +286,58 @@ found:
> =20
>  static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
> =20
> +static ssize_t gpio_wakeup_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	ssize_t			status;
> +	const struct gpio_desc	*desc =3D dev_get_drvdata(dev);
> +	int			irq =3D gpiod_to_irq(desc);
> +	struct irq_desc		*irq_desc =3D irq_to_desc(irq);
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (irqd_is_wakeup_set(&irq_desc->irq_data))
> +		status =3D sprintf(buf, "enabled\n");
> +	else
> +		status =3D sprintf(buf, "disabled\n");
> +
> +	mutex_unlock(&sysfs_lock);
> +
> +	return status;
> +}
> +
> +static ssize_t gpio_wakeup_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	int			ret;
> +	unsigned int		on;
> +	struct gpio_desc	*desc =3D dev_get_drvdata(dev);
> +	int			irq =3D gpiod_to_irq(desc);
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (sysfs_streq("enabled", buf)) {
> +		on =3D true;
> +	} else if (sysfs_streq("disabled", buf)) {
> +		on =3D false;
> +	} else {
> +		mutex_unlock(&sysfs_lock);
> +		return -EINVAL;
> +	}
> +
> +	ret =3D irq_set_irq_wake(irq, on);
> +
> +	mutex_unlock(&sysfs_lock);
> +
> +	if (ret)
> +		pr_warn("%s: failed to %s wake\n", __func__,
> +				on ? "enable" : "disable");
> +
> +	return size;
> +}
> +
> +static DEVICE_ATTR(wakeup, 0644, gpio_wakeup_show, gpio_wakeup_store=
);
> +
>  static int sysfs_set_active_low(struct gpio_desc *desc, struct devic=
e *dev,
>  				int value)
>  {
> @@ -526,7 +578,7 @@ static struct class gpio_class =3D {
>  int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>  {
>  	unsigned long		flags;
> -	int			status;
> +	int			status, irq;
>  	const char		*ioname =3D NULL;
>  	struct device		*dev;
>  	int			offset;
> @@ -582,11 +634,24 @@ int gpiod_export(struct gpio_desc *desc, bool d=
irection_may_change)
>  			goto fail_unregister_device;
>  	}
> =20
> -	if (gpiod_to_irq(desc) >=3D 0 && (direction_may_change ||
> -				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
> -		status =3D device_create_file(dev, &dev_attr_edge);
> -		if (status)
> -			goto fail_unregister_device;
> +	irq =3D gpiod_to_irq(desc);
> +	if (irq >=3D 0) {
> +		struct irq_desc *irq_desc =3D irq_to_desc(irq);
> +		struct irq_chip	*irqchip =3D irq_desc_get_chip(irq_desc);
> +
> +		if (direction_may_change ||
> +				!test_bit(FLAG_IS_OUT, &desc->flags)) {
> +			status =3D device_create_file(dev, &dev_attr_edge);
> +			if (status)
> +				goto fail_unregister_device;
> +		}
> +
> +		if (irqchip->flags & IRQCHIP_SKIP_SET_WAKE ||
> +				irqchip->irq_set_wake) {
> +			status =3D device_create_file(dev, &dev_attr_wakeup);
> +			if (status)
> +				goto fail_unregister_device;
> +		}
>  	}
> =20
>  	set_bit(FLAG_EXPORT, &desc->flags);
> --=20
> 2.1.2.1.g5e69ed6
>=20
