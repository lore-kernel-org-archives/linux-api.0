From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/5] usb: phy: twl4030: make runtime pm more reliable.
Date: Thu, 26 Mar 2015 07:39:50 +0100
Message-ID: <20150326063950.GA755@amd>
References: <20150322223307.21765.62974.stgit@notabene.brown>
 <20150322223523.21765.3199.stgit@notabene.brown>
 <55132965.3090002@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55132965.3090002@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: NeilBrown <neil@brown.name>, Tony Lindgren <tony@atomide.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, NeilBrown <neilb@suse.de>
List-Id: linux-api@vger.kernel.org

> > diff --git a/drivers/phy/phy-twl4030-usb.c
    b/drivers/phy/phy-twl4030-usb.c
> > index 8e87f54671f3..1a244f34b748 100644
> > --- a/drivers/phy/phy-twl4030-usb.c
> > +++ b/drivers/phy/phy-twl4030-usb.c
> > @@ -144,6 +144,16 @@
> >  #define PMBR1				0x0D
> >  #define GPIO_USB_4PIN_ULPI_2430C	(3 << 0)
> >  
> > +/*
> > + * If VBUS is valid or ID is ground, then we know a
> > + * cable is present and we need to be runtime-enabled
> > + */
> > +static inline bool cable_present(enum omap_musb_vbus_id_status stat)
> 
> twl4030_cable_present?

It is static function, no need for prefixes, they just make code
harder to read.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
