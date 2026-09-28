Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DD23E411C
	for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790600882; cv=pass; b=Yx44nkYpLX3ZbDWsCM4DGuNNPStlZCwZP+PyUP4DnszCRyZrQNup8qcP0b6y4OX8WSdMtwc08pM2VPobK56xtKcNSNvD5h7qR3Q5r91GRFsvcMPDNx5fNHnsTtOlXXfvnZCE2oCb8gOqs2BWe9+fi2B7X+iSaKOPq+82S9jD7QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790600882; c=relaxed/simple;
	bh=xEcymRmGszspdnukJ2qDwmGJzrkJxNGdwFUd0osA0MY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZysX/FcDUAOSo9h1JFn5hyVACH1EhtAdOGsTNyDzBBrvIzLCPxCfmlFThW8WeV9gq6sFI1Yi0E1w1q8TphyC8m/kMjpb8eO4qwLb06iD8/Auc2Mkw09E01Fyao4rIzlSJKKYZHkju/8INB3TAIBu5Iqzw+LDP+aIGR5il9XcFNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ma/yyqIV; arc=pass smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ma/yyqIV"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aafe2a64efso2831483a12.2
        for <linux-api@vger.kernel.org>; Mon, 28 Sep 2026 06:07:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790600877; cv=none;
        d=google.com; s=arc-20260327;
        b=l7aDyJ03X1NkTawwJTZlmEQhx15IWlEMQVEI2FVEYjJLd3Jim98N5I0Um66S/+pFFr
         8Ikq7P/zoBTWbMAF/PuepanAQdhAc6kJyL3eO9AY4Mk8HZoky0Bh2ALt0fATvewF6wNC
         2y17tka3/w0c2t3tvexFUG0mnSb8y58GSHr1nNnM+BecBzKVQL2+AxAA7jpA72dmT4Wd
         8DZYGnotNfNYsSDXdIAF4ydyxCE5HugVJ9ihNkfNc7Fqq7PkSVqp8uYnD2IfPXEiU2SZ
         tlh//FH/tX3EnL4IesxVkgxIMUZnfSy0PVmrVSrZOBTAISbQVcXI5ELdFHfJy+Pme17f
         c+DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LocOq6XG/4rm3dtwjOYm+24mahJp9YZapm60UEYrnpU=;
        fh=F3i77O0m/0W0QffoxP9rxugvq+QyWLECj4X9+5rPyb8=;
        b=MuohHN6R9gEt201aww1z3vzuMWGxfXKLm7J7VEpU6YLye3PV5kBcs+b3RMiR2Mk8qC
         mvG6LVB6utp84o8XgtBSJMsp1sb7V1WMCxVsusAnXQLyCxX5pf9/GTlFTUw+TQOze/6s
         xjwXkqWTAn6rY9l6SoOutlMJ2t9E+7gJsdgs4n2c/bm5+21mUSsLBZsAfVF/53sIvRa6
         D8WaZp5hZ9r1xA+ed5KROhK67stOBp3D8l4EutdhPE9n0V4dNPUTX4e4dROVSNGwR3xK
         H5KP8fRjlTNTSoPSlPHRJiu5ahLriwaomB9Oe5ZxLqy60376Bv7voDADgkR5HrVjwdx2
         n9+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790600877; x=1791205677; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LocOq6XG/4rm3dtwjOYm+24mahJp9YZapm60UEYrnpU=;
        b=ma/yyqIV6I9wSrTVT0HMFEi1kTrXqW9LVSpyyjZpY03eYHjRr5e5HwmfziYcwnoBBn
         5EaY3DNnp1RZsV8APCX4HDPAKzrfnxPHK49dwyEP/qL5gk9A8x9e5aiROF/6LAz7foBZ
         JO15CSz1+UvCIN+LQZttxSQJaJ2Z2ukiM/5OlvzzTWdHlGfriFv/+68B1oHh4dyk6UUu
         +BYjQjmakJZRfQbJ1iy2PBVGBuLcfrMrvq/wJUjbBwcfsAQRVEH+knwVC/lSuTutMskK
         Ue4RRpeZ/0/gYoIQz0dTGoqRQNW3TpbU+D1R2GdTtX9IUdS2AJ9cpbQX6eJypS3WRCoG
         hSTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790600877; x=1791205677;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LocOq6XG/4rm3dtwjOYm+24mahJp9YZapm60UEYrnpU=;
        b=IPCR3JKGcTwlTA8i62aoMyT2M1/8CcEcPoErwoWdFjaGO2Ky4MvEhBIyTKPkWfloxw
         o64uF5vMCv9zhvUGvfvLdm47nGbekIjUB9y3BZ94xDprErmpO831oKUTa4Wd4eCpyzmJ
         e2Y6gNdzD8Y3kspqkKeOUTuTeLDxmoN/M9zREm+A53fI5Z3s8NONQ4wAHtInnxnC81AH
         HnbQR8gmxhppUHXTUkRh8rMRkBGSgGoGwVeddsH3hQ+UxMc5fuQB+171soaxfVzARDA7
         nuTokhjSHN+v/3k74cVaEUL6O7glDkkp3VE7wl1V/UY/q7hthNMXrO2egRzc2rVs6y5t
         +BvQ==
