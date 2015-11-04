From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v3 0/4] SysFS driver for QEMU fw_cfg device
Date: Wed, 4 Nov 2015 15:48:11 -0500
Message-ID: <20151104204811.GB4505@HEDWIG.INI.CMU.EDU>
References: <1443914889-9619-1-git-send-email-somlo@cmu.edu>
 <20151005100035.GA19064@leverpostej>
 <20151005124042.GF1977@HEDWIG.INI.CMU.EDU>
 <CAFEAcA9qVSsmPW_s3wRSBykGYWU-2PS2ZNCagnoe0FGCg8mqzQ@mail.gmail.com>
 <5612788D.2090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5612788D.2090504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Maydell <peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, paul-DWxLp4Yu+b8AvxtiuMwx3w@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml - Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernelnewbies-7JyXY6prKcjpASu1u0TL5ti2O/JbrIOy@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jordan Justen <jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, QEMU Developers <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 05, 2015 at 03:18:05PM +0200, Paolo Bonzini wrote:
> 
> 
> On 05/10/2015 14:50, Peter Maydell wrote:
> > If you want to try to support "firmware might also be reading
> > fw_cfg at the same time as the kernel" this is a (painful)
> > problem regardless of how the kernel figures out whether a
> > fw_cfg device is present. I had assumed that one of the design
> > assumptions of this series was that firmware would only
> > read the fw_cfg before booting the guest kernel and never touch
> > it afterwards. If it might touch it later then letting the
> > guest kernel also mess with fw_cfg seems like a really bad idea.
> 
> The idea of tinkering with fw_cfg from the AML code (DSDT/SSDT) has been
> proposed many times, and always dropped.  One of the reasons was that
> the OS could have a driver for fw_cfg.
> 
> So I think that we can define the QEMU0002 id as owned by the OSPM,
> similar to the various standard ACPI ids that are usually found in the
> x86 world (e.g. PNP0B00 is a mc146818 RTC, PNP0303 is an 8042 keyboard
> controller, PNP0501 is a 16550 or similar UART, and so on).  This
> basically sanctions _CRS as the way to pass information from the
> firmware to the OSPM, also similarly to those standard PNP ids.

