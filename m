From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Wed, 25 Feb 2015 08:38:14 +0100
Message-ID: <20150225073814.GA14558@gmail.com>
References: <cover.1424805740.git.jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1424805740.git.jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> Hi,
> 
> When we are sharing a wakeup source among multiple epoll 
> fds, we end up with thundering herd wakeups, since there 
> is currently no way to add to the wakeup source 
> exclusively. This series introduces a new EPOLL_ROTATE 
> flag to allow for round robin exclusive wakeups.
> 
> I believe this patch series addresses the two main 
> concerns that were raised in prior postings. Namely, that 
> it affected code (and potentially performance) of the 
> core kernel wakeup functions, even in cases where it was 
> not strictly needed, and that it could lead to wakeup 
> starvation (since we were are no longer waking up all 
> waiters). It does so by adding an extra layer of 
> indirection, whereby waiters are attached to a 'psuedo' 
> epoll fd, which in turn is attached directly to the 
> wakeup source.

>   sched/wait: add __wake_up_rotate()

>  include/linux/wait.h           |  1 +
>  kernel/sched/wait.c            | 27 ++++++++++++++++++++++

So the scheduler bits are looking good to me in principle, 
because they just add a new round-robin-rotating wakeup 
variant and don't disturb the others.

Is there consensus on the epoll ABI changes? With Davide 
Libenzi inactive eventpoll appears to be without a 
dedicated maintainer since 2011 or so. Is there anyone who 
knows the code and its usages in detail and does final ABI 
decisions on eventpoll - Andrew, Al or Linus?

Thanks,

	Ingo
