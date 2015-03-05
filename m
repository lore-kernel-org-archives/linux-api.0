From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Thu, 05 Mar 2015 15:24:34 -0500
Message-ID: <54F8BB82.7040701@akamai.com>
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
>
> What difference does LIFO versus FIFO wakeups make to CPU utilization: 
> a thread waiting for work is idle, no matter whether it ran most 
> recently or least recently.
>
> Once an idle worker thread is woken it will compute its own work, for 
> whatever time it needs to, and won't be bothered by epoll again until 
> it finished its work and starts waiting again.
>
> So regardless the wakeup order it's the same principal bandwidth 
> utilization, modulo caching artifacts [*] and modulo scheduling 
> artifacts [**]:

So just adding the wakeup source as 'exclusive', I think would
give much of the desired behavior as you point out. In the first
patch posting I separated 'exclusive' from 'rotate' (where rotate
depended on exclusive), since the idle threads will tend to get
assigned the new work vs. the busy threads as you point out
and the workload naturally spreads out (modulo the artifacts
you mentioned).

However, I added the 'rotate' b/c I'm assigning work via the
wakeup that persists past the wakeup point. So without the rotate
I might end up assigning a lot of work to always say the first
thread if its always idle. And then I might get a large burst of
work queued to it at some later point. The rotate is intended
to address this case.

To use some pseudo-code in hopes of clarifying things, each
thread is roughly doing:

epoll_ctl(epfd, EPOLL_CTL_ADD, listen_fd...);

while(1) {

    epoll_wait(epfd...);
    fd = accept(listen_fd...);
    epoll_ctl(epfd, EPOLL_CTL_ADD, fd...);
    ...do any additional desired fd processing...
}

So since the work persists past the wakeup point (after
the 'fd' has been assigned to the epfd set of the local
thread), I am trying to balance out future load.

This is an issue that current userspace has to address in
various ways. In our case, we periodically remove all
epfds from the listen socket, and then re-add in a
different order periodically. Another alternative that was
suggested by Eric was to have a dedicated thread(s), to
do the assignment. So these approaches can work to an
extent, but they seem at least to me to complicate
userspace somewhat. And at least in our case, its not
providing as good balancing as this approach.

So I am trying to use epoll in a special way to do work
assignment. I think the model is different from the
standard waker/wakee model. So to that end, in this
v3 version, I've attempted to isolate all the changes to
be contained within epoll to reflect that fact.

Thanks,

-Jason


>
> [*]  Caching artifacts: in that sense Andrew's point stands: given 
>      multiple equivalent choices it's more beneficial to pick a thread 
>      that was most recently used (and is thus most cache-hot - i.e. 
>      the current wakeup behavior), versus a thread that was least 
>      recently used (and is thus the most cache-cold - i.e. the 
>      round-robin wakeup you introduce).
>
> [**] The hack patch I posted in my previous reply.
>
> Thanks,
>
> 	Ingo
>
