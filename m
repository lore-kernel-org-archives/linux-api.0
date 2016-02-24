From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v8 1/4] firmware: introduce sysfs driver for QEMU's
 fw_cfg device
Date: Tue, 23 Feb 2016 19:03:13 -0500
Message-ID: <20160224000313.GO16357@HEDWIG.INI.CMU.EDU>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
 <1453990994-17801-2-git-send-email-somlo@cmu.edu>
 <20160221100557-mutt-send-email-mst@redhat.com>
 <20160221130614.GA4511@GLSMBP.INI.CMU.EDU>
 <20160222220756-mutt-send-email-mst@redhat.com>
 <20160222202623.GI16357@HEDWIG.INI.CMU.EDU>
 <20160223070541-mutt-send-email-mst@redhat.com>
 <20160223134700.GL16357@HEDWIG.INI.CMU.EDU>
 <20160223160555-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160223160555-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ehabkost-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 23, 2016 at 04:14:46PM +0200, Michael S. Tsirkin wrote:
> On Tue, Feb 23, 2016 at 08:47:00AM -0500, Gabriel L. Somlo wrote:
> > On Tue, Feb 23, 2016 at 07:07:36AM +0200, Michael S. Tsirkin wrote:
> > > On Mon, Feb 22, 2016 at 03:26:23PM -0500, Gabriel L. Somlo wrote:
> > > > On Mon, Feb 22, 2016 at 10:14:50PM +0200, Michael S. Tsirkin wrote:
> > > > > On Sun, Feb 21, 2016 at 08:06:17AM -0500, Gabriel L. Somlo wrote:
> > > > > > > > +static void fw_cfg_io_cleanup(void)
> > > > > > > > +{
> > > > > > > > +	if (fw_cfg_is_mmio) {
> > > > > > > > +		iounmap(fw_cfg_dev_base);
> > > > > > > > +		release_mem_region(fw_cfg_p_base, fw_cfg_p_size);
> > > > > > > > +	} else {
> > > > > > > > +		ioport_unmap(fw_cfg_dev_base);
> > > > > > > > +		release_region(fw_cfg_p_base, fw_cfg_p_size);
> > > > > > > > +	}
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +/* arch-specific ctrl & data register offsets are not available in ACPI, DT */
> > > > > > > 
> > > > > > > So for all arches which support ACPI, I think this driver
> > > > > > > should just rely on ACPI.
> > > > > > 
> > > > > > There was a discussion about that a few versions ago, and IIRC the
> > > > > > conclusion was not to expect the firmware to contend for fw_cfg access
> > > > > > after the guest kernel boots:
> > > > > > 
> > > > > > https://lkml.org/lkml/2015/10/5/283
> > > > > > 
> > > > > 
> > > > > So it looks like NVDIMM at least wants to pass label data to guest -
> > > > > for which fw cfg might be a reasonable choice.
> > > > > 
> > > > > I suspect things changed - fw cfg used to be very slow but we now have
> > > > > DMA interface which makes it useful for a range of applications.
> > > 
> > > Comment on this? I'm really worried we'll release linux
> > > without a way to access fw cfg from aml.
> > > How about taking acpi lock around all accesses?
> > 
> > You mean something like this (haven't tried compiling it yet, so it
> > might be a bit more complicated, but just for the purpose of this
> > conversation):
> > 
> > diff --git a/drivers/firmware/qemu_fw_cfg.c
> > b/drivers/firmware/qemu_fw_cfg.c
> > index fedbff5..3462a2c 100644
> > --- a/drivers/firmware/qemu_fw_cfg.c
> > +++ b/drivers/firmware/qemu_fw_cfg.c
> > @@ -77,12 +77,18 @@ static inline u16 fw_cfg_sel_endianness(u16 key)
> >  static inline void fw_cfg_read_blob(u16 key,
> >                                     void *buf, loff_t pos, size_t
> > count)
> >  {
> > +#ifdef CONFIG_ACPI
> > +       acpi_os_acquire_mutex(acpi_gbl_osi_mutex, ACPI_WAIT_FOREVER);
> > +#endif
> >         mutex_lock(&fw_cfg_dev_lock);
> >         iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
> >         while (pos-- > 0)
> >                 ioread8(fw_cfg_reg_data);
> >         ioread8_rep(fw_cfg_reg_data, buf, count);
> >         mutex_unlock(&fw_cfg_dev_lock);
> > +#ifdef CONFIG_ACPI
> > +       acpi_os_release_mutex(acpi_gbl_osi_mutex);
> > +#endif
> >  }
> >  
> >  /* clean up fw_cfg device i/o */
> 
> Fundamentally yes.
> 
> > I wouldn't particularly *mind* doing that, but I'd still like to hear
> > from other QEMU devs on whether it's really necessary.
> 
> It seems like a prudent thing to do IMHO, before this
> goes out to users.
> 
> [...]
> 
> On balance, I think locking ACPI solves most problems so
> if we just do that, I think what you did here is fine.

Only trouble is, acpi_gbl_osi_mutex seems to be "private" to the acpi
subsystem, and I'm not sure how well a patch to allow some random
module to lock/unlock ACPI at its convenience would be received...

So unless I'm missing something obvious (wouldn't be the first time),
I think we're back to where *if* we *have* to do this [*], providing an
AML blob-reader method in ACPI and punting to it from the guest-side
kernel module (via #ifdef CONFIG_ACPI) would be the less painful
alternative.

[*] that is, mutual exclusion between kernel and firmware regarding
    fw_cfg is (back) on the table, for real this time...

It would be good to know that it's the new consensus among QEMU
folks, since I have a strong feeling I'd no longer be "Keeping It Simple"
by moving in this direction.

Thanks,
--Gabriel
