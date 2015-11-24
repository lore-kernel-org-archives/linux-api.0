From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [PATCH v5 1/4] firmware: introduce sysfs driver for
 QEMU's fw_cfg device
Date: Tue, 24 Nov 2015 18:44:33 +0100
Message-ID: <5654A201.2070902@redhat.com>
References: <1448294264-17388-2-git-send-email-somlo@cmu.edu>
 <201511240404.AFpczj7x%fengguang.wu@intel.com>
 <20151124165553.GA22627@HEDWIG.INI.CMU.EDU> <5654A08A.6030002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5654A08A.6030002-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Gabriel L. Somlo" <somlo-D+Gtc/HYRWM@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, zajec5-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, jordan.l.justen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, agross-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, sudeep.holla-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, revol-GANU6spQydw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/24/15 18:38, Eric Blake wrote:
> On 11/24/2015 09:55 AM, Gabriel L. Somlo wrote:
>> On Tue, Nov 24, 2015 at 04:14:50AM +0800, kbuild test robot wrote:
> 
>>>
>>>    drivers/firmware/qemu_fw_cfg.c: In function 'fw_cfg_cmdline_set':
>>>>> drivers/firmware/qemu_fw_cfg.c:510:7: warning: format '%lli' expects argument of type 'long long int *', but argument 3 has type 'phys_addr_t *' [-Wformat=]
>>>           &ctrl_off, &data_off, &consumed);
>>>           ^
>>
>> Oh, I think I know why this happened:
>>
> 
>>
>> So, I could use u64 instead of phys_addr_t and resource_size_t, and
>> keep "%lli" (or "%Li"), but then I'd have to check if the parsed value
> 
> %Li is not POSIX.  Don't use it (stick with %lli).
> 
>> would overflow a 32-bit address value on arches where phys_addr_t is
>> u32, which would make things a bit more messy and awkward.
>>
>> I'm planning on #ifdef-ing the format string instead:
>>
>> #ifdef CONFIG_PHYS_ADDR_T_64BIT
>> #define PH_ADDR_SCAN_FMT "@%Li%n:%Li:%Li%n"
>> #else
>> #define PH_ADDR_SCAN_FMT "@%li%n:%li:%li%n"
>> #endif
> 
> A more typical approach is akin to <inttypes.h>; have PH_ADDR_FMT
> defined to either "lli" or "li", then write sscanf(str, "@%"PH_ADDR_FMT
> "%n:..., ...), using PH_ADDR_FMT multiple times.
> 
>> ...
>>         processed = sscanf(str, PH_ADDR_SCAN_FMT,
>>                            &base, &consumed,
>>                            &ctrl_off, &data_off, &consumed);
> 
> Umm, why are you passing &consumed to more than one sscanf() %?  That's
> (probably) undefined behavior.
> 
> [In general, sscanf() is a horrid interface to use for parsing integers
> - it has undefined behavior if the input text would trigger integer
> overflow, making it safe to use ONLY on text that you control and can
> guarantee won't overflow. By the time you've figured out if untrusted
> text meets the requirement for safe parsing via sscanf(), you've
> practically already parsed it via safer strtol() and friends.]
> 

Yes, but this is the kernel, which may or may not follow POSIX
semantics. (And may or may not curse at POSIX in the process, either
way! :))

Laszlo
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
