From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 6/9] arm: allocate sys_membarrier system call
 number
Date: Thu, 17 Sep 2015 13:37:53 +0000 (UTC)
Message-ID: <886006042.10465.1442497073084.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-7-git-send-email-mathieu.desnoyers@efficios.com> <2106738851.9514.1442428030540.JavaMail.zimbra@efficios.com> <20150917131316.GO21084@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917131316.GO21084-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Jeanson <mjeanson-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 17, 2015, at 9:13 AM, Russell King - ARM Linux linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org wrote:

> On Wed, Sep 16, 2015 at 06:27:10PM +0000, Mathieu Desnoyers wrote:
>> ----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers
>> mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
>> 
>> > [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>> >  apply this patch, build/run a membarrier-enabled kernel, and do make
>> >  kselftest. ]
>> 
>> Hi,
>> 
>> We tested the system call on our ARM board (Wandboard, SoC
>> Freescale i.MX6 Quad) by applying this patch on top of
>> Linux 4.3-rc1. Both the membarrier kselftest and
>> Userspace RCU regression tests (the latter manually wired up
>> on sys_membarrier) work fine.
>> 
>> Tested-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> 
>> sys_membarrier has been pulled into Linux 4.3-rc1. Please
>> feel free to wire it up on ARM.
> 
> Well, it's not going to end up with 388, but 389, because we also have
> userfaultfd added in the same merge window, and I follow the x86
> syscall ordering when adding to ARM.

That's fine with me!

Thanks,

Mathieu

> 
> --
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
