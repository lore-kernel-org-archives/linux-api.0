From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Allocating sys_membarrier syscall number on other archs
Date: Thu, 27 Aug 2015 04:04:42 +0000 (UTC)
Message-ID: <1721242013.30076.1440648282669.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Andrew,

The sys_membarrier patches you have in your tree target
x86 32-64 and generic, but I did not allocate the system call
number on other architectures to minimize the amount of
collisions, and because I do not have all those architectures
handy.

How would you recommend to proceed to allocate those ?

sys_membarrier is pretty much architecture agnostic: it
takes two integer parameters, and the only function it calls,
synchronize_sched(), is available on all architectures.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
