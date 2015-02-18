From: Eric Wong <normalperson-rMlxZR9MS24@public.gmane.org>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and
 EPOLLROUNDROBIN
Date: Wed, 18 Feb 2015 22:18:08 +0000
Message-ID: <20150218221808.GA3799@dcvr.yhbt.net>
References: <cover.1424200151.git.jbaron@akamai.com>
 <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com>
 <20150218080740.GA10199@gmail.com>
 <54E4B2D0.8020706@akamai.com>
 <20150218163300.GA28007@gmail.com>
 <54E4CE14.5010708@akamai.com>
 <20150218174533.GB31566@gmail.com>
 <20150218175123.GA31878@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150218175123.GA31878-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> * Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> 
> > > [...] However, I think the userspace API change is less 
> > > clear since epoll_wait() doesn't currently have an 
> > > 'input' events argument as epoll_ctl() does.
> > 
> > ... but the change would be a bit clearer and somewhat 
> > more flexible: LIFO or FIFO queueing, right?
> > 
> > But having the queueing model as part of the epoll 
> > context is a legitimate approach as well.
> 
> Btw., there's another optimization that the networking code 
> already does when processing incoming packets: waking up a 
> thread on the local CPU, where the wakeup is running.
> 
> Doing the same on epoll would have real scalability 
> advantages where incoming events are IRQ driven and are 
> distributed amongst multiple CPUs.

Right.  One thing in the back of my mind has been to have CPU
affinity for epoll.  Either having everything in an epoll set
favor a certain CPU or even having affinity down to the epitem
level (so concurrent epoll_wait callers end up favoring the
same epitems).

I'm not convinced this series is worth doing without a
comparison against my previous suggestion to use a dedicated
thread which only makes blocking accept4 + EPOLL_CTL_ADD calls.

The majority of epoll events in a typical server should not be
for listen sockets, so I'd rather not bloat existing code paths
for them.  For web servers nowadays, the benefits of maintaining
long-lived connections to avoid handshakes is even more
beneficial with increasing HTTPS and HTTP2 adoption; so
listen socket events should become less common.
