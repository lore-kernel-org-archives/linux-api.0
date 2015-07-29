From: NeilBrown <neil@brown.name>
Subject: Re: [Gta04-owner] [PATCH 08/14] twl4030_charger: allow max_current
 to be managed via sysfs.
Date: Thu, 30 Jul 2015 08:10:46 +1000
Message-ID: <20150730081046.027ba82e@home.neil.brown.name>
References: <20150322231635.23789.70149.stgit@notabene.brown>
	<20150322232029.23789.13768.stgit@notabene.brown>
	<a05a88a7a3ea4519ada7216ab5bfe097@rommel.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a05a88a7a3ea4519ada7216ab5bfe097@rommel.stw.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
To: jake42 <jake42@rommel.stw.uni-erlangen.de>
Cc: Sebastian Reichel <sre@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, inux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>, List for communicating with real GTA04 owners <gta04-owner@goldelico.com>
List-Id: linux-api@vger.kernel.org

On Mon, 23 Mar 2015 13:14:50 +0100 jake42
<jake42@rommel.stw.uni-erlangen.de> wrote:

> Hello Neil,
> 
> some suggestions:
> 
> On 23.03.2015 00:20, NeilBrown wrote:
> > From: NeilBrown <neilb@suse.de>
> > diff --git a/Documentation/ABI/testing/sysfs-class-power-twl4030
> > b/Documentation/ABI/testing/sysfs-class-power-twl4030
> > new file mode 100644
> > index 000000000000..06092209d851
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-class-power-twl4030
> > @@ -0,0 +1,15 @@
> > +What: /sys/class/power_supply/twl4030_ac/max_current
> > +      /sys/class/power_supply/twl4030_usb/max_current
> > +Description:
> > +	Read/Write limit on current which which may
> one less which                        ^^
> > +	be drawn from the ac (Accessory Charger) or
> > +	USB port.
> > +
> > +	Value is in micro-Amps.
> > +
> > +	Value is set automatically to an appropriate
> > +	value when a cable is plugged on unplugged.
> s/on/or                               ^^
> > +
> > +	Value can the set by writing to the attribute.
>                    ^^ be set?
> > +	The change will only persist until the next
> > +	plug event.  These event are reported via udev.
> 
> Regards
> Jake
> 

Thanks.
I've made those two changes.

NeilBrown
