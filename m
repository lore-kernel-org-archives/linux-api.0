From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v8 1/4] firmware: introduce sysfs driver
 for QEMU's fw_cfg device
Date: Tue, 23 Feb 2016 16:14:46 +0200
Message-ID: <20160223160555-mutt-send-email-mst@redhat.com>
References: <1453990994-17801-1-git-send-email-somlo@cmu.edu>
	<1453990994-17801-2-git-send-email-somlo@cmu.edu>
	<20160221100557-mutt-send-email-mst@redhat.com>
	<20160221130614.GA4511@GLSMBP.INI.CMU.EDU>
	<20160222220756-mutt-send-email-mst@redhat.com>
	<20160222202623.GI16357@HEDWIG.INI.CMU.EDU>
	<20160223070541-mutt-send-email-mst@redhat.com>
	<20160223134700.GL16357@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
In-Reply-To: <20160223134700.GL16357@HEDWIG.INI.CMU.EDU>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, matt@codeblueprint.co.uk, stefanha@gmail.com, qemu-devel@nongnu.org, eric@anholt.net, kraxel@redhat.com, linux-api@vger.kernel.org, agross@codeaurora.org, pawel.moll@arm.com, zajec5@gmail.com, rmk+kernel@arm.linux.org.uk, lersek@redhat.com, devicetree@vger.kernel.org, ehabkost@redhat.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, leif.lindholm@linaro.org, robh+dt@kernel.org, pbonzini@redhat.com, rth@twiddle.net, ard.biesheuvel@linaro.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, luto@amacapital.net, hanjun.guo@linaro.org, sudeep.holla@arm.com, imammedo@redhat.com, revol@free.fr
List-Id: linux-api@vger.kernel.org

On Tue, Feb 23, 2016 at 08:47:00AM -0500, Gabriel L. Somlo wrote:
> On Tue, Feb 23, 2016 at 07:07:36AM +0200, Michael S. Tsirkin wrote:
> > On Mon, Feb 22, 2016 at 03:26:23PM -0500, Gabriel L. Somlo wrote:
> > > On Mon, Feb 22, 2016 at 10:14:50PM +0200, Michael S. Tsirkin wrote:
> > > > On Sun, Feb 21, 2016 at 08:06:17AM -0500, Gabriel L. Somlo wrote:
> > > > > > > +static void fw_cfg_io_cleanup(void)
> > > > > > > +{
> > > > > > > +	if (fw_cfg_is_mmio) {
> > > > > > > +		iounmap(fw_cfg_dev_base);
> > > > > > > +		release_mem_region(fw_cfg_p_base, fw_cfg_p_size);
> > > > > > > +	} else {
> > > > > > > +		ioport_unmap(fw_cfg_dev_base);
> > > > > > > +		release_region(fw_cfg_p_base, fw_cfg_p_size);
> > > > > > > +	}
> > > > > > > +}
> > > > > > > +
> > > > > > > +/* arch-specific ctrl & data register offsets are not available in ACPI, DT */
> > > > > > 
> > > > > > So for all arches which support ACPI, I think this driver
> > > > > > should just rely on ACPI.
> > > > > 
> > > > > There was a discussion about that a few versions ago, and IIRC the
> > > > > conclusion was not to expect the firmware to contend for fw_cfg access
> > > > > after the guest kernel boots:
> > > > > 
> > > > > https://lkml.org/lkml/2015/10/5/283
> > > > > 
> > > > 
> > > > So it looks like NVDIMM at least wants to pass label data to guest -
> > > > for which fw cfg might be a reasonable choice.
> > > > 
> > > > I suspect things changed - fw cfg used to be very slow but we now have
> > > > DMA interface which makes it useful for a range of applications.
> > 
> > Comment on this? I'm really worried we'll release linux
> > without a way to access fw cfg from aml.
> > How about taking acpi lock around all accesses?
> 
> You mean something like this (haven't tried compiling it yet, so it
> might be a bit more complicated, but just for the purpose of this
> conversation):
> 
> diff --git a/drivers/firmware/qemu_fw_cfg.c
> b/drivers/firmware/qemu_fw_cfg.c
> index fedbff5..3462a2c 100644
> --- a/drivers/firmware/qemu_fw_cfg.c
> +++ b/drivers/firmware/qemu_fw_cfg.c
> @@ -77,12 +77,18 @@ static inline u16 fw_cfg_sel_endianness(u16 key)
>  static inline void fw_cfg_read_blob(u16 key,
>                                     void *buf, loff_t pos, size_t
> count)
>  {
> +#ifdef CONFIG_ACPI
> +       acpi_os_acquire_mutex(acpi_gbl_osi_mutex, ACPI_WAIT_FOREVER);
> +#endif
>         mutex_lock(&fw_cfg_dev_lock);
>         iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
>         while (pos-- > 0)
>                 ioread8(fw_cfg_reg_data);
>         ioread8_rep(fw_cfg_reg_data, buf, count);
>         mutex_unlock(&fw_cfg_dev_lock);
> +#ifdef CONFIG_ACPI
> +       acpi_os_release_mutex(acpi_gbl_osi_mutex);
> +#endif
>  }
>  
>  /* clean up fw_cfg device i/o */

Fundamentally yes.

> I wouldn't particularly *mind* doing that, but I'd still like to hear
> from other QEMU devs on whether it's really necessary.

It seems like a prudent thing to do IMHO, before this
goes out to users.

> > > > > (I even had a prototype version doing what you suggested, but per the above
> > > > > reference decided to drop it -- which IMHO is for the better, since otherwise
> > > > > I'd have had to ifdef between ACPI and non-ACPI versions of the driver --
> > > > > see https://lkml.org/lkml/2015/11/4/534 )
> > > > 
> > > > I'm not sure why you have these ifdefs - they are on the host, are they
> > > > not?
> > > 
> > > Think of those as "pseudocode" ifdefs, they're there to distinguish
> > > between AML that would be generated on MMIO vs. IOPORT systems
> > > (specifically, arm vs. x86, respectively)
> > > 
> > > Some of the AML is the same, but obviously the _CRS, and
> > > OperationRegion + Field are different, and I wanted to point that out
> > > somehow :)
> > > 
> > > Cheers,
> > > --Gabriel
> > 
> > You can do ifs as well.
> 
> Yeah, but the AML is generated from arch-specific locations in QEMU,
> so we'd be doing MMIO-only from e.g. hw/arm/virt-acpi-build.c, and
> IOPORT-only from hw/i386/acpi-build.c, etc. I wouldnt need to write a
> generic AML blob with 'if' statements and insert it the same way on
> all architectures, or would I ? Not sure what the best practice would
> be for that :)

Just regular C, put common code in a common function.

> Speaking of AML, if we were to implement a "RDBL" (read-blob) method
> for fw_cfg in AML, and call it from the guest-side kernel module,
> we'll never be able to make it use DMA on ACPI systems. The way
> fw_cfg_read_blob is written now, we could patch that in at some later
> point. So that's an argument in favor of *at most* wrapping
> acpi_os_acquire_mutex() around the current fw_cfg_read_blob, rather
> than including an acpi-specific version implemented on top of an
> AML call.
> 
> Thanks,
> --Gabriel

On balance, I think locking ACPI solves most problems so
if we just do that, I think what you did here is fine.

-- 
MST
