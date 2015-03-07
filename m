From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Sat, 07 Mar 2015 07:35:02 -0500
Message-ID: <54FAF076.3090308@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com> <20150225073814.GA14558@gmail.com> <54EDF7D8.60201@akamai.com> <20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org> <54F0E93C.3010306@akamai.com> <20150227143158.afa4ec39d49d5815cbbd6a6c@linux-foundation.org> <20150305000225.GA27592@gmail.com> <54F7D343.5090106@akamai.com> <20150305091517.GA25158@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150305091517.GA25158-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/05/2015 04:15 AM, Ingo Molnar wrote:
> * Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
>
>> 2) We are using the wakeup in this case to 'assign' work more 
>> permanently to the thread. That is, in the case of a listen socket 
>> we then add the connected socket to the woken up threads local set 
>> of epoll events. So the load persists past the wake up. And in this 
>> case, doing the round robin wakeups, simply allows us to access more 
>> cpu bandwidth. (I'm also looking into potentially using cpu affinity 
>> to do the wakeups as well as you suggested.)
> So this is the part that I still don't understand.

Here's maybe another way to frame this. Epoll sets add
a waiter on the wait queue in a fixed order when epoll sets
are added (via EPOLL_CTL_ADD). This order does not change
modulo adds/dels which are usually not common. So if
we don't want to wake all threads, when say an interrupt
occurs at some random point, we can either:

1) Walk the list, wake up the first epoll set that has idle
threads (queued via epoll_wait()) and return.

or:

2) Walk the list and wake up the first epoll set that has idle
threads, but then 'rotate' or move this epoll set to the tail
of the queue before returning.

So because the epoll sets are in a fixed order there is
an extreme bias to pick the same epoll sets over and over
regardless of the order in which threads return to wait
via (epoll_wait()). So I think the rotate makes sense for
the case where I am trying to assign work to threads that
may persist past the wake up point, and for cases where
the threads can finish all their work before returning
back to epoll_wait().

Thanks,

-Jason
