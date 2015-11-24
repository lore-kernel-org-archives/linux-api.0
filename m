From: "Gabriel L. Somlo" <somlo@cmu.edu>
Subject: Re: [Qemu-devel] [PATCH v5 1/4] firmware: introduce sysfs driver for
 QEMU's fw_cfg device
Date: Tue, 24 Nov 2015 13:09:53 -0500
Message-ID: <20151124180953.GB22627@HEDWIG.INI.CMU.EDU>
References: <1448294264-17388-2-git-send-email-somlo@cmu.edu>
 <201511240404.AFpczj7x%fengguang.wu@intel.com>
 <20151124165553.GA22627@HEDWIG.INI.CMU.EDU>
 <5654A08A.6030002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5654A08A.6030002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Blake <eblake@redhat.com>
Cc: kbuild test robot <lkp@intel.com>, mark.rutland@arm.com, peter.maydell@linaro.org, mst@redhat.com, stefanha@gmail.com, qemu-devel@nongnu.org, eric@anholt.net, kraxel@redhat.com, linux-api@vger.kernel.org, pawel.moll@arm.com, zajec5@gmail.com, galak@codeaurora.org, rmk+kernel@arm.linux.org.uk, lersek@redhat.com, hanjun.guo@linaro.org, devicetree@vger.kernel.org, arnd@arndb.de, ijc+devicetree@hellion.org.uk, jordan.l.justen@intel.com, agross@codeaurora.org, leif.lindholm@linaro.org, robh+dt@kernel.org, ard.biesheuvel@linaro.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, luto@amacapital.net, kbuild-all@01.org, sudeep.holla@arm.com, pbonzini@redhat.com, revol@free.fr
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 10:38:18AM -0700, Eric Blake wrote:
> On 11/24/2015 09:55 AM, Gabriel L. Somlo wrote:
> > On Tue, Nov 24, 2015 at 04:14:50AM +0800, kbuild test robot wrote:
> 
> >>
> >>    drivers/firmware/qemu_fw_cfg.c: In function 'fw_cfg_cmdline_set':
> >>>> drivers/firmware/qemu_fw_cfg.c:510:7: warning: format '%lli' expects argument of type 'long long int *', but argument 3 has type 'phys_addr_t *' [-Wformat=]
> >>           &ctrl_off, &data_off, &consumed);
> >>           ^
> > 
> > Oh, I think I know why this happened:
> > 
> 
> > 
> > So, I could use u64 instead of phys_addr_t and resource_size_t, and
> > keep "%lli" (or "%Li"), but then I'd have to check if the parsed value
> 
> %Li is not POSIX.  Don't use it (stick with %lli).
> 
> > would overflow a 32-bit address value on arches where phys_addr_t is
> > u32, which would make things a bit more messy and awkward.
> > 
> > I'm planning on #ifdef-ing the format string instead:
> > 
> > #ifdef CONFIG_PHYS_ADDR_T_64BIT
> > #define PH_ADDR_SCAN_FMT "@%Li%n:%Li:%Li%n"
> > #else
> > #define PH_ADDR_SCAN_FMT "@%li%n:%li:%li%n"
> > #endif
> 
> A more typical approach is akin to <inttypes.h>; have PH_ADDR_FMT
> defined to either "lli" or "li", then write sscanf(str, "@%"PH_ADDR_FMT
> "%n:..., ...), using PH_ADDR_FMT multiple times.

That sounds almost like it should be a separate patch against
include/linux/types.h:

diff --git a/include/linux/types.h b/include/linux/types.h
index 70d8500..35be16e 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -160,8 +160,10 @@ typedef unsigned __bitwise__ oom_flags_t;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;
+#define __PHYS_ADDR_PREFIX "ll"
 #else
 typedef u32 phys_addr_t;
+#define __PHYS_ADDR_PREFIX "l"
 #endif
 
 typedef phys_addr_t resource_size_t;

But whether it's a good idea for me to detour from fw_cfg/sysfs into
sorting this out with the kernel community right now, I don't know :)

I'll just try to do it inside the fw_cfg sysfs driver for now, see how
that goes...

> 
> > ...
> >         processed = sscanf(str, PH_ADDR_SCAN_FMT,
> >                            &base, &consumed,
> >                            &ctrl_off, &data_off, &consumed);
> 
> Umm, why are you passing &consumed to more than one sscanf() %?  That's
> (probably) undefined behavior.

Input might end after reading 'base', in which case %n would store the
next character's index in consumed, and evaluate (but otherwise
ignore) the remaining pointer arguments (including the second &consumed).

Or, it might end after reading data_off, then the earlier value of
consumed gets overwritten with the new (past data_off) index. I get to
verify that str[index] is '\0', i.e. that there were no left-over,
unprocessed characters, whether I got one or three items processed by
scanf.

I don't think passing '&consumed' in twice is a problem. I also didn't
cleverly come up with this myself, but rather lifted it from
drivers/virtio/virtio_mmio.c, so at least there's precedent :)

> [In general, sscanf() is a horrid interface to use for parsing integers
> - it has undefined behavior if the input text would trigger integer
> overflow, making it safe to use ONLY on text that you control and can
> guarantee won't overflow. By the time you've figured out if untrusted
> text meets the requirement for safe parsing via sscanf(), you've
> practically already parsed it via safer strtol() and friends.]

Just like (I think) is the case with virtio_mmio, this is an optional
feature to allow specifying a base address, range, and register
offsets for fw_cfg via the insmod (or modprobe) command line, so one
would already have to be root. Also, perfectly well-formated base and
size values could be used to hose the system, which is why virtio_mmio
(and also fw_cfg) leave this feature off by default, and recommend
caution before one would turn it on.

Thanks much,
--Gabriel
