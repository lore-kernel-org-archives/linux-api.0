From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 3/9] sparc/sparc64: allocate sys_membarrier system
 call number
Date: Wed, 16 Sep 2015 18:06:55 +0000 (UTC)
Message-ID: <558658516.9497.1442426815738.JavaMail.zimbra@efficios.com>
References: <1441642556-30972-1-git-send-email-mathieu.desnoyers@efficios.com> <1441642556-30972-4-git-send-email-mathieu.desnoyers@efficios.com> <542470980.9287.1442415954054.JavaMail.zimbra@efficios.com> <20150916.105720.1147038044649285686.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150916.105720.1147038044649285686.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 16, 2015, at 1:57 PM, David Miller davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org wrote:

> From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> Date: Wed, 16 Sep 2015 15:05:54 +0000 (UTC)
> 
>> ----- On Sep 7, 2015, at 12:15 PM, Mathieu Desnoyers
>> mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
>> 
>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>>> Acked-by: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
>>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> CC: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> 
>> Hi,
>> 
>> FYI, sys_membarrier has been merged upstream in Linux 4.3-rc1. Feel free
>> to wire up this system call on sparc.
> 
> Since I ACK'd this patch which wires the system call up, it should
> have been submitted by you directly.  That's the whole idea.

OK, good to know. Other architecture maintainers chose to pick up the
system call wire-up patch themselves.

Andrew, can you pick up this patch please ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
