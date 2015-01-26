From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm: sunxi: input: RFC: Add sysfs voltage
 for sun4i-lradc driver
Date: Mon, 26 Jan 2015 20:28:29 +0100
Message-ID: <54C6955D.403@redhat.com>
References: <1422291516-24895-1-git-send-email-plaes@plaes.org>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Return-path: <linux-sunxi+bncBDRZXY4CYYORB3NKTKTAKGQE2WXYBGI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1422291516-24895-1-git-send-email-plaes-q/aMd4JkU83YtjvyW6yDsg@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
To: Priit Laes <plaes-q/aMd4JkU83YtjvyW6yDsg@public.gmane.org>
Cc: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ABI/API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:ARM/Allwinner A1X..." <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:SUN4I LOW RES ADC..." <linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On 26-01-15 17:58, Priit Laes wrote:

No commit message? Please write an informative commit msg, like why we want this patch,
I guess it is to help figuring out the voltage levels for various buttons when creating
a dts, but I would prefer to not guess, which is where a good commit message would
come in handy ...

> ---
>   .../ABI/testing/sysfs-driver-input-sun4i-lradc     |  4 ++
>   drivers/input/keyboard/sun4i-lradc-keys.c          | 49 +++++++++++++++++-----
>   2 files changed, 43 insertions(+), 10 deletions(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> new file mode 100644
> index 0000000..e4e6448
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> @@ -0,0 +1,4 @@
> +What:		/sys/class/input/input(x)/device/voltage
> +Date:		February 2015
> +Contact:	Priit Laes <plaes-q/aMd4JkU83YtjvyW6yDsg@public.gmane.org>
> +Description:	ADC output voltage in microvolts or 0 if device is not opened.
> diff --git a/drivers/input/keyboard/sun4i-lradc-keys.c b/drivers/input/keyboard/sun4i-lradc-keys.c
> index cc8f7dd..c0ab8ec 100644
> --- a/drivers/input/keyboard/sun4i-lradc-keys.c
> +++ b/drivers/input/keyboard/sun4i-lradc-keys.c
> @@ -79,10 +79,27 @@ struct sun4i_lradc_data {
>   	u32 vref;
>   };
>
> +static u32 sun4i_lradc_read_voltage(struct sun4i_lradc_data *lradc)
> +{
> +	u32 val = readl(lradc->base + LRADC_DATA0) & 0x3f;
> +	return val * lradc->vref / 63;
> +};
> +
> +static ssize_t
> +sun4i_lradc_dev_voltage_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct sun4i_lradc_data *lradc = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%u\n", sun4i_lradc_read_voltage(lradc));
> +}
> +
> +static const DEVICE_ATTR(voltage, S_IRUGO, sun4i_lradc_dev_voltage_show, NULL);
> +
>   static irqreturn_t sun4i_lradc_irq(int irq, void *dev_id)
>   {
>   	struct sun4i_lradc_data *lradc = dev_id;
> -	u32 i, ints, val, voltage, diff, keycode = 0, closest = 0xffffffff;
> +	u32 i, ints, voltage, diff, keycode = 0, closest = 0xffffffff;
>
>   	ints  = readl(lradc->base + LRADC_INTS);
>
> @@ -97,8 +114,7 @@ static irqreturn_t sun4i_lradc_irq(int irq, void *dev_id)
>   	}
>
>   	if ((ints & CHAN0_KEYDOWN_IRQ) && lradc->chan0_keycode == 0) {
> -		val = readl(lradc->base + LRADC_DATA0) & 0x3f;
> -		voltage = val * lradc->vref / 63;
> +		voltage = sun4i_lradc_read_voltage(lradc);
>
>   		for (i = 0; i < lradc->chan0_map_count; i++) {
>   			diff = abs(lradc->chan0_map[i].voltage - voltage);
> @@ -156,7 +172,7 @@ static void sun4i_lradc_close(struct input_dev *dev)
>   }
>
>   static int sun4i_lradc_load_dt_keymap(struct device *dev,
> -				      struct sun4i_lradc_data *lradc)
> +				    struct sun4i_lradc_data *lradc)
>   {
>   	struct device_node *np, *pp;
>   	int i;

Why this identation change ?

> @@ -168,8 +184,8 @@ static int sun4i_lradc_load_dt_keymap(struct device *dev,
>
>   	lradc->chan0_map_count = of_get_child_count(np);
>   	if (lradc->chan0_map_count == 0) {
> -		dev_err(dev, "keymap is missing in device tree\n");
> -		return -EINVAL;
> +		dev_info(dev, "keymap is missing in device tree\n");
> +		return 0;
>   	}
>
>   	lradc->chan0_map = devm_kmalloc_array(dev, lradc->chan0_map_count,

I assume this is so that people can still use the sysfs node, to create a dts, right
not sure I like this, might be better to document to simple create a dts with
a single button mapping for 200 mV (most board use 200 mV steps between the buttons).

> @@ -185,19 +201,19 @@ static int sun4i_lradc_load_dt_keymap(struct device *dev,
>
>   		error = of_property_read_u32(pp, "channel", &channel);
>   		if (error || channel != 0) {
> -			dev_err(dev, "%s: Inval channel prop\n", pp->name);
> +			dev_err(dev, "%s: Invalid 'channel' property\n", pp->name);
>   			return -EINVAL;
>   		}
>
>   		error = of_property_read_u32(pp, "voltage", &map->voltage);
>   		if (error) {
> -			dev_err(dev, "%s: Inval voltage prop\n", pp->name);
> +			dev_err(dev, "%s: Invalid 'voltage' property\n", pp->name);
>   			return -EINVAL;
>   		}
>
>   		error = of_property_read_u32(pp, "linux,code", &map->keycode);
>   		if (error) {
> -			dev_err(dev, "%s: Inval linux,code prop\n", pp->name);
> +			dev_err(dev, "%s: Invalid 'linux,code' property\n", pp->name);
>   			return -EINVAL;
>   		}
>

This hunk / 3 changes belong in a separate patch. Also please run checkpatch, I think
you're running over 80 chars here.


> @@ -257,14 +273,26 @@ static int sun4i_lradc_probe(struct platform_device *pdev)
>   	if (error)
>   		return error;
>
> -	error = input_register_device(lradc->input);
> +	error = device_create_file(dev, &dev_attr_voltage);
>   	if (error)
>   		return error;
>
> +	error = input_register_device(lradc->input);
> +	if (error) {
> +		device_remove_file(&pdev->dev, &dev_attr_voltage);
> +		return error;
> +	}
> +
>   	platform_set_drvdata(pdev, lradc);
>   	return 0;
>   }
>
> +static int sun4i_lradc_remove(struct platform_device *pdev)
> +{
> +	device_remove_file(&pdev->dev, &dev_attr_voltage);
> +	return 0;
> +}
> +

This looks wrong, I think (*) that we've a bug here because we're not
unregistering the input device, so maybe do 2 patches, 1 fixing the
not unregistering bug, and then just add the device_remove_file()
in the sysfs patch.

>   static const struct of_device_id sun4i_lradc_of_match[] = {
>   	{ .compatible = "allwinner,sun4i-a10-lradc-keys", },
>   	{ /* sentinel */ }


> @@ -277,6 +305,7 @@ static struct platform_driver sun4i_lradc_driver = {
>   		.of_match_table = of_match_ptr(sun4i_lradc_of_match),
>   	},
>   	.probe	= sun4i_lradc_probe,
> +	.remove = sun4i_lradc_remove,
>   };
>
>   module_platform_driver(sun4i_lradc_driver);
>

Regards,

Hans


*) But I'm not sure, better double check.