OK, so I don't expect to go the "pure ACPI" route in the final
version, mainly because I'm still hoping to fill the requirement
of writing a driver which can use either ACPI or DT to detect the
presence of fw_cfg (how I'm going to compile this on kernels with
no ACPI or no DT support is still TBD, and probably will have to
involve #ifdef, but I digress :)

However, Michael's idea of having ACPI supply an "accessor method" for
the guest kernel driver to call, without having to worry about the
specific details in _CRS, sounded intriguing enough to at least explore
in further detail.

So, assuming we have the following fw_cfg AML in ssdt (i386) or
dsdt (arm) (using cpp-style #ifdef to highlight the arch-specific
bits):

Scope (\_SB)
{
    Device (FWCF)
    {
        Name (_HID, EisaId ("QMU0002"))  // _HID: Hardware ID
        Name (_STA, 0x0B)  // _STA: Status

#ifdef ARCH_X86

        Name (_CRS, ResourceTemplate ()
        {
            IO (Decode16,
                0x0510,             // Range Minimum
                0x0510,             // Range Maximum
                0x01,               // Alignment
                0x02,               // Length
                )
        })

#else /* ARCH_ARM */

        NAME (_CRS, ResourceTemplate ()
        {
            Memory32Fixed (ReadWrite,
                           0x09020000,  // Address Base
                           0x0000000a,  // Address Length
                          )
        })

#endif

    }
}

I can easily patch QEMU to additionally insert the following into
"Device (FWCF)":

#ifdef ARCH_X86

        OperationRegion (FWCR, SystemIO, 0x0510, 0x02)
        Field (FWCR, WordAcc, NoLock, Preserve)
        {
            FWCC,   16
        }
        Field (FWCR, ByteAcc, NoLock, Preserve)
        {
            Offset (0x01),
            FWCD,   8
        }

#else /* ARCH_ARM */

        OperationRegion (FWCR, SystemMemory, 0x09020000, 0x0a)
        Field (FWCR, WordAcc, NoLock, Preserve)
        {
            Offset (0x08),
            FWCC,   16  // not sure about endianness on ARM here, but
                        // I can still address this from the userspace
                        // kernel driver if needed
        }
        Field (FWCR, ByteAcc, NoLock, Preserve)
        {
            FWCD,   8
        }

#endif

        Method (RDBL, 3, Serialized) // (Arg0 = key, Arg1 = skip, Arg2 = count)
        {
            FWCC = Arg0
            Local0 = Zero
            While ((Local0 < Arg1))
            {
                Local1 = FWCD
                Local0++
            }
            Name (BBUF, Buffer (Arg2) {})
            Local0 = Zero
            While ((Local0 < Arg2))
            {
                Index (BBUF, Local0) = FWCD /* \_SB_.FWCF.FWCD */
                Local0++
            }
            Return (BBUF) /* \_SB_.FWCF.RDBL.BBUF */
        }

With the host generating the additional RDBL method above, I could
write a "pure ACPI" driver for the guest kernel, where instead of the
current fw_cfg_read_blob() logic:


  static DEFINE_MUTEX(fw_cfg_dev_lock);
  static bool fw_cfg_is_mmio;

  static inline u16 fw_cfg_sel_endianness(u16 key)
  {
          return fw_cfg_is_mmio ? cpu_to_be16(key) : cpu_to_le16(key);
  }

  static inline void fw_cfg_read_blob(u16 key,
                                      void *buf, loff_t pos, size_t count)
  {
          mutex_lock(&fw_cfg_dev_lock);
          iowrite16(fw_cfg_sel_endianness(key), fw_cfg_reg_ctrl);
          while (pos-- > 0)
                  ioread8(fw_cfg_reg_data);
          ioread8_rep(fw_cfg_reg_data, buf, count);
          mutex_unlock(&fw_cfg_dev_lock);
  }


I could instead write something like this:


  struct acpi_device *dev;    /* set during module init.  */

  static inline void fw_cfg_read_blob(u16 key,
                                      void *buf, loff_t pos, size_t count)
  {
          union acpi_object arg_elem[3], *obj;
          struct acpi_object_list arg;
          struct acpi_buffer acpi_buf = { ACPI_ALLOCATE_BUFFER, NULL };
          acpi_status status;

          arg.count = 3;
          arg.pointer = &arg_elem[0];

          arg_elem[0].type =
          arg_elem[1].type =
          arg_elem[2].type = ACPI_TYPE_INTEGER;

          arg_elem[0].integer.value = key;
          arg_elem[1].integer.value = pos;
          arg_elem[2].integer.value = count;

          status = acpi_evaluate_object_typed(dev->handle, "RDBL", &arg,
                                              &acpi_buf, ACPI_TYPE_BUFFER);
          if (ACPI_FAILURE(status)) {
              return; /* FIXME: actual error signaling to caller TBD */
          }
 
          obj = (union acpi_object *)acpi_buf.pointer;

          /* FIXME: in lieu of better error signaling to caller: */
          assert(count == obj->buffer.length);

          memcpy(buf, obj->buffer.pointer, obj->buffer.length);
          kfree(acpi_buf.pointer);
  }

Now, if ACPI-less DT-enabled architectures are to be supported, this
wouldn't get me out of having to spell out the original ioread8_rep()
based fw_cfg_read_blob(), so probably not worth doing.

But I simply *had* to try and chase this down before writing it off,
since part of the reason I'm doing all this in the first place is to
teach myself new tricks... :)

Sorry for going off on a somewhat lengthy (and maybe just a *little*
bit off-topic) tangent, but I figured I'd put it out there to at least
facilitate future archaeology :)

Obviously, any comments or feedback much appreciated!

Cheers,
--Gabriel
