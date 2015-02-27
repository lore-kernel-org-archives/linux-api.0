From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Fri, 27 Feb 2015 14:31:58 -0800
Message-ID: <20150227143158.afa4ec39d49d5815cbbd6a6c@linux-foundation.org>
References: <cover.1424805740.git.jbaron@akamai.com>
	<20150225073814.GA14558@gmail.com>
	<54EDF7D8.60201@akamai.com>
	<20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org>
	<54F0E93C.3010306@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54F0E93C.3010306@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Ingo Molnar <mingo@kernel.org>, peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@ftp.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, 27 Feb 2015 17:01:32 -0500 Jason Baron <jbaron@akamai.com> wrote:

> 
> >
> > I don't really understand the need for rotation/round-robin.  We can
> > solve the thundering herd via exclusive wakeups, but what is the point
> > in choosing to wake the task which has been sleeping for the longest
> > time?  Why is that better than waking the task which has been sleeping
> > for the *least* time?  That's probably faster as that task's data is
> > more likely to still be in cache.
> >
> > The changelogs talks about "starvation" but they don't really say what
> > this term means in this context, nor why it is a bad thing.
> >

I'm still not getting it.

> So the idea with the 'rotation' is to try and distribute the
> workload more evenly across the worker threads.

Why?

> We currently
> tend to wake up the 'head' of the queue over and over and
> thus the workload for us is not evenly distributed.

What's wrong with that?

> In fact, we
> have a workload where we have to remove all the epoll sets
> and then re-add them in a different order to improve the situation.

Why?

> We are trying to avoid this workaround and in addition avoid
> thundering wakeups when possible (using exclusive as you
> mention).


A better way to describe a patchset like this is to start out
describing what the user sees: what is wrong with the current kernel
behaviour and how will it be improved?  Once that is understood then
start getting into kernel internal details.


Jon's explanation was much more useful.  Was it accurate?