X-Forwarded-Encrypted: i=1; AKwUvBztNxsOXES0h9EjIGgCOXNMz2flOgSttpeUNfDdhmNSTrBNfM5quzY+TPSMxB8BS3Dy5Dah/bQf4f0=@vger.kernel.org
X-Gm-Message-State: AFuF++kHhkSQ+Q4eNbxMCV6MaqIAb/GxIVzewruvFB8lLp0bLkcdiFS2
	gVeQgYLpsY5PMT1jVTAC6ojbXUDVvMLro4GZOXsJgaVxFdyf58yN8vz3GSmHFI6fQcIaQyYAOm3
	jqyPf5fHlgMSdNmJ6vWUbc8uvsitr/blNTZNVrFDcOw==
X-Gm-Gg: AYBFou3iWzUGvds3Eac4ywbbknlNHCUc51CF2JAeURq7gHaSbHl0WmEG3GAzlXvg1u3
	R3OerHsbafzcHGdShbszrWVBFmOfp8VKXbxOG4cJew1IA9FONjChY+ijAKZgm4urZszEyxqrkU6
	H9yHNaYk+CjwHzD6WeHsTk0u4q2X7qMhhgB6gweFwVApN9fuhFSw0owtuv56SO6TG2Nmw5SZIFf
	HJw0MlCYlt5Z4rqHpb7WuMAKYwFlCqu+2KewI+y/iUgo/bn/C8VnM54s6tAv0KRQZxWAzttB5dU
	hTudtmOBDwabsJPA0NfUAWD6yX/X8boLpF30f5IpS2ZY/U+hTwaGXqKtKru7Nr6x7toLYZaG03h
	yGsBzcxDf9X+OxHpdZdwryYW3RvtkEppRMhc3Pczuwlvuqfu/hAIBONFU8HmcPPTWnNaNIM8QR4
	Csqg4/ld19e0ylQIKdGZ9mn+9t8jp3ODCbfNRI5dDQ
X-Received: by 2002:a17:907:d005:b0:c26:2151:180a with SMTP id
 a640c23a62f3a-c2ac525fe62mr1010298366b.3.1790600877277; Mon, 28 Sep 2026
 06:07:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928111907.72592-1-pepe.schlehofer@gmail.com> <20260928111907.72592-3-pepe.schlehofer@gmail.com>
In-Reply-To: <20260928111907.72592-3-pepe.schlehofer@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 28 Sep 2026 16:07:20 +0300
X-Gm-Features: AclHuK8LrUHy1cNTkceV0KejktAKpvV1sU6tn8Odpjfo0Yk1ssM4v7bILMVuPmU
Message-ID: <CAHp75VeH70LshOt0qzrvLkZYqDx=43o=34_wmHWkbYcTy7Z3vA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] leds: Add support for Turris 1.x LEDs
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	=?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	=?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	Andy Shevchenko <andy@kernel.org>, Rong Zhang <i@rong.moe>, linux-leds@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 28, 2026 at 2:19=E2=80=AFPM Josef Schlehofer
<pepe.schlehofer@gmail.com> wrote:
>
> From: Pali Roh=C3=A1r <pali@kernel.org>
>
> Add a driver for the eight RGB LEDs on the front panel of the CZ.NIC
> Turris 1.x routers. They are driven by the CZ.NIC CPLD firmware, whose
> source is available at
> https://gitlab.nic.cz/turris/hw/turris_cpld/-/blob/master/CZ_NIC_Router_C=
PLD.v
>
> The LEDs use the multicolor LED class. Every LED except the WiFi LED can
> also be driven by the CPLD from hardware events, exposed as the private
> turris1x-cpld trigger. The five LAN LEDs share one set of colour
> registers, so the colour and brightness set last on any of them apply
> to all five.
>
> The controller device exposes the global brightness controlled by the
> button on the back of the router through `brightness`,
> `brightness_level`, and `brightness_levels/<N>`. The Turris Omnia
> driver already has `brightness`, so its ABI entry is extended to cover
> the Turris 1.x as well.

> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>

> Cc: Marek Beh=C3=BAn <kabel@kernel.org>
> Cc: Andy Shevchenko <andy@kernel.org>

Please, move these (Cc list) to the block under the cutter '---' line,
so it won't pollute the commit message.

> Co-developed-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
> ---

...

>  What:          /sys/class/leds/<led>/device/brightness
> -Date:          July 2020
> -KernelVersion: 5.9
> -Contact:       Marek Beh=C3=BAn <kabel@kernel.org>

> +Date:          July 2020 (Turris Omnia), September 2026 (Turris 1.x)
> +KernelVersion: 5.9 (Turris Omnia), 7.4 (Turris 1.x)

This is quite unusual. If you want to refer to the kernel version, do
it in the description. Also note the version (see below more on it).

> +Contact:       Marek Beh=C3=BAn <kabel@kernel.org>, linux-leds@vger.kern=
el.org

Why? The mailing list is kinda default, no?

...

> +What:          /sys/class/leds/<led>/device/brightness_level
> +Date:          September 2026

Impossible. Use https://hansen.beer/~dave/phb/ to predict the dates of
the next release, this is a huge driver that most likely may not make
v7.4, so the v7.5 is a plausible candidate.

> +Contact:       Josef Schlehofer <pepe.schlehofer@gmail.com>
> +Description:   (RW) Index (0-7) of the global brightness level in use on=
 the
> +               Turris 1.x routers. The button on the back side of the ro=
uter
> +               steps through the levels. Writing to this file selects a =
level
> +               directly. The CPLD keeps the selection across driver unbi=
nd and

the driver

> +               reboot.
> +
> +               Format: %u
> +
> +What:          /sys/class/leds/<led>/device/brightness_levels/<N>
> +Date:          September 2026

As per above

> +Contact:       Josef Schlehofer <pepe.schlehofer@gmail.com>
> +Description:   (RW) Value of the global brightness level N (0-7) on the
> +               Turris 1.x routers, one file per level. These are the val=
ues
> +               the CPLD firmware steps through when the brightness butto=
n is
> +               pressed. Reading returns the value, writing accepts an in=
teger
> +               between 0 and 255. The CPLD keeps the values across drive=
r

the driver

> +               unbind and reboot, and restores the defaults (255 64 32 1=
6 8 4
> +               2 0) at power-on and when the reset button is pressed.

...

> +#include <linux/bits.h>
> +#include <linux/container_of.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kstrtox.h>
> +#include <linux/led-class-multicolor.h>
> +#include <linux/leds.h>
> +#include <linux/limits.h>
> +#include <linux/math.h>
> +#include <linux/minmax.h>

> +#include <linux/mod_devicetable.h>

Not anymore. Rely on what platform_device.h provides.

> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/property.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
> +#include <linux/types.h>

...

> +struct turris1x_leds {
> +       void __iomem *regs;
> +       /* Protects the CPLD LED registers and @reset */
> +       spinlock_t lock;
> +       /* Set by turris1x_leds_reset(), after which the LEDs are left al=
one */
> +       bool reset;
> +       struct turris1x_led led[TURRIS1X_LED_NUM];

Please, check the layout of all structures with `pahole`, it might
suggest a better one.

> +};

...

> +/* Must be called with ddata->lock held */

This is good, but having a lockdep annotation is even better.

