From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 13/14] twl4030_charger: Increase current carefully while
 watching voltage.
Date: Mon, 23 Mar 2015 22:25:41 +0100
Message-ID: <20150323212541.GD14779@amd>
References: <20150322231635.23789.70149.stgit@notabene.brown>
 <20150322232029.23789.30185.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150322232029.23789.30185.stgit@notabene.brown>
Sender: linux-omap-owner@vger.kernel.org
To: NeilBrown <neil@brown.name>
Cc: Sebastian Reichel <sre@kernel.org>, NeilBrown <neilb@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org

Hi!

> The USB Battery Charging spec (BC1.2) suggests a dedicated
> charging port can deliver from 0.5 to 5.0A at between 4.75 and 5.25
> volts.
> 
> To choose the "correct" current voltage setting requires a trial
> and error approach: try to draw current and see if the voltage drops
> too low.
> 
> Even with a configured Standard Downstream Port, it may not be possible
> to reliably pull 500mA - depending on cable quality and source
> quality I have reports of charging failure due to the voltage dropping
> too low.
> 
> To address both these concerns, this patch introduce incremental
> current setting.
> The current pull from VBUS is increased in steps of 20mA every 100ms
> until the target is reached or until the measure voltage drops below
> 4.75V.  If the voltage does go too low, the target current is reduced
> by 20mA and kept there.

Still nervous. If it is possible to overheat the charger, without
tripping internal fuse, then you'll do it.

> This applies to currents selected automatically, or to values
> set via sysfs.  So setting a large value will cause the maximum
> available to be used - up to the limit of 1.7A imposed by the
> hardware.
>

> +	printk("v=%d cur=%d target=%d\n", v, bci->usb_cur,
> +	       bci->usb_cur_target);

dev_info() and a bit better message, or drop it for production?

> +	if (v < USB_MIN_VOLT) {
> +		/* Back up and stop adjusting. */
> +		bci->usb_cur -= USB_CUR_STEP;
> +		bci->usb_cur_target = bci->usb_cur;

More importantly.... how does it work with device drawing power for
operation, too?

Imagine device need 500mA with wifi hotspot, nearly nothing while idle.

Idle device. Code will find that it can charge using 1A, backs up to
0.9A. User starts hotspot. Now device will draw 1.4A, overloading the
charger and not charging at all...?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
