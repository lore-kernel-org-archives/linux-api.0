From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH v10 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Fri, 30 Jan 2015 14:08:54 +0000
Message-ID: <20150130140854.GJ26493@n2100.arm.linux.org.uk>
References: <sc9836-serial-v10>
 <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1422443324-25082-3-git-send-email-chunyan.zhang@spreadtrum.com>
 <54CA5128.8050500@gmail.com>
 <54CA568E.6080306@hurleysoftware.com>
 <20150129160553.GC26493@n2100.arm.linux.org.uk>
 <20150130101838.GC16744@ulmo>
 <54CB72F7.8060706@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54CB72F7.8060706-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Cc: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Varka Bhadram <varkabhadram-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, florian.vaussard-p8DiymsW2f8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, wei.qiao-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 30, 2015 at 07:03:03AM -0500, Peter Hurley wrote:
> On 01/30/2015 05:18 AM, Thierry Reding wrote:
> > -ENODEV is certainly not the correct return value if a resource is not
> > available. It translates to "no such device", but the device must
> > clearly be there, otherwise the ->probe() shouldn't have been called.
> 
> -ENODEV is the appropriate return from the probe(); there is no device.

No it is not.  "no such device" means "the device is not present".  If
the device is not present, we wouldn't have a struct device associated
with it.

The missing resource is an error condition: what it's saying is that the
device is there, but something has failed in providing the IO regions
necessary to access it.  That's really something very different from
"there is no device present".

> > Or if it really isn't there, then you'd at least need a memory region
> > to probe, otherwise you can't determine whether it's there or not. So
> > from the perspective of a device driver I think a missing, or NULL,
> > resource, is indeed an "invalid argument".
> 
> Trying to argue that a missing host bus window is an "invalid argument"
> to probe() is just trying to make the shoe fit.

As is arguing that -ENODEV is an appropriate return value for the missing
resource.

Moreover, returning -ENODEV is actually *bad* in this case - the kernel's
generic probe handling does not report the failure of the driver to bind
given this, so a missing resource potentially becomes a silent failure of
a driver - leading users to wonder why their devices aren't found.

If we /really/ have a problem with the error code, then why not invent
a new error code to cater for this condition - maybe, EBADRES (bad resource).

> > I understand that people might see some ambiguity there, and -EINVAL is
> > certainly not a very accurate description, but such is the nature of
> > error codes. You pick what fits best. -ENXIO and -EADDRNOTAVAIL had been
> > under discussion as well if I remember correctly, but they both equally
> > ambiguous. -ENODATA might have been a better fit, but that too has a
> > different meaning in other contexts.
> > 
> > Besides, there's an error message that goes along with the error code
> > return, that should remove any ambiguity for people looking at dmesg.
> > 
> > All of that said, the original assertion that the check is not required
> > is still valid. We can argue at length about the specific error code but
> > if we decide that it needs to change, then we should modify
> > devm_ioremap_resource() rather than requiring all callers to perform the
> > extra check again.
> 
> None of the devm_ioremap_resource() changes have been submitted for
> serial drivers.

$ grep devm_ioremap_resource drivers/tty/serial/ -r | wc -l
10

It seems that statement is false.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
