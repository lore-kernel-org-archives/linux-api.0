From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Fri, 27 Feb 2015 14:31:47 -0700
Message-ID: <20150227143147.07785626@lwn.net>
References: <cover.1424805740.git.jbaron@akamai.com>
	<20150225073814.GA14558@gmail.com>
	<54EDF7D8.60201@akamai.com>
	<20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150227131034.2f2787dcabf285191a1f6ffa-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 27 Feb 2015 13:10:34 -0800
Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> I don't really understand the need for rotation/round-robin.  We can
> solve the thundering herd via exclusive wakeups, but what is the point
> in choosing to wake the task which has been sleeping for the longest
> time?  Why is that better than waking the task which has been sleeping
> for the *least* time?  That's probably faster as that task's data is
> more likely to still be in cache.

So here's my chance to show the world what a fool I am (again)...  If I
understand this at all, a task woken from epoll_wait() remains on the wait
queues while it is off doing other stuff.  If you're doing exclusive
wakeups, the task at the head of the queue will get all of them, since it
never gets removed from the queue.  So you don't spread your load around,
and, indeed, you may "wake" a process that is busy doing something else and
can't deal with the event now anyway.  You need some way to shuffle up the
wait queue, and round-robin is probably as good as any.

(The alternative would be to take the process off the queue until it calls
epoll_wait() again, but that runs counter to what epoll is all about).

At least, that was my impression when I took a look at this stuff.

jon
