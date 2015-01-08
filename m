From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu, 8 Jan 2015 10:42:01 -0800
Message-ID: <20150108184201.GB13974@cloud>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
 <1420708372.18399.15.camel@suse.cz>
 <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <math>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 08, 2015 at 09:57:24AM -0800, Andy Lutomirski wrote:
> On Thu, Jan 8, 2015 at 1:12 AM, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Thu, 2015-01-08 at 16:25 +0800, Fam Zheng wrote:
> >> Applications could use epoll interface when then need to poll a big number of
> >> files in their main loops, to achieve better performance than ppoll(2). Except
> >> for one concern: epoll only takes timeout parameters in microseconds, rather
> >> than nanoseconds.
> >>
> >> That is a drawback we should address. For a real case in QEMU, we run into a
> >> scalability issue with ppoll(2) when many devices are attached to guest, in
> >> which case many host fds, such as virtual disk images and sockets, need to be
> >> polled by the main loop. As a result we are looking at switching to epoll, but
> >> the coarse timeout precision is a trouble, as explained below.
> >>
> >> We're already using prctl(PR_SET_TIMERSLACK, 1) which is necessary to implement
> >> timers in the main loop; and we call ppoll(2) with the next firing timer as
> >> timeout, so when ppoll(2) returns, we know that we have more work to do (either
> >> handling IO events, or fire a timer callback). This is natual and efficient,
> >> except that ppoll(2) itself is slow.
> >>
> >> Now that we want to switch to epoll, to speed up the polling. However the timer
> >> slack setting will be effectively undone, because that way we will have to
> >> round up the timeout to microseconds honoring timer contract. But consequently,
> >> this hurts the general responsiveness.
> >>
> >> Note: there are two alternatives, without changing kernel:
> >>
> >> 1) Leading ppoll(2), with the epollfd only and a nanosecond timeout. It won't
> >> be slow as one fd is polled. No more scalability issue. And if there are
> >> events, we know from ppoll(2)'s return, then we do the epoll_wait(2) with
> >> timeout=0; otherwise, there can't be events for the epoll, skip the following
> >> epoll_wait and just continue with other work.
> >>
> >> 2) Setup and add a timerfd to epoll, then we do epoll_wait(..., timeout=-1).
> >> The timerfd will hopefully force epoll_wait to return when it timeouts, even if
> >> no other events have arrived. This will inheritly give us timerfd's precision.
> >> Note that for each poll, the desired timeout is different because the next
> >> timer is different, so that, before each epoll_wait(2), there will be a
> >> timerfd_settime syscall to set it to a proper value.
> >>
> >> Unfortunately, both approaches require one more syscall per iteration, compared
> >> to the original single ppoll(2), cost of which is unneglectable when we talk
> >> about nanosecond granularity.
> 
> I'd like to see a more ambitious change, since the timer isn't the
> only problem like this.  Specifically, I'd like a syscall that does a
> list of epoll-related things and then waits.  The list of things could
> include, at least:
> 
>  - EPOLL_CTL_MOD actions: level-triggered epoll users are likely to
> want to turn on and off their requests for events on a somewhat
> regular basis.
> 
>  - timerfd_settime actions: this allows a single syscall to wait and
> adjust *both* monotonic and real-time wakeups.
> 
> Would this make sense?  It could look like:
> 
> int epoll_mod_and_pwait(int epfd,
>   struct epoll_event *events, int maxevents,
>   struct epoll_command *commands, int ncommands,
>   const sigset_t *sigmask);

That's a complicated syscall.  (And it also doesn't have room for the
flags argument.)

At that point, why not just have a syscall like this:

struct syscall {
	unsigned long num;
	unsigned long params[6];
};

int sys_many(size_t count, struct syscall *syscalls, int *results, unsigned long flags);

I think that has been discussed in the past.

Or, these days, that might be better done via eBPF, which would avoid
the need for flags like "return on error"; an eBPF program could decide
how to proceed after each call.

- Josh Triplett
