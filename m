From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RESEND PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu,  8 Jan 2015 17:16:00 +0800
Message-ID: <1420708563-21743-1-git-send-email-famz@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Josh
List-Id: linux-api@vger.kernel.org

[Resend because my script screwed the recipient format, sorry for the noise.]

Applications could use epoll interface when then need to poll a big number of
files in their main loops, to achieve better performance than ppoll(2). Except
for one concern: epoll only takes timeout parameters in microseconds, rather
than nanoseconds.

That is a drawback we should address. For a real case in QEMU, we run into a
scalability issue with ppoll(2) when many devices are attached to guest, in
which case many host fds, such as virtual disk images and sockets, need to be
polled by the main loop. As a result we are looking at switching to epoll, but
the coarse timeout precision is a trouble, as explained below. 

We're already using prctl(PR_SET_TIMERSLACK, 1) which is necessary to implement
timers in the main loop; and we call ppoll(2) with the next firing timer as
timeout, so when ppoll(2) returns, we know that we have more work to do (either
handling IO events, or fire a timer callback). This is natual and efficient,
except that ppoll(2) itself is slow.

Now that we want to switch to epoll, to speed up the polling. However the timer
slack setting will be effectively undone, because that way we will have to
round up the timeout to microseconds honoring timer contract. But consequently,
this hurts the general responsiveness.

Note: there are two alternatives, without changing kernel:

1) Leading ppoll(2), with the epollfd only and a nanosecond timeout. It won't
be slow as one fd is polled. No more scalability issue. And if there are
events, we know from ppoll(2)'s return, then we do the epoll_wait(2) with
timeout=0; otherwise, there can't be events for the epoll, skip the following
epoll_wait and just continue with other work.

2) Setup and add a timerfd to epoll, then we do epoll_wait(..., timeout=-1).
The timerfd will hopefully force epoll_wait to return when it timeouts, even if
no other events have arrived. This will inheritly give us timerfd's precision.
Note that for each poll, the desired timeout is different because the next
timer is different, so that, before each epoll_wait(2), there will be a
timerfd_settime syscall to set it to a proper value.

Unfortunately, both approaches require one more syscall per iteration, compared
to the original single ppoll(2), cost of which is unneglectable when we talk
about nanosecond granularity.

Fam


Fam Zheng (3):
  epoll: Extract epoll_wait_do and epoll_pwait_do
  epoll: Add implementation for epoll_pwait1
  x86: hook up epoll_pwait1 syscall

 arch/x86/syscalls/syscall_32.tbl |   1 +
 arch/x86/syscalls/syscall_64.tbl |   1 +
 fs/eventpoll.c                   | 160 +++++++++++++++++++++++----------------
 include/linux/syscalls.h         |   4 +
 kernel/sys_ni.c                  |   3 +
 5 files changed, 103 insertions(+), 66 deletions(-)

-- 
1.9.3
