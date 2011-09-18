From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: rt_sigqueueinfo/rt_tgsigqueueinfo man page
Date: Sun, 18 Sep 2011 17:04:06 +0200
Message-ID: <CAKgNAkipOC3kcq3jXxTxpKDECXjwNwv_aRF5ycp6pUTMw8YhHg@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Stephan Mueller <stephan.mueller-fwYZOkdEjagAvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Thomas

Long ago (see below) you added the rt_tgsigqueueinfo() syscall, and
provided the essential documentation:

On Thu, Feb 26, 2009 at 2:35 PM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> w=
rote:
> sys_kill has a counterpart sys_tgkill which allows to send signals to
> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpar=
t.
>
> Aside of the asymetry it is a show stopper for migrating applications
> from other unix-alike RTOSes.
>
> The following patch series implements rt_tgsigqueueinfo and hooks it
> up for x86.
>
> Find below the raw documentation.
>
> Thanks,
>
> =A0 =A0 =A0 =A0tglx
> ----
>
> NAME
> =A0 =A0 =A0 rt_tgsigqueueinfo - Send signal information to a signal t=
o a thread
>
> SYNOPSIS
> =A0 =A0 =A0 long sys_rt_tgsigqueueinfo (int tgid, int tid, int sig, s=
iginfo_t *uinfo);
>
> DESCRIPTION
>
> =A0 =A0 =A0 rt_tgsigqueueinfo sends signal sig information uinfo to t=
he
> =A0 =A0 =A0 thread with the thread ID tid in the thread group tgid. =A0=
(By
> =A0 =A0 =A0 contrast, rt_sigqueueinfo(2) can only be used to send a s=
ignal
> =A0 =A0 =A0 info to a process (i.e., thread group) as a whole, and th=
e
> =A0 =A0 =A0 signal will be delivered to an arbitrary thread within th=
at
> =A0 =A0 =A0 process.)
>
> RETURN VALUE
>
> =A0 =A0 =A0 rt_tgsigqueueinfo returns 0 on success; otherwise,
> =A0 =A0 =A0 rt_sigqueueinfo returns one of the errors listed in the
> =A0 =A0 =A0 "Errors" section.
>
> ERRORS
> =A0 =A0 =A0 -EFAULT
> =A0 =A0 =A0 =A0 =A0 =A0 =A0An invalid value for uinfo was specified.
>
> =A0 =A0 =A0 -EINVAL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0An invalid TID, TGID or signal was specifi=
ed.
>
> =A0 =A0 =A0 -EPERM
> =A0 =A0 =A0 =A0 =A0 =A0 =A0Permission denied. =A0For the required per=
missions,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0see rt_sigqueueinfo(2).
>
> =A0 =A0 =A0 -ESRCH
> =A0 =A0 =A0 =A0 =A0 =A0 =A0No process with the specified thread ID an=
d thread group
> =A0 =A0 =A0 =A0 =A0 =A0 =A0ID exists.

I've incorporated that documentation into a new rt_sigqueueinfo(2) man
page that documents both rt_sigqueueinfo() and rt_tgsigqueueinfo(). If
you have a moment, could you take a brief look ("man -l <file">) to
see that everything seems sane?

Thanks,

Michael

=2E\" Copyright (c) 2002, 2011 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
=2E\"
=2E\" Permission is granted to make and distribute verbatim copies of t=
his
=2E\" manual provided the copyright notice and this permission notice a=
re
=2E\" preserved on all copies.
=2E\"
=2E\" Permission is granted to copy and distribute modified versions of=
 this
=2E\" manual under the conditions for verbatim copying, provided that t=
he
=2E\" entire resulting derived work is distributed under the terms of a
=2E\" permission notice identical to this one.
=2E\"
=2E\" Since the Linux kernel and libraries are constantly changing, thi=
s
=2E\" manual page may be incorrect or out-of-date.  The author(s) assum=
e no
=2E\" responsibility for errors or omissions, or for damages resulting =
from
=2E\" the use of the information contained herein.  The author(s) may n=
ot
=2E\" have taken the same level of care in the production of this manua=
l,
=2E\" which is licensed free of charge, as they might when working
=2E\" professionally.
=2E\"
=2E\" Formatted or processed versions of this manual, if unaccompanied =
by
=2E\" the source, must acknowledge the copyright and authors of this wo=
rk.
=2E\"
=2ETH RT_SIGQUEUEINFO 2 2011-09-18 "Linux" "Linux Programmer's Manual"
=2ESH NAME
rt_sigqueueinfo, rt_tgsigqueueinfo \- queue a signal and data
=2ESH SYNOPSIS
=2Enf
=2EBI "int rt_sigqueueinfo(pid_t " tgid ", int " sig ", siginfo_t *" ui=
nfo );
=2Esp
=2EBI "int rt_tgsigqueueinfo(pid_t " tgid ", pid_t " tid ", int " sig ,
=2EBI "                      siginfo_t *" uinfo );
=2Efi
=2ESH DESCRIPTION
The
=2EBR rt_sigqueueinfo()
and
=2EBR rt_tgsigqueueinfo()
system calls are the low-level interfaces used to send a signal plus da=
ta
to a process or thread.
The receiver of the signal can obtain the accompanying data
by establishing a signal handler with the
=2EBR sigaction (2)
=2EB SA_SIGINFO
flag.