> +static void turris1x_led_set_colors(struct turris1x_leds *ddata, struct =
turris1x_led *led,
> +                                   enum led_brightness brightness)
> +{
> +       struct led_classdev_mc *mc_cdev =3D &led->mc_cdev;
> +       unsigned int i;
> +       u8 val;
> +
> +       led_mc_calc_color_components(mc_cdev, brightness);
> +
> +       /* The colour registers are 8 bits wide, do not let values wrap *=
/
> +       for (i =3D 0; i < TURRIS1X_LED_NUM_COLORS; i++) {

for (unsigned int i...) {

> +               val =3D min_t(unsigned int, mc_cdev->subled_info[i].brigh=
tness, U8_MAX);

No min_t(), it should be an exceptional use, and it was especially
proven to have issues with < INT_MAX comparisons in some cases. I
think you mean to have clamp() here.

> +               turris1x_write(ddata, turris1x_color_reg(led->reg, i), va=
l);
> +       }
> +}

...

> +static int turris1x_hwtrig_activate(struct led_classdev *cdev)
> +{
> +       struct turris1x_leds *ddata =3D dev_get_drvdata(cdev->dev->parent=
);
> +       struct turris1x_led *led =3D to_turris1x_led(cdev);
> +       unsigned long flags;
> +       u8 val;
> +
> +       spin_lock_irqsave(&ddata->lock, flags);

Why not guard()()?

> +       if (ddata->reset)
> +               goto unlock;
> +
> +       /*
> +        * If software turned the LED off, the last configured colour was=
 not
> +        * necessarily written to the CPLD. Write it with max_brightness =
before
> +        * the hardware takes over.
> +        */
> +       if (!led->on)
> +               turris1x_led_set_colors(ddata, led, cdev->max_brightness)=
;
> +
> +       /* Disable LED software control */
> +       val =3D turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
> +       turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, val & ~BIT(le=
d->reg));
> +
> +       led->hwtrig =3D true;
> +
> +unlock:
> +       spin_unlock_irqrestore(&ddata->lock, flags);
> +
> +       return 0;
> +}

...

> +       /*
> +        * Enable or disable the LED under software control. The CPLD ign=
ores
> +        * this bit while the hardware trigger drives the LED, so leave i=
t
> +        * alone.
> +        */
> +       if (!led->hwtrig) {
> +               val =3D turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG)=
;
> +               if (brightness)
> +                       val &=3D ~BIT(led->reg);
> +               else
> +                       val |=3D BIT(led->reg);

If led->reg is unsigned long, you can use __asign_bit() here.

> +               turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, val);
> +               led->on =3D !!brightness;
> +       }

...

