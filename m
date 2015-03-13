From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 0/9] epoll: Introduce new syscalls, epoll_ctl_batch
 and epoll_pwait1
Date: Fri, 13 Mar 2015 10:46:47 -0400
Message-ID: <5502F857.6050505@akamai.com>
References: <1425952155-27603-1-git-send-email-famz@redhat.com> <5501AA6B.2020209@akamai.com> <20150313113122.GA7427@ad.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313113122.GA7427-ZfWej9ACyHUXGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz@>
List-Id: linux-api@vger.kernel.org


On 03/13/2015 07:31 AM, Fam Zheng wrote:
> On Thu, 03/12 11:02, Jason Baron wrote:
>> On 03/09/2015 09:49 PM, Fam Zheng wrote:
>>
>> Hi,
>>
>> So it sounds like you are comparing original qemu code (which was using
>> ppoll) vs. using epoll with these new syscalls. Curious if you have numbers
>> comparing the existing epoll (with say the timerfd in your epoll set), so
>> we can see the improvement relative to epoll.
> I did compare them, but they are too close to see differences. The improvements
> in epoll_pwait1 doesn't really help the hot path of guest IO, but it does
> affect the program timer precision, that are used in various device emulations
> in QEMU.
>
> Although it's kind of subtle and difficult to summarize here, I can give an
> example in the IO throttling implementation in QEMU, to show the significance:
>
> The throttling algorithm computes a duration for the next IO, which is used to
> arm a timer in order to delay the request a bit. As timers are always rounded
> *UP* to the effective granularity, the timeout being 1ms in epoll_pwait is just
> too coarse and will lead to severe inaccuracy. With epoll_pwait1, we can avoid
> the rounding-up.

right, but we could use the timerfd here to get the desired precision.

> I think this idea could be pertty generally desired by other applications, too.
>
> Regarding the epoll_ctl_batch improvement, again, it is not going to disrupt
> the numbers in the small workload I managed to test.
>
> Of course, if you have a specific application senario in mind, I will try it. :)

I want to understand what new functionality these syscalls offer over
what we have now. I mean we could show a micro-benchmark where
these matter, but is that enough to justify these new syscalls given that
I think we could implement library wrappers around what we have now
to do what you are proposing here.

Thanks,

-Jason
