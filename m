From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Date: Tue, 20 Jan 2015 11:37:22 +0100
Message-ID: <874mrl3fh9.fsf@rasmusvillemoes.dk>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421747878-30744-1-git-send-email-famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Fam Zheng's
	message of "Tue, 20 Jan 2015 17:57:52 +0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TbrhsbdSgBK9A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20 2015, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

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

You probably want to say millisecond.

>            struct epoll_mod_cmd {
[...]
>            };


>            struct epoll_wait_spec {
[...]
>            } EPOLL_PACKED;

Either both or none of these should mention that EPOLL_PACKED is in fact
part of the actual definition. The changelog for 3/6 sorta mentions
that it's not really needed for epoll_mod_cmd. Why is it necessary for
either struct?

> RETURN VALUE
>
>        When successful, epoll_mod_wait() returns the number of file
>        descriptors ready for the requested I/O, or zero if no file descriptor
>        became ready during the requested timeout milliseconds.

And here, it doesn't make sense to mention a unit, since the new timeout
is given using struct timespec (this was the whole point, right?).

Rasmus
