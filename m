From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Mon, 02 Mar 2015 00:04:56 -0500
Message-ID: <54F3EF78.8020603@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com>	<20150225073814.GA14558@gmail.com>	<54EDF7D8.60201@akamai.com>	<20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org> <20150227143147.07785626@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227143147.07785626-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/27/2015 04:31 PM, Jonathan Corbet wrote:
> On Fri, 27 Feb 2015 13:10:34 -0800
> Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
>> I don't really understand the need for rotation/round-robin.  We can
>> solve the thundering herd via exclusive wakeups, but what is the point
>> in choosing to wake the task which has been sleeping for the longest
>> time?  Why is that better than waking the task which has been sleeping
>> for the *least* time?  That's probably faster as that task's data is
>> more likely to still be in cache.
> So here's my chance to show the world what a fool I am (again)...  If I
> understand this at all, a task woken from epoll_wait() remains on the wait
> queues while it is off doing other stuff.  If you're doing exclusive
> wakeups, the task at the head of the queue will get all of them, since it
> never gets removed from the queue.  So you don't spread your load around,
> and, indeed, you may "wake" a process that is busy doing something else and
> can't deal with the event now anyway.  You need some way to shuffle up the
> wait queue, and round-robin is probably as good as any.
>
> (The alternative would be to take the process off the queue until it calls
> epoll_wait() again, but that runs counter to what epoll is all about).
>
> At least, that was my impression when I took a look at this stuff.
>
> jon

So tasks do not remain on wait queues when they are not in
epoll_wait(). That is, tasks are added to the associated epoll
fd wait queue at the beginning of epoll_wait(), and removed
from the associated epoll fd wait queue when epoll_wait()
returns.

One can think about the problem, perhaps, as assigning fd
events - POLLIN, POLLLOUT, etc., to a set of tasks. And this
discussion is about how to do the assignment in certain
cases. Namely, one could start by partitioning  the set of fds
into unique sets and then assigning them
(via EPOLL_CTL_ADD) to different epoll fds. Then, if there
is say a single task blocking on each epoll fd (via epoll_wait())
then each task can work nicely on its own set of events
without needing to necessarily co-ordinate with the other
tasks.

Now, this all works fine until, we have an 'fd' or event source
that we wish to share among all the tasks. We might
want to share it because it generates events or work, that
would potentially overwhelm a single task.

So in this shared event source case, where we have added
the fd to all of the epoll fds, we currently do a wake all.
This series attempts to change that behavior (with an
optional flag to epoll_create1()), into a round robin wakeup
(both to avoid excessive wakeups and to more evenly distribute
the wakeups). Note also that it will continue to wake up tasks,
as long as it doesn't find any in epoll_wait(). Thus, it still can
potentially wake up all if nobody is in epoll_wait().

Now, we could try and distribute the fd events among tasks
all waiting on a single epoll fd (meaning we have a single
event queue). But, we have already partitioned most of the
events, why combine them back into a single queue?

Thanks,

-Jason
