From: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Subject: Re: [PATCH v10 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Fri, 30 Jan 2015 15:49:26 +0000
Message-ID: <20150130154926.GN26493@n2100.arm.linux.org.uk>
References: <sc9836-serial-v10>
 <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1422443324-25082-3-git-send-email-chunyan.zhang@spreadtrum.com>
 <54CA5128.8050500@gmail.com>
 <54CA568E.6080306@hurleysoftware.com>
 <20150129160553.GC26493@n2100.arm.linux.org.uk>
 <20150130101838.GC16744@ulmo>
 <54CB72F7.8060706@hurleysoftware.com>
 <20150130140854.GJ26493@n2100.arm.linux.org.uk>
 <54CBA426.7050900@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54CBA426.7050900-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Cc: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Varka Bhadram <varkabhadram-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, florian.vaussard-p8DiymsW2f8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, wei.qiao-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 30, 2015 at 10:32:54AM -0500, Peter Hurley wrote:
> Before you say consistency, I think you should look at the stats below.
> IOW, if you want to change the error code return from probe() for
> consistency's sake, a tree-wide patch would be the appropriate way.

Now look outside the serial driver sub-tree.

There are 1234 instances of platform_get_resource(, IORESOURCE_MEM, ) in
the drivers/ sub-tree, with 700 instances of devm_ioremap_resource()
being used there.  Of the devm_ioremap_resource() instances:

- 555 use platform_get_resource() in the preceding two lines - which is
  not enough to do anything but rely on the -EINVAL return value.
- 16 mention ENODEV in the preceding three lines.

There are 132 which use platform_get_resource() and return ENODEV within
the following three lines (which may intersect with the above 16 number)
and 88 which use EINVAL.

So, there are in total 643 instances where a missing resource returns
EINVAL, and between 132 and 148 instances which return ENODEV.

Yes, 643 + 148 isn't 1234, but I'm not going to read through all 1234
locations just for the sake of this thread.   What's clear though is that
more than 50% of sites using platform_get_resource(, IORESOURCE_MEM, )
return EINVAL for the lack of a resource.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
