From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v8 1/4] firmware: introduce sysfs driver for QEMU's
 fw_cfg device
Date: Mon, 22 Feb 2016 15:26:23 -0500
Message-ID: <20160222202623.GI16357@HEDWIG.INI.CMU.EDU>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
 <1453990994-17801-2-git-send-email-somlo@cmu.edu>
 <20160221100557-mutt-send-email-mst@redhat.com>
 <20160221130614.GA4511@GLSMBP.INI.CMU.EDU>
 <20160222220756-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160222220756-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ehabkost-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 22, 2016 at 10:14:50PM +0200, Michael S. Tsirkin wrote:
> On Sun, Feb 21, 2016 at 08:06:17AM -0500, Gabriel L. Somlo wrote:
> > > > +static void fw_cfg_io_cleanup(void)
> > > > +{
> > > > +	if (fw_cfg_is_mmio) {
> > > > +		iounmap(fw_cfg_dev_base);
> > > > +		release_mem_region(fw_cfg_p_base, fw_cfg_p_size);
> > > > +	} else {
> > > > +		ioport_unmap(fw_cfg_dev_base);
> > > > +		release_region(fw_cfg_p_base, fw_cfg_p_size);
> > > > +	}
> > > > +}
> > > > +
> > > > +/* arch-specific ctrl & data register offsets are not available in ACPI, DT */
> > > 
> > > So for all arches which support ACPI, I think this driver
> > > should just rely on ACPI.
> > 
> > There was a discussion about that a few versions ago, and IIRC the
> > conclusion was not to expect the firmware to contend for fw_cfg access
> > after the guest kernel boots:
> > 
> > https://lkml.org/lkml/2015/10/5/283
> > 
> 
> So it looks like NVDIMM at least wants to pass label data to guest -
> for which fw cfg might be a reasonable choice.
> 
> I suspect things changed - fw cfg used to be very slow but we now have
> DMA interface which makes it useful for a range of applications.
> 
> > (I even had a prototype version doing what you suggested, but per the above
> > reference decided to drop it -- which IMHO is for the better, since otherwise
> > I'd have had to ifdef between ACPI and non-ACPI versions of the driver --
> > see https://lkml.org/lkml/2015/11/4/534 )
> 
> I'm not sure why you have these ifdefs - they are on the host, are they
> not?

Think of those as "pseudocode" ifdefs, they're there to distinguish
between AML that would be generated on MMIO vs. IOPORT systems
(specifically, arm vs. x86, respectively)

Some of the AML is the same, but obviously the _CRS, and
OperationRegion + Field are different, and I wanted to point that out
somehow :)

Cheers,
--Gabriel
