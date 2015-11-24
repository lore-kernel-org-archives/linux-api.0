From: "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>
Subject: Re: [PATCH v5 1/4] firmware: introduce sysfs driver for QEMU's
 fw_cfg device
Date: Tue, 24 Nov 2015 11:55:53 -0500
Message-ID: <20151124165553.GA22627@HEDWIG.INI.CMU.EDU>
References: <1448294264-17388-2-git-send-email-somlo@cmu.edu>
 <201511240404.AFpczj7x%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201511240404.AFpczj7x%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, revol-GANU6spQydw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 24, 2015 at 04:14:50AM +0800, kbuild test robot wrote:
> Hi Gabriel,
> 
> [auto build test WARNING on v4.4-rc2]
> [also build test WARNING on next-20151123]
> [cannot apply to robh/for-next]
> 
> url:    https://github.com/0day-ci/linux/commits/Gabriel-L-Somlo/SysFS-driver-for-QEMU-fw_cfg-device/20151124-000402
> config: arm-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/firmware/qemu_fw_cfg.c: In function 'fw_cfg_cmdline_set':
> >> drivers/firmware/qemu_fw_cfg.c:510:7: warning: format '%lli' expects argument of type 'long long int *', but argument 3 has type 'phys_addr_t *' [-Wformat=]
>           &ctrl_off, &data_off, &consumed);
>           ^

Oh, I think I know why this happened:

...
        phys_addr_t base;
        resource_size_t size, ctrl_off, data_off;
...
        /* get "@<base>[:<ctrl_off>:<data_off>]" chunks */
        processed = sscanf(str, "@%lli%n:%lli:%lli%n"
                           &base, &consumed,
                           &ctrl_off, &data_off, &consumed);
...

On some architectures, phys_addr_t (and resource_size_t) are u32,
rather than u64. In include/linux/types.h we have:

...
#ifdef CONFIG_PHYS_ADDR_T_64BIT
typedef u64 phys_addr_t;
#else
typedef u32 phys_addr_t;
#endif
...

So, I could use u64 instead of phys_addr_t and resource_size_t, and
keep "%lli" (or "%Li"), but then I'd have to check if the parsed value
would overflow a 32-bit address value on arches where phys_addr_t is
u32, which would make things a bit more messy and awkward.

I'm planning on #ifdef-ing the format string instead:

#ifdef CONFIG_PHYS_ADDR_T_64BIT
#define PH_ADDR_SCAN_FMT "@%Li%n:%Li:%Li%n"
#else
#define PH_ADDR_SCAN_FMT "@%li%n:%li:%li%n"
#endif
...
        processed = sscanf(str, PH_ADDR_SCAN_FMT,
                           &base, &consumed,
                           &ctrl_off, &data_off, &consumed);


This should make the warning go away, and be correct. Does that sound
like a valid plan, or is there some other stylistic reason I should
stay away from doing it that way ?

thanks,
--Gabriel

> >> drivers/firmware/qemu_fw_cfg.c:510:7: warning: format '%lli' expects argument of type 'long long int *', but argument 5 has type 'resource_size_t *' [-Wformat=]
>    drivers/firmware/qemu_fw_cfg.c:510:7: warning: format '%lli' expects argument of type 'long long int *', but argument 6 has type 'resource_size_t *' [-Wformat=]
>    drivers/firmware/qemu_fw_cfg.c: In function 'fw_cfg_cmdline_get':
> >> drivers/firmware/qemu_fw_cfg.c:563:5: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'resource_size_t' [-Wformat=]
>         fw_cfg_cmdline_dev->resource[0].start);
>         ^
>    drivers/firmware/qemu_fw_cfg.c:563:5: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 5 has type 'resource_size_t' [-Wformat=]
>    drivers/firmware/qemu_fw_cfg.c:569:5: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'resource_size_t' [-Wformat=]
>         fw_cfg_cmdline_dev->resource[2].start);
>         ^
>    drivers/firmware/qemu_fw_cfg.c:569:5: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 5 has type 'resource_size_t' [-Wformat=]
> >> drivers/firmware/qemu_fw_cfg.c:569:5: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 6 has type 'resource_size_t' [-Wformat=]
>    drivers/firmware/qemu_fw_cfg.c:569:5: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 7 has type 'resource_size_t' [-Wformat=]
> 
> vim +510 drivers/firmware/qemu_fw_cfg.c
> 
>    504		/* consume "<size>" portion of command line argument */
>    505		size = memparse(arg, &str);
>    506	
>    507		/* get "@<base>[:<ctrl_off>:<data_off>]" chunks */
>    508		processed = sscanf(str, "@%lli%n:%lli:%lli%n",
>    509				   &base, &consumed,
>  > 510				   &ctrl_off, &data_off, &consumed);
>    511	
>    512		/* sscanf() must process precisely 1 or 3 chunks:
>    513		 * <base> is mandatory, optionally followed by <ctrl_off>
>    514		 * and <data_off>;
>    515		 * there must be no extra characters after the last chunk,
>    516		 * so str[consumed] must be '\0'.
>    517		 */
>    518		if (str[consumed] ||
>    519		    (processed != 1 && processed != 3))
>    520			return -EINVAL;
>    521	
>    522		res[0].start = base;
>    523		res[0].end = base + size - 1;
>    524		res[0].flags = !strcmp(kp->name, "mmio") ? IORESOURCE_MEM :
>    525							   IORESOURCE_IO;
>    526	
>    527		/* insert register offsets, if provided */
>    528		if (processed > 1) {
>    529			res[1].name = "ctrl";
>    530			res[1].start = ctrl_off;
>    531			res[1].flags = IORESOURCE_REG;
>    532			res[2].name = "data";
>    533			res[2].start = data_off;
>    534			res[2].flags = IORESOURCE_REG;
>    535		}
>    536	
>    537		/* "processed" happens to nicely match the number of resources
>    538		 * we need to pass in to this platform device.
>    539		 */
>    540		fw_cfg_cmdline_dev = platform_device_register_simple("fw_cfg",
>    541						PLATFORM_DEVID_NONE, res, processed);
>    542		if (IS_ERR(fw_cfg_cmdline_dev))
>    543			return PTR_ERR(fw_cfg_cmdline_dev);
>    544	
>    545		return 0;
>    546	}
>    547	
>    548	static int fw_cfg_cmdline_get(char *buf, const struct kernel_param *kp)
>    549	{
>    550		/* stay silent if device was not configured via the command
>    551		 * line, or if the parameter name (ioport/mmio) doesn't match
>    552		 * the device setting
>    553		 */
>    554		if (!fw_cfg_cmdline_dev ||
>    555		    (!strcmp(kp->name, "mmio") ^
>    556		     (fw_cfg_cmdline_dev->resource[0].flags == IORESOURCE_MEM)))
>    557			return 0;
>    558	
>    559		switch (fw_cfg_cmdline_dev->num_resources) {
>    560		case 1:
>    561			return snprintf(buf, PAGE_SIZE, "0x%llx@0x%llx",
>    562					resource_size(&fw_cfg_cmdline_dev->resource[0]),
>  > 563					fw_cfg_cmdline_dev->resource[0].start);
>    564		case 3:
>    565			return snprintf(buf, PAGE_SIZE, "0x%llx@0x%llx:%llu:%llu",
>    566					resource_size(&fw_cfg_cmdline_dev->resource[0]),
>    567					fw_cfg_cmdline_dev->resource[0].start,
>    568					fw_cfg_cmdline_dev->resource[1].start,
>  > 569					fw_cfg_cmdline_dev->resource[2].start);
>    570		}
>    571	
>    572		/* Should never get here */
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
