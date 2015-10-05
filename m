From: Rusty Russell <rusty-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] sys_membarrier (x86, generic)
Date: Tue, 06 Oct 2015 09:51:39 +1030
Message-ID: <87vbaknbp8.fsf@rustcorp.com.au>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436561912-24365-1-git-send-email-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:
> Hi Andrew,
>
> Here is a repost of sys_membarrier, rebased on top of Linus commit
> c4b5fd3fb2058b650447372472ad24e2a989f9f6 without any change since the
> last v19 post other that proceeding to further testing. When merging
> with other system calls, system call number conflicts should be quite
> straightforward to handle, there is nothing special there.

Hi Mathieu,

        Great to see this go in!  One small note: it talks about
threads, but membarrier as currently implemented would cover any shared
memory.  If you plan to optimize in future, that might not be the case:
we'd want an address argument for those cases?

Cheers,
Rusty.
