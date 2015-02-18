From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and
 EPOLLROUNDROBIN
Date: Wed, 18 Feb 2015 18:45:33 +0100
Message-ID: <20150218174533.GB31566@gmail.com>
References: <cover.1424200151.git.jbaron@akamai.com>
 <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com>
 <20150218080740.GA10199@gmail.com>
 <54E4B2D0.8020706@akamai.com>
 <20150218163300.GA28007@gmail.com>
 <54E4CE14.5010708@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54E4CE14.5010708-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> So in the case of multiple threads per epoll set, we 
> currently add to the head of wakeup queue exclusively in 
> 'epoll_wait()', and then subsequently remove from the 
> queue once 'epoll_wait()' returns. So I don't think this 
> patch addresses balancing on a per epoll set basis.

Okay, so I was confused about how the code works.

> I think we could address the case you describe by simply 
> doing __add_wait_queue_tail_exclusive() instead of 
> __add_wait_queue_exclusive() in epoll_wait(). [...]

Yes.

> [...] However, I think the userspace API change is less 
> clear since epoll_wait() doesn't currently have an 
> 'input' events argument as epoll_ctl() does.

... but the change would be a bit clearer and somewhat more 
flexible: LIFO or FIFO queueing, right?

But having the queueing model as part of the epoll context 
is a legitimate approach as well.

Thanks,

	Ingo
