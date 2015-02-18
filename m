From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and
 EPOLLROUNDROBIN
Date: Wed, 18 Feb 2015 18:51:23 +0100
Message-ID: <20150218175123.GA31878@gmail.com>
References: <cover.1424200151.git.jbaron@akamai.com>
 <7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com>
 <20150218080740.GA10199@gmail.com>
 <54E4B2D0.8020706@akamai.com>
 <20150218163300.GA28007@gmail.com>
 <54E4CE14.5010708@akamai.com>
 <20150218174533.GB31566@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150218174533.GB31566@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-api@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > [...] However, I think the userspace API change is less 
> > clear since epoll_wait() doesn't currently have an 
> > 'input' events argument as epoll_ctl() does.
> 
> ... but the change would be a bit clearer and somewhat 
> more flexible: LIFO or FIFO queueing, right?
> 
> But having the queueing model as part of the epoll 
> context is a legitimate approach as well.

Btw., there's another optimization that the networking code 
already does when processing incoming packets: waking up a 
thread on the local CPU, where the wakeup is running.

Doing the same on epoll would have real scalability 
advantages where incoming events are IRQ driven and are 
distributed amongst multiple CPUs.

Where events are task driven the scheduler will already try 
to pair up waker and wakee so it might not show up in 
measurements that markedly.

Thanks,

	Ingo