These system calls are not intended for direct application use;
they are provided to allow the implementation of
=2EBR sigqueue (3)
and
=2EBR pthread_sigqueue (3).

The
=2EBR rt_sigqueueinfo()
system call sends the signal
=2EI sig
to the thread group with the ID
=2EIR tgid .
(The term "thread group" is synonomous with "process", and
=2EI tid
corresponds to the traditional UNIX process ID.)
The signal will be delivered to an arbitrary member of the thread group
(i.e., one of the threads that is not currently blocking the signal).

The
=2EI uinfo
argument specifies the data to accompany the signal.
This argument is a pointer to a structure of type
=2EIR siginfo_t ,
described in
=2EBR sigaction (2)
(and defined by including
=2EIR <sigaction.h> ).
The caller should set the following fields in this structure:
=2ETP
=2EI si_code
This must be one of the
=2EB SI_*
codes in the kernel source file
=2EIR include/asm-generic/siginfo.h ,
with the restriction that the code must be negative
(i.e., cannot be
=2EBR SI_USER ,
which is used by the kernel to indicate a signal sent by
=2EBR kill (2))
and cannot (since Linux 2.6.39) be
=2EBR SI_TKILL
(which is used by the kernel to indicate a signal sent using
=2E\" tkill(2) or
=2EBR tgkill (2)).
=2ETP
=2EI si_pid
This should be set to a process ID,
typically the process ID of the sender.
=2ETP
=2EI si_uid
This should be set to a user ID,
typically the real user ID of the sender.
=2ETP
=2EI si_value
This field contains the user data to accompany the signal.
=46or more information, see the description of the last
=2ERI ( "union sigval" )
argument of
=2EBR sigqueue (3).
=2EPP
Internally, the kernel sets the
=2EI si_signo
field to the value specified in
=2EIR sig ,
so that the receiver of the signal can also obtain
the signal number via that field.

The
=2EBR rt_tgsigueueinfo ()
system call is like
=2EBR rt_sigueueinfo (),
but sends the signal and data to the single thread
specified by the combination of
=2EIR tgid ,
a thread group ID,
and
=2EIR tid ,
a thread in that thread group.
=2ESH "RETURN VALUE"
On success, these system calls return 0.
On error, they return \-1 and
=2EI errno
is set to indicate the error.
=2ESH ERRORS
=2ETP
=2EB EAGAIN
The limit of signals which may be queued has been reached.
(See
=2EBR signal (7)
for further information.)
=2ETP
=2EB EINVAL
=2EIR sig ,
=2EIR tgid ,
or
=2EIR tid
was invalid.
=2ETP
=2EB EPERM
The caller does not have permission to send the signal to the target.
=46or the required permissions, see
=2EBR kill (2).
Or:
=2EI uinfo->si_code
is invalid.
=2ETP
=2EB ESRCH
=2EBR rt_sigqueinfo ():
No thread group matching
=2EI tgid
was found.
=2Ebr
=2EBR rt_rtsigqueinfo ():
No thread matching
=2EI tgid
and
=2EI tid
was found.
=2ESH VERSIONS
The
=2EBR rt_sigqueueinfo ()
system call was added to Linux in version 2.2.
The
=2EBR rt_tgsigqueueinfo ()
system call was added to Linux in version 2.6.31.
=2ESH "CONFORMING TO"
These system calls are Linux-specific.
=2ESH NOTES
Since these system calls are not intended for application use,
there are no glibc wrapper functions; use
=2EBR syscall (2)
in the unlikely case that you want to call them directly.

As with
=2EBR kill (2),
the null signal (0) can be used to check if the specified process
or thread exists.
=2ESH "SEE ALSO"
=2EBR kill (2),
=2EBR sigaction (2),
=2EBR sigprocmask (2),
=2EBR tgkill (2),
=2EBR pthread_sigqueue (3),
=2EBR sigqueue (3),
=2EBR signal (7)



--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