> +static int turris1x_led_register(struct device *dev, struct turris1x_led=
s *ddata,
> +                                struct fwnode_handle *fwnode, u8 val_sw_=
override,
> +                                u8 val_sw_disable)
> +{
> +       static const unsigned int colors[TURRIS1X_LED_NUM_COLORS] =3D {
> +               LED_COLOR_ID_RED, LED_COLOR_ID_GREEN, LED_COLOR_ID_BLUE,
> +       };
> +       struct led_init_data init_data =3D {};
> +       struct led_classdev *cdev;
> +       struct turris1x_led *led;
> +       unsigned long flags;
> +       u8 val, dis;
> +       u32 reg, color;
> +       unsigned int i;
> +       int ret;
> +
> +       ret =3D fwnode_property_read_u32(fwnode, "reg", &reg);
> +       if (ret || reg >=3D TURRIS1X_LED_NUM)
> +               return dev_err_probe(dev, -EINVAL, "Invalid or missing 'r=
eg' property\n");
> +
> +       ret =3D fwnode_property_read_u32(fwnode, "color", &color);
> +       if (ret || color !=3D LED_COLOR_ID_RGB)
> +               return dev_err_probe(dev, -EINVAL, "Invalid or missing 'c=
olor' property\n");

Do not shadow the error code.

> +       led =3D &ddata->led[reg];
> +       if (led->registered)
> +               return dev_err_probe(dev, -EINVAL, "LED %u already regist=
ered\n", reg);

EBUSY / EEXIST ?

> +       led->reg =3D reg;
> +
> +       /* Set the initial colours to those currently in use */
> +       for (i =3D 0; i < TURRIS1X_LED_NUM_COLORS; i++) {

for (unsigned int i...) {

> +               led->subled_info[i].intensity =3D turris1x_read(ddata, tu=
rris1x_color_reg(reg, i));
> +               led->subled_info[i].color_index =3D colors[i];
> +               led->subled_info[i].channel =3D i;
> +       }
> +
> +       /*
> +        * LEDs 1-5 (LAN) share one set of colour registers, and the brig=
htness
> +        * of an LED is applied by scaling its colour, so all of them sho=
w the
> +        * colour and brightness written last. Each LED still keeps its o=
wn
> +        * intensities and brightness, so multi_intensity and brightness =
report
> +        * what the LED was last given, which is not necessarily what it =
shows.
> +        */
> +       led->mc_cdev.subled_info =3D led->subled_info;
> +       led->mc_cdev.num_colors =3D TURRIS1X_LED_NUM_COLORS;
> +
> +       init_data.fwnode =3D fwnode;
> +
> +       cdev =3D &led->mc_cdev.led_cdev;
> +       cdev->max_brightness =3D 255;
> +       cdev->brightness_set =3D turris1x_led_brightness_set;
> +
> +       /* All LEDs except the WiFi LED can be driven by the hardware tri=
gger */
> +       if (reg !=3D TURRIS1X_LED_WIFI) {
> +               cdev->trigger_type =3D &turris1x_hw_trigger_type;
> +               cdev->hw_control_trigger =3D turris1x_hw_trigger.name;
> +       }
> +
> +       if (!(val_sw_override & BIT(reg)))
> +               cdev->default_trigger =3D turris1x_hw_trigger.name;
> +
> +       if (!(val_sw_override & BIT(reg)) || !(val_sw_disable & BIT(reg))=
)
> +               cdev->brightness =3D cdev->max_brightness;
> +
> +       led->on =3D !(val_sw_disable & BIT(reg));
> +
> +       ret =3D devm_led_classdev_multicolor_register_ext(dev, &led->mc_c=
dev, &init_data);
> +       if (ret)
> +               return dev_err_probe(dev, ret, "Cannot register LED %u\n"=
, reg);
> +
> +       /*
> +        * A linux,default-trigger property replaces the hardware trigger=
, and
> +        * the CPLD then keeps driving the LED and ignores software contr=
ol.
> +        * Take such an LED over in the state the LED core reports.
> +        */
> +       spin_lock_irqsave(&ddata->lock, flags);
> +       val =3D turris1x_read(ddata, TURRIS1X_LED_SW_OVERRIDE_REG);
> +       if (!led->hwtrig && !(val & BIT(reg))) {
> +               dis =3D turris1x_read(ddata, TURRIS1X_LED_SW_DISABLE_REG)=
;
> +               if (cdev->brightness)
> +                       dis &=3D ~BIT(reg);
> +               else
> +                       dis |=3D BIT(reg);
> +               turris1x_write(ddata, TURRIS1X_LED_SW_DISABLE_REG, dis);
> +               led->on =3D !!cdev->brightness;
> +               turris1x_write(ddata, TURRIS1X_LED_SW_OVERRIDE_REG, val |=
 BIT(reg));
> +       }
> +       spin_unlock_irqrestore(&ddata->lock, flags);
> +
> +       led->registered =3D true;
> +
> +       return 0;
> +}

...

> +       best_level =3D 0;
> +       best_error =3D INT_MAX;
> +       for (level =3D 0; level < TURRIS1X_LED_NUM_LEVELS; level++) {

Ditto.

> +               value =3D turris1x_read(ddata, TURRIS1X_LED_LEVEL_VALUE_R=
EG + level);
> +               error =3D abs(value - brightness);
> +               if (error < best_error) {
> +                       best_error =3D error;
> +                       best_level =3D level;
> +               }
> +       }

...

> +/* _level is always a literal 0..7, it is pasted, stringified and stored=
 */
> +#define TURRIS1X_LEVEL_ATTR(_level)                                     =
       \
> +       static struct turris1x_level_attr turris1x_level_attr_##_level =
=3D {      \
> +               .attr =3D __ATTR(_level, 0644, brightness_level_value_sho=
w,       \
> +                              brightness_level_value_store),            =
       \

Don't we have __ATTR_RW() ?

> +               .level =3D _level,                                       =
         \
> +       }

...

> +       device_for_each_child_node_scoped(dev, child) {
> +               ret =3D turris1x_led_register(dev, ddata, child, val_sw_o=
verride, val_sw_disable);
> +               if (ret)
> +                       return ret;
> +               count++;
> +       }

> +       if (!count)
> +               return dev_err_probe(dev, -ENODEV, "No LED devices found =
in device tree\n");

We have counting API, so this can be done ahead. Yes, it will iterate
over the list twice, but I don't think it's an issue.

--=20
With Best Regards,
Andy Shevchenko
