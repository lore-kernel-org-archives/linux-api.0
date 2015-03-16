From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file
 descriptor
Date: Mon, 16 Mar 2015 16:25:41 -0700
Message-ID: <20150316232541.GA31751@cloud>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <CAGXu5jLmLLgVNCP=cyUiXuiszVXsS88SNUK2iBqArbA2V6vdHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLmLLgVNCP=cyUiXuiszVXsS88SNUK2iBqArbA2V6vdHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 16, 2015 at 02:44:20PM -0700, Kees Cook wrote:
> On Sun, Mar 15, 2015 at 12:59 AM, Josh Triplett <josh-iaAMLnmF4Un9QnwtaJ6UQQ@public.gmane.org=
g> wrote:
> > - Make poll on a CLONE_FD for an exited task also return POLLHUP, f=
or
> >   compatibility with FreeBSD's pdfork.  Thanks to David Drysdale fo=
r calling
> >   attention to pdfork.
>=20
> I think POLLHUP should be mentioned in the manpage (now it only
> mentions POLLIN).

Added for v3.

> >        CLONE_FD
> >               Return  a file descriptor associated with the new pro=
cess, stor=E2=80=90
> >               ing it in location clonefd in the parent's address sp=
ace.   When
> >               the new process exits, the file descriptor will becom=
e available
> >               for reading.
> >
> >               Unlike using  signalfd(2)  for  the  SIGCHLD  signal,=
  the  file
> >               descriptor  returned  by  clone4()  with the CLONE_FD=
 flag works
> >               even with SIGCHLD unblocked in one or more threads of=
 the parent
> >               process,  allowing  the  process  to have different h=
andlers for
> >               different child processes, such as those created by  =
a  library,
> >               without  introducing  race conditions around process-=
wide signal
> >               handling.
> >
> >               clonefd_flags may contain the following additional fl=
ags for use
> >               with CLONE_FD:
> >
> >
> >               O_CLOEXEC
> >                      Set  the  close-on-exec  flag on the new file =
descriptor.
> >                      See the description of the O_CLOEXEC flag in o=
pen(2)  for
> >                      reasons why this may be useful.
>=20
> This begs the question: what happens when all CLONE_FD fds for a
> process are closed? Will the parent get SIGCHLD instead, will it
> auto-reap, or will it be un-wait-able (I assume not this...)

Whether the parent gets SIGCHLD is determined only by what signal you
request in clone; if you clone with CLONE_FD | SIGCHLD (or
CLONE_AUTOREAP | CLONE_FD | SIGCHLD), you'll get notification via both
clonefd (if you have one) and signal (if you have a handler).  If you
pass a 0 signal (just CLONE_FD or CLONE_AUTOREAP | CLONE_FD), you'll
receive no signal, only the notification via clonefd.  Independently, i=
f
you have CLONE_AUTOREAP set, the process will autoreap.

Those are all orthogonal now.

If you close the clonefd, nothing special happens other than a
put_task_struct.  While this is conceptually somewhat like a pipe, the
data is actually generated at read time, so the task exit doesn't care
whether there's a live clonefd or not.  (Or, in the future, if there ar=
e
multiple live clonefds for the same process.)

> Looks promising!

Thanks!

And thanks for catching the manpage issue.  I'd definitely welcome any
comments you have on the implementation as well.

- Josh Triplett
