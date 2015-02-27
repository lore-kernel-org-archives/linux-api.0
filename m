From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Fri, 27 Feb 2015 17:01:32 -0500
Message-ID: <54F0E93C.3010306@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com>	<20150225073814.GA14558@gmail.com>	<54EDF7D8.60201@akamai.com> <20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@ftp.linux.org.uk>
List-Id: linux-api@vger.kernel.org


On 02/27/2015 04:10 PM, Andrew Morton wrote:
> On Wed, 25 Feb 2015 11:27:04 -0500 Jason Baron <jbaron@akamai.com> wrote:
>
>>> Libenzi inactive eventpoll appears to be without a 
>>> dedicated maintainer since 2011 or so. Is there anyone who 
>>> knows the code and its usages in detail and does final ABI 
>>> decisions on eventpoll - Andrew, Al or Linus?
>>>
>> Generally, Andrew and Al do more 'final' reviews here,
>> and a lot of others on lkml are always very helpful in
>> looking at this code. However, its not always clear, at
>> least to me, who I should pester.
> Yes, it's a difficult situation.
>
> The 3/3 changelog refers to "EPOLLROUNDROBIN" which I assume is
> a leftover from some earlier revision?

Yes, that's a typo there. It should read 'EPOLL_ROTATE'.

>
> I don't really understand the need for rotation/round-robin.  We can
> solve the thundering herd via exclusive wakeups, but what is the point
> in choosing to wake the task which has been sleeping for the longest
> time?  Why is that better than waking the task which has been sleeping
> for the *least* time?  That's probably faster as that task's data is
> more likely to still be in cache.
>
> The changelogs talks about "starvation" but they don't really say what
> this term means in this context, nor why it is a bad thing.
>

So the idea with the 'rotation' is to try and distribute the
workload more evenly across the worker threads. We currently
tend to wake up the 'head' of the queue over and over and
thus the workload for us is not evenly distributed. In fact, we
have a workload where we have to remove all the epoll sets
and then re-add them in a different order to improve the situation.
We are trying to avoid this workaround and in addition avoid
thundering wakeups when possible (using exclusive as you
mention).

I agree that waking up the task that may have been sleeping longer
may not be the best for all workloads. So what I am proposing
here is an optional flag to meet a certain workload. It might not be
right for all workloads, but we have found it quite useful.

The 'starvation' mention was in regards to the fact that with this
new behavior of not waking up all threads (and rotating them),
an adversarial thread might insert itself into our wakeup queue
and 'starve' us out. This concern was raised by Andy Lutomirkski,
and this current series is not subject to this issue, b/c it works
by creating a new epoll fd and then adding that epoll fd to the
wakeup queue.  Thus, this 'new' epoll fd is local to the thread
and the wakeup queue continues to wake all threads. Only the
'new' epoll fd which we then attach ourselves to, implements the
exclusive/rotate behavior.

Thanks,

-Jason


