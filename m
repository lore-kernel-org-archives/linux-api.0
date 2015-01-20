From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH RFC 0/6] epoll: Introduce new syscall "epoll_mod_wait"
Date: Tue, 20 Jan 2015 15:03:52 -0800
Message-ID: <20150120230352.GB14475@cloud>
References: <1421747878-30744-1-git-send-email-famz@redhat.com>
 <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrU4TeG1ShVLkQgqQ6usFm8pg_t0D8K=Mi_UJGSfxUwXtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers@effici>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 02:40:32PM -0800, Andy Lutomirski wrote:
> On Tue, Jan 20, 2015 at 1:57 AM, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > This adds a new system call, epoll_mod_wait. It's described as below:
> >
> > NAME
> >        epoll_mod_wait - modify and wait for I/O events on an epoll file
> >                         descriptor
> >
> > SYNOPSIS
> >
> >        int epoll_mod_wait(int epfd, int flags,
> >                           int ncmds, struct epoll_mod_cmd *cmds,
> >                           struct epoll_wait_spec *spec);
> >
> > DESCRIPTION
> >
> >        The epoll_mod_wait() system call can be seen as an enhanced combination
> >        of several epoll_ctl(2) calls, which are followed by an epoll_pwait(2)
> >        call. It is superior in two cases:
> >
> >        1) When epoll_ctl(2) are followed by epoll_wait(2), using epoll_mod_wait
> >        will save context switches between user mode and kernel mode;
> >
> >        2) When you need higher precision than microsecond for wait timeout.
> >
> >        The epoll_ctl(2) operations are embedded into this call by with ncmds
> >        and cmds. The latter is an array of command structs:
> >
> >            struct epoll_mod_cmd {
> >
> >                   /* Reserved flags for future extension, must be 0 for now. */
> >                   int flags;
> >
> >                   /* The same as epoll_ctl() op parameter. */
> >                   int op;
> >
> >                   /* The same as epoll_ctl() fd parameter. */
> >                   int fd;
> >
> >                   /* The same as the "events" field in struct epoll_event. */
> >                   uint32_t events;
> >
> >                   /* The same as the "data" field in struct epoll_event. */
> >                   uint64_t data;
> >
> >                   /* Output field, will be set to the return code once this
> >                    * command is executed by kernel */
> >                   int error;
> >            };
> 
> I would add an extra u32 at the end so that the structure size will be
> a multiple of 8 bytes on all platforms.

*shrug*, but if you do so, enforce that it has a value of 0 or return
-EINVAL, just like a flags field.  Alternatively, move the last field
earlier and make flags a uint64_t.

- Josh Triplett
