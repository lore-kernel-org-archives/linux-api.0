From: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2 0/7] epoll: Introduce new syscalls,
 epoll_ctl_batch and epoll_pwait1
Date: Thu, 5 Feb 2015 09:51:51 +0800
Message-ID: <20150205015151.GA27112@ad.nay.redhat.com>
References: <1423046213-7043-1-git-send-email-famz@redhat.com>
 <CALCETrV731w37pxM0fzFZ3HHkn=9uoJX0-Rj6XqOf+hCRfnx8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV731w37pxM0fzFZ3HHkn=9uoJX0-Rj6XqOf+hCRfnx8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Rashika Kheria <rashika.kheria-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <pe>
List-Id: linux-api@vger.kernel.org

On Wed, 02/04 13:38, Andy Lutomirski wrote:
> On Wed, Feb 4, 2015 at 2:36 AM, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 2) epoll_pwait1
> > ---------------
> >
> > NAME
> >        epoll_pwait1 - wait for an I/O event on an epoll file descriptor
> >
> > SYNOPSIS
> >
> >        #include <sys/epoll.h>
> >
> >        int epoll_pwait1(int epfd, int flags,
> >                         struct epoll_event *events,
> >                         int maxevents,
> >                         struct timespec *timeout,
> >                         struct sigargs *sig);
> >
> > DESCRIPTION
> >
> >        The epoll_pwait1 system call differs from epoll_pwait only in parameter
> >        types. The first difference is timeout, a pointer to timespec structure
> >        which allows nanosecond presicion; the second difference, which should
> >        probably be wrapper by glibc and only expose a sigset_t pointer as in
> >        pselect6.
> >
> >        If timeout is NULL, it's treated as if 0 is specified in epoll_pwait
> >        (return immediately). Otherwise it's converted to nanosecond scalar,
> >        again, with the same convention as epoll_pwait's timeout.
> 
> Is the timeout absolute or relative?

Relative. Will document it. We can add a first flag for absolute timeout later.

Thanks.

Fam
> 
> I'd kind of like the ability to set timeouts on multiple clocks at the
> same time, but I can live without that.

Please see my reply to Michael.

Fam
