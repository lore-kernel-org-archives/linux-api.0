From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 2/9] arm: allocate sys_membarrier system call number
Date: Thu, 27 Aug 2015 23:16:41 +0000 (UTC)
Message-ID: <1862556294.30845.1440717401951.JavaMail.zimbra@efficios.com>
References: <1440698215-8355-1-git-send-email-mathieu.desnoyers@efficios.com> <1440698215-8355-3-git-send-email-mathieu.desnoyers@efficios.com> <20150827225147.GG21084@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150827225147.GG21084-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

----- On Aug 27, 2015, at 6:51 PM, Russell King - ARM Linux linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org wrote:

> On Thu, Aug 27, 2015 at 01:56:48PM -0400, Mathieu Desnoyers wrote:
>> [ Untested on this architecture. To try it out: fetch linux-next/akpm,
>>   apply this patch, build/run a membarrier-enabled kernel, and do make
>>   kselftest. ]
> 
> But note: the system call is not guaranteed to be allocated at that number
> until I've merged the patch.  I believe that there's other system calls
> which are pending during the next merge window.

Sure, no problem. I mainly want to make sure the system call
works fine on each major arch before we reach the merge window.

Let me know if you want me to send an updated version of this
patch during or after the merge window.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
