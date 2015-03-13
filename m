From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/9] epoll: Introduce new syscalls, epoll_ctl_batch
 and epoll_pwait1
Date: Fri, 13 Mar 2015 19:31:22 +0800
Message-ID: <20150313113122.GA7427@ad.nay.redhat.com>
References: <1425952155-27603-1-git-send-email-famz@redhat.com>
 <5501AA6B.2020209@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5501AA6B.2020209-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peter>
List-Id: linux-api@vger.kernel.org

On Thu, 03/12 11:02, Jason Baron wrote:
> On 03/09/2015 09:49 PM, Fam Zheng wrote:
> >
> > Benchmark for epoll_pwait1
> > ==========================
> >
> > By running fio tests inside VM with both original and modified QEMU, we can
> > compare their difference in performance.
> >
> > With a small VM setup [t1], the original QEMU (ppoll based) has an 4k read
> > latency overhead around 37 us. In this setup, the main loop polls 10~20 fds.
> >
> > With a slightly larger VM instance [t2] - attached a virtio-serial device so
> > that there are 80~90 fds in the main loop - the original QEMU has a latency
> > overhead around 49 us. By adding more such devices [t3], we can see the latency
> > go even higher - 83 us with ~200 FDs.
> >
> > Now modify QEMU to use epoll_pwait1 and test again, the latency numbers are
> > repectively 36us, 37us, 47us for t1, t2 and t3.
> >
> >
> 
> Hi,
> 
> So it sounds like you are comparing original qemu code (which was using
> ppoll) vs. using epoll with these new syscalls. Curious if you have numbers
> comparing the existing epoll (with say the timerfd in your epoll set), so
> we can see the improvement relative to epoll.

I did compare them, but they are too close to see differences. The improvements
in epoll_pwait1 doesn't really help the hot path of guest IO, but it does
affect the program timer precision, that are used in various device emulations
in QEMU.

Although it's kind of subtle and difficult to summarize here, I can give an
example in the IO throttling implementation in QEMU, to show the significance:

The throttling algorithm computes a duration for the next IO, which is used to
arm a timer in order to delay the request a bit. As timers are always rounded
*UP* to the effective granularity, the timeout being 1ms in epoll_pwait is just
too coarse and will lead to severe inaccuracy. With epoll_pwait1, we can avoid
the rounding-up.

I think this idea could be pertty generally desired by other applications, too.

Regarding the epoll_ctl_batch improvement, again, it is not going to disrupt
the numbers in the small workload I managed to test.

Of course, if you have a specific application senario in mind, I will try it. :)

Thanks,
Fam
