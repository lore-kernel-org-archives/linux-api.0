From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v3 2/4] firmware: use acpi to detect QEMU fw_cfg device
 for sysfs fw_cfg driver
Date: Sun, 4 Oct 2015 16:27:46 -0400
Message-ID: <20151004202746.GE1977@HEDWIG.INI.CMU.EDU>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <1443914889-9619-3-git-send-email-somlo@cmu.edu>
 <20151004103555-mutt-send-email-mst@redhat.com>
 <20151004202400.GD1977@HEDWIG.INI.CMU.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151004202400.GD1977-h65ZQ0r4j6KKUezXOiBB2eW1CriLhL8O@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Oct 04, 2015 at 04:24:00PM -0400, Gabriel L. Somlo wrote:
> On Sun, Oct 04, 2015 at 10:54:57AM +0300, Michael S. Tsirkin wrote:
> > On Sat, Oct 03, 2015 at 07:28:07PM -0400, Gabriel L. Somlo wrote:
> > > 
> > > Instead of blindly probing fw_cfg registers at known IOport and MMIO
> > > locations, use the ACPI subsystem to determine whether a QEMU fw_cfg
> > > device is present, and, if found, to initialize it.
> > > 
> > > This limits portability to architectures which support ACPI (x86 and
> > > UEFI-enabled aarch64), but avoids touching hardware registers before
> > > being certain that our device is present.
> > > 
> > > NOTE: The standard way to verify the presence of fw_cfg on arm VMs
> > > would have been to use the device tree, but that would have left out
> > > x86, which is the primary architecture targeted by this patch.
> > > 
> > > Signed-off-by: Gabriel Somlo <somlo-D+Gtc/HYRWM@public.gmane.org>
> > 
> > IMHO it's not a good idea to probe registers provided
> > by CRS like this.
> > It seems quite reasonable that we'd want to add some
> > extra registers in the future, and this probing will break.
> > 
> > Further, accessing registers directly means that there's
> > no way to have ACPI code access them as that would
> > cause race conditions.
> > 
> > Maybe we should provide access methods in ACPI instead?
> 
> OK, I think I understand what you meant by "don't poke CRS" in the
> other thread...
> 
> So, you're proposing I move the follwing bits:
> 
>   /* atomic access to fw_cfg device (potentially slow i/o, so using
>    * mutex) */
>   static DEFINE_MUTEX(fw_cfg_dev_lock);
> 
>   /* pick appropriate endianness for selector key */
>   static inline u16 fw_cfg_sel_endianness(u16 key)
>   {
>           return fw_cfg_is_mmio ? cpu_to_be16(key) : cpu_to_le16(key);
>   }
> 
>   /* type for fw_cfg "directory scan" visitor/callback function */
>   typedef int (*fw_cfg_file_callback)(const struct fw_cfg_file *f);
> 
>   /* run a given callback on each fw_cfg directory entry */
>   static int fw_cfg_scan_dir(fw_cfg_file_callback callback)
>   {
>           int ret = 0;
>           u32 count, i;
>           struct fw_cfg_file f;
> 
>           mutex_lock(&fw_cfg_dev_lock);
>           iowrite16(fw_cfg_sel_endianness(FW_CFG_FILE_DIR), fw_cfg_reg_ctrl);
>           ioread8_rep(fw_cfg_reg_data, &count, sizeof(count));
>           for (i = 0; i < be32_to_cpu(count); i++) {
>                   ioread8_rep(fw_cfg_reg_data, &f, sizeof(f));
>                   ret = callback(&f);
>                   if (ret)
>                           break;
>           }
>           mutex_unlock(&fw_cfg_dev_lock);
>           return ret;
>   }
> 
>   /* read chunk of given fw_cfg blob (caller responsible for
>    * sanity-check) */
>   static inline void fw_cfg_read_blob(u16 key,
>                                       void *buf, loff_t pos, size_t count)
>   {
>           mutex_lock(&fw_cfg_dev_lock);
>           iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
>           while (pos-- > 0)
>                   ioread8(fw_cfg_reg_data);
>           ioread8_rep(fw_cfg_reg_data, buf, count);
>           mutex_unlock(&fw_cfg_dev_lock);
>   }
> 
> into the FWCF, "QEMU0002" node as an AML method ? Have ACPI provide
> mutual exclusion against competing readers, and somehow figure out how
> to call the ACPI/AML code from the guest-side kernel driver whenever
> I need to call fw_cfg_read_blob() ?
> 
> I guess I could implement fw_cfg_scan_dir() using fw_cfg_read_blob():
> 
>   u32 count;
>   size_t  bufsize;
>   void *buf;
>   fw_cfg_read_blob(FW_CFG_FILE_DIR, &count, 0, sizeof(u32));
>   bufsize = sizeof(u32) + count * sizeof(struct fw_cfg_file);
>   buf = kalloc(bufsize);
>   fw_cfg_read_blob(FW_CFG_FILE_DIR, buf, 0, bufsize);
>   ...
>   /* now read all the blob meta-data from buf ... */
> 
> It would be 100% atomic, but since we can safely assume the fw_cfg
> contents never change, it'd be OK.

I meant "wouldn't be 100% atomic", as in "it would be a case of
verify-then-use"...

Sorry,
--Gabriel

> 
> The atomicity of the ACPI version of fw_cfg_read_blob(), picking the
> right endianness for the selector, etc. would have to be done in AML
> within the QEMU host-side patch.
> 
> If you know of anything I can look at for a good ASL example, please
> point it out to me. I'm going to go away now and spend some quality
> time with the ACPI spec :)
> 
> Thanks,
> --Gabriel
