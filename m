From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH RFC v2 0/7] epoll: Introduce new syscalls, epoll_ctl_batch
 and epoll_pwait1
Date: Wed, 4 Feb 2015 13:38:09 -0800
Message-ID: <CALCETrV731w37pxM0fzFZ3HHkn=9uoJX0-Rj6XqOf+hCRfnx8w@mail.gmail.com>
References: <1423046213-7043-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423046213-7043-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <pe>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 4, 2015 at 2:36 AM, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 2) epoll_pwait1
> ---------------
>
> NAME
>        epoll_pwait1 - wait for an I/O event on an epoll file descriptor
>
> SYNOPSIS
>
>        #include <sys/epoll.h>
>
>        int epoll_pwait1(int epfd, int flags,
>                         struct epoll_event *events,
>                         int maxevents,
>                         struct timespec *timeout,
>                         struct sigargs *sig);
>
> DESCRIPTION
>
>        The epoll_pwait1 system call differs from epoll_pwait only in parameter
>        types. The first difference is timeout, a pointer to timespec structure
>        which allows nanosecond presicion; the second difference, which should
>        probably be wrapper by glibc and only expose a sigset_t pointer as in
>        pselect6.
>
>        If timeout is NULL, it's treated as if 0 is specified in epoll_pwait
>        (return immediately). Otherwise it's converted to nanosecond scalar,
>        again, with the same convention as epoll_pwait's timeout.

Is the timeout absolute or relative?

I'd kind of like the ability to set timeouts on multiple clocks at the
same time, but I can live without that.

--Andy

>
> RETURN VALUE
>
>        The same as said in epoll_pwait(2).
>
> ERRORS
>
>        The same as said in man epoll_pwait(2), plus:
>
>        EINVAL flags is not zero.
>
>
> CONFORMING TO
>
>        epoll_pwait1() is Linux-specific.
>
> SEE ALSO
>
>        epoll_create(2), epoll_ctl(2), epoll_wait(2), epoll_pwait(2), epoll(7)
>
> Fam Zheng (7):
>   epoll: Extract epoll_wait_do and epoll_pwait_do
>   epoll: Specify clockid explicitly
>   epoll: Extract ep_ctl_do
>   epoll: Add implementation for epoll_ctl_batch
>   x86: Hook up epoll_ctl_batch syscall
>   epoll: Add implementation for epoll_pwait1
>   x86: Hook up epoll_pwait1 syscall
>
>  arch/x86/syscalls/syscall_32.tbl |   2 +
>  arch/x86/syscalls/syscall_64.tbl |   2 +
>  fs/eventpoll.c                   | 241 ++++++++++++++++++++++++++-------------
>  include/linux/syscalls.h         |   9 ++
>  include/uapi/linux/eventpoll.h   |  11 ++
>  5 files changed, 186 insertions(+), 79 deletions(-)
>
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
