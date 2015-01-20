From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Date: Tue, 20 Jan 2015 14:40:32 -0800
Message-ID: <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA@mail.gmail.com>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421747878-30744-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <pe>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 1:57 AM, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This adds a new system call, epoll_mod_wait. It's described as below:
>
> NAME
>        epoll_mod_wait - modify and wait for I/O events on an epoll file
>                         descriptor
>
> SYNOPSIS
>
>        int epoll_mod_wait(int epfd, int flags,
>                           int ncmds, struct epoll_mod_cmd *cmds,
>                           struct epoll_wait_spec *spec);
>
> DESCRIPTION
>
>        The epoll_mod_wait() system call can be seen as an enhanced combination
>        of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
>        call. It is superior in two cases:
>
>        1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
>        will save context switches between user mode and kernel mode;
>
>        2) When you need higher precision than microsecond for wait timeout.
>
>        The epoll_ctl(2) operations are embedded into this call by with ncmds
>        and cmds. The latter is an array of command structs:
>
>            struct epoll_mod_cmd {
>
>                   /* Reserved flags for future extension, must be 0 for now. */
>                   int flags;
>
>                   /* The same as epoll_ctl() op parameter. */
>                   int op;
>
>                   /* The same as epoll_ctl() fd parameter. */
>                   int fd;
>
>                   /* The same as the "events" field in struct epoll_event. */
>                   uint32_t events;
>
>                   /* The same as the "data" field in struct epoll_event. */
>                   uint64_t data;
>
>                   /* Output field, will be set to the return code once this
>                    * command is executed by kernel */
>                   int error;
>            };

I would add an extra u32 at the end so that the structure size will be
a multiple of 8 bytes on all platforms.

>
>        There is no guartantee that all the commands are executed in order. Only
>        if all the commands are successfully executed (all the error fields are
>        set to 0), events are polled.

If this doesn't happen, what error is returned?

>            struct epoll_wait_spec {
>
>                   /* The same as "maxevents" in epoll_pwait() */
>                   int maxevents;
>
>                   /* The same as "events" in epoll_pwait() */
>                   struct epoll_event *events;
>
>                   /* Which clock to use for timeout */
>                   int clockid;
>
>                   /* Maximum time to wait if there is no event */
>                   struct timespec timeout;
>
>                   /* The same as "sigmask" in epoll_pwait() */
>                   sigset_t *sigmask;
>
>                   /* The same as "sigsetsize" in epoll_pwait() */
>                   size_t sigsetsize;
>            } EPOLL_PACKED;

I think the convention is to align the structure's fields manually
rather than declaring it to be packed.

>
> RETURN VALUE
>
>        When any error occurs, epoll_mod_wait() returns -1 and errno is set
>        appropriately. All the "error" fields in cmds are unchanged before they
>        are executed, and if any cmds are executed, the "error" fields are set
>        to a return code accordingly. See also epoll_ctl for more details of the
>        return code.

Does this mean that callers should initialize the error fields to an
impossible value first so they can tell which commands were executed?

>
>        When successful, epoll_mod_wait() returns the number of file
>        descriptors ready for the requested I/O, or zero if no file descriptor
>        became ready during the requested timeout milliseconds.
>
>        If spec is NULL, it returns 0 if all the commands are successful, and -1
>        if an error occured.
>
> ERRORS
>
>        These errors apply on either the return value of epoll_mod_wait or error
>        status for each command, respectively.

Please clarify which errors are returned overall and which are per-command.

Thanks,
Andy
