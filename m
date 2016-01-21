From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] drm: etnaviv: add further minor features and
 varyings count
Date: Thu, 21 Jan 2016 11:45:41 +0000
Message-ID: <20160121114541.GW19062@n2100.arm.linux.org.uk>
References: <E1aLSQq-0006sU-Ou@rmk-PC.arm.linux.org.uk>
 <1453367790.3183.14.camel@pengutronix.de>
 <CAH9NwWc7vp3C5Ww7LzQ0p6pWxk-ZefV0bW-YbMSdnoTXDr0Tkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH9NwWc7vp3C5Ww7LzQ0p6pWxk-ZefV0bW-YbMSdnoTXDr0Tkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Gmeiner <christian.gmeiner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Lucas Stach <l.stach-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, DRI mailing list <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 21, 2016 at 12:34:16PM +0100, Christian Gmeiner wrote:
> Hi Lucas,
> 
> 2016-01-21 10:16 GMT+01:00 Lucas Stach <l.stach-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>:
> > Am Dienstag, den 19.01.2016, 09:18 +0000 schrieb Russell King:
> >> Export further minor feature bitmasks and the varyings count from
> >> the GPU specifications registers to userspace.
> >>
> >> Signed-off-by: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> >
> > I guess you have MESA changes that depend on this patch, right? In that
> > case I'll fast-track this into 4.5.
> >
> 
> That would be great if we can get both patches this into 4.5.

Let me resend before these get committed...

-- 
RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
