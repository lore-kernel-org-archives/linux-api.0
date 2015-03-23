From: jake42 <jake42-9fM0UEq+jfAy41eOTT4XPcSSVFg4/55HhC4ANOJQIlc@public.gmane.org>
Subject: Re: [Gta04-owner] [PATCH 08/14] =?UTF-8?Q?twl=34=30=33=30=5Fcharg?=
 =?UTF-8?Q?er=3A=20allow=20max=5Fcurrent=20to=20be=20managed=20via=20sysfs?=
 =?UTF-8?Q?=2E?=
Date: Mon, 23 Mar 2015 13:14:50 +0100
Message-ID: <a05a88a7a3ea4519ada7216ab5bfe097@rommel.stw.uni-erlangen.de>
References: <20150322231635.23789.70149.stgit@notabene.brown>
 <20150322232029.23789.13768.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150322232029.23789.13768.stgit-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, inux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, List for communicating with real GTA04 owners <gta04-owner-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Neil,

some suggestions:

On 23.03.2015 00:20, NeilBrown wrote:
> From: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
> diff --git a/Documentation/ABI/testing/sysfs-class-power-twl4030
> b/Documentation/ABI/testing/sysfs-class-power-twl4030
> new file mode 100644
> index 000000000000..06092209d851
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-power-twl4030
> @@ -0,0 +1,15 @@
> +What: /sys/class/power_supply/twl4030_ac/max_current
> +      /sys/class/power_supply/twl4030_usb/max_current
> +Description:
> +	Read/Write limit on current which which may
one less which                        ^^
> +	be drawn from the ac (Accessory Charger) or
> +	USB port.
> +
> +	Value is in micro-Amps.
> +
> +	Value is set automatically to an appropriate
> +	value when a cable is plugged on unplugged.
s/on/or                               ^^
> +
> +	Value can the set by writing to the attribute.
                   ^^ be set?
> +	The change will only persist until the next
> +	plug event.  These event are reported via udev.

Regards
Jake
