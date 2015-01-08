From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu, 8 Jan 2015 12:07:20 +0100
Message-ID: <CAKgNAkiOeKG4KGVOn8DxzLw1cN2Qx74NKDyjtSSkO8QcJYrKsQ@mail.gmail.com>
References: <1420705550-24245-1-git-send-email-famz@redhat.com> <1420708372.18399.15.camel@suse.cz>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420708372.18399.15.camel-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>
Cc: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>Fabian Frederick <f>
List-Id: linux-api@vger.kernel.org

On 8 January 2015 at 10:12, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Thu, 2015-01-08 at 16:25 +0800, Fam Zheng wrote:
>> Applications could use epoll interface when then need to poll a big number of
>> files in their main loops, to achieve better performance than ppoll(2). Except
>> for one concern: epoll only takes timeout parameters in microseconds, rather
>> than nanoseconds.
>>
>> That is a drawback we should address. For a real case in QEMU, we run into a
>> scalability issue with ppoll(2) when many devices are attached to guest, in
>> which case many host fds, such as virtual disk images and sockets, need to be
>> polled by the main loop. As a result we are looking at switching to epoll, but
>> the coarse timeout precision is a trouble, as explained below.
>>
>> We're already using prctl(PR_SET_TIMERSLACK, 1) which is necessary to implement
>> timers in the main loop; and we call ppoll(2) with the next firing timer as
>> timeout, so when ppoll(2) returns, we know that we have more work to do (either
>> handling IO events, or fire a timer callback). This is natual and efficient,
>> except that ppoll(2) itself is slow.
>>
>> Now that we want to switch to epoll, to speed up the polling. However the timer
>> slack setting will be effectively undone, because that way we will have to
>> round up the timeout to microseconds honoring timer contract. But consequently,
>> this hurts the general responsiveness.
>>
>> Note: there are two alternatives, without changing kernel:
>>
>> 1) Leading ppoll(2), with the epollfd only and a nanosecond timeout. It won't
>> be slow as one fd is polled. No more scalability issue. And if there are
>> events, we know from ppoll(2)'s return, then we do the epoll_wait(2) with
>> timeout=0; otherwise, there can't be events for the epoll, skip the following
>> epoll_wait and just continue with other work.
>>
>> 2) Setup and add a timerfd to epoll, then we do epoll_wait(..., timeout=-1).
>> The timerfd will hopefully force epoll_wait to return when it timeouts, even if
>> no other events have arrived. This will inheritly give us timerfd's precision.
>> Note that for each poll, the desired timeout is different because the next
>> timer is different, so that, before each epoll_wait(2), there will be a
>> timerfd_settime syscall to set it to a proper value.
>>
>> Unfortunately, both approaches require one more syscall per iteration, compared
>> to the original single ppoll(2), cost of which is unneglectable when we talk
>> about nanosecond granularity.
>
> Please consider adding a "flags" argument to the new syscall (and
> returning EINVAL if non-zero).  See this article, which shows that
> extended syscalls almost always want flags, and they often get it only
> on the second try:
>
> http://lwn.net/Articles/585415/

Yes, please ensure that the new call gets a flags argument. We've made
this mistake way too many times in the past.

Thanks,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
