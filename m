From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [RESEND PATCH v3 1/1] Add Corsair Vengeance K90 driver
Date: Wed, 30 Sep 2015 21:33:36 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1509302121020.30132@pobox.suse.cz>
References: <cover.1443618411.git.clement.vuchener@gmail.com> <537ca04defeedd034ee27c5fe58a56bccca08e02.1443618411.git.clement.vuchener@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <537ca04defeedd034ee27c5fe58a56bccca08e02.1443618411.git.clement.vuchener@gmail.com>
Sender: linux-input-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Cl=E9ment_Vuchener?= <clement.vuchener@gmail.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 30 Sep 2015, Cl=E9ment Vuchener wrote:

> This patch implements a HID driver for the Corsair Vengeance K90 keyb=
oard.
>=20
> It fixes the behaviour of the keys using incorrect HID usage codes an=
d=20
> exposes the macro playback mode and current profile to the user space=
=20
> through sysfs attributes. It also adds two LED class devices controll=
ing=20
> the "record" LED and the backlight.
>=20
> Signed-off-by: Cl=E9ment Vuchener <clement.vuchener@gmail.com>
[ ... snip ... ]
> +struct k90_led {
> +	struct led_classdev cdev;
> +	int brightness;
> +	struct work_struct work;
> +	int removed;

This could be made bool.

Also the patch subject doesn't really follow the usual format we're usi=
ng=20
in hid.git.

Otherwise I like the code, thanks a lot for working on the driver. I ha=
ve=20
fixed the nits above and it's now queued in hid.git#for-4.4/corsair.

--=20
Jiri Kosina
SUSE Labs

--
To unsubscribe from this list: send the line "unsubscribe linux-input" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
