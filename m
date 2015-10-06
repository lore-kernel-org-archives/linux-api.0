From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] sys_membarrier (x86, generic)
Date: Tue, 6 Oct 2015 02:17:36 +0000 (UTC)
Message-ID: <1840779213.18838.1444097856879.JavaMail.zimbra@efficios.com>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com> <87vbaknbp8.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87vbaknbp8.fsf-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Oct 5, 2015, at 7:21 PM, Rusty Russell rusty-mnsaURCQ41sdnm+yROfE0A@public.gmane.org wrote:

> Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:
>> Hi Andrew,
>>
>> Here is a repost of sys_membarrier, rebased on top of Linus commit
>> c4b5fd3fb2058b650447372472ad24e2a989f9f6 without any change since the
>> last v19 post other that proceeding to further testing. When merging
>> with other system calls, system call number conflicts should be quite
>> straightforward to handle, there is nothing special there.
> 
> Hi Mathieu,
> 
>        Great to see this go in!  One small note: it talks about
> threads, but membarrier as currently implemented would cover any shared
> memory.  If you plan to optimize in future, that might not be the case:
> we'd want an address argument for those cases?

Hi Rusty,

Indeed, the current membarrier implementation only supports
the MEMBARRIER_CMD_SHARED flag, which works even with shared
memory across processes. If we ever want to optimize that for
single-process, multi-threaded cases, we would have to add
a new flag (e.g. MEMBARRIER_CMD_PRIVATE). This is quite
similar to what already exists in the futex system call.

I'm not sure I fully understand where the address argument
you are describing would be useful. So far, I see two
main use-cases: we either interact with memory that is
local to a single process, or with memory shared across
processes.

We could indeed think about sending a membarrier to all
processes using a specific shared memory area (hence the
possible need for an address argument). This could eventually
be supported by adding a specific flag for this (e.g.
MEMBARRIER_CMD_SHM), which would indicate that an extra
parameter is provided (an address).

Thoughts ?

Thanks for the feedback!

Mathieu

> 
> Cheers,
> Rusty.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
