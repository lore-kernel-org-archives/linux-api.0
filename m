From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] procfd_signal.2: document procfd_signal syscall
Date: Tue, 20 Nov 2018 14:29:32 +0100
Message-ID: <adf719cc-856e-e3cb-8435-f1d9dac7c40f@gmail.com>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119103241.5229-4-christian@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, ebiederm@xmission.com, linux-kernel@vger.kernel.org
Cc: mtk.manpages@gmail.com, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello Christian,

On 11/19/18 11:32 AM, Christian Brauner wrote:
> Signed-off-by: Christian Brauner <christian@brauner.io>
> ---
> Changelog:
> v1:
> - patch introduced
> ---
>  man2/procfd_signal.2 | 147 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 147 insertions(+)
>  create mode 100644 man2/procfd_signal.2
> 
> diff --git a/man2/procfd_signal.2 b/man2/procfd_signal.2
> new file mode 100644
> index 000000000..6af0b74f4
> --- /dev/null
> +++ b/man2/procfd_signal.2
> @@ -0,0 +1,147 @@
> +.\" Copyright (C) 2018 Christian Brauner <christian@brauner.io>
> +.\"
> +.\" %%%LICENSE_START(VERBATIM)
> +.\" Permission is granted to make and distribute verbatim copies of this
> +.\" manual provided the copyright notice and this permission notice are
> +.\" preserved on all copies.
> +.\"
> +.\" Permission is granted to copy and distribute modified versions of this
> +.\" manual under the conditions for verbatim copying, provided that the
> +.\" entire resulting derived work is distributed under the terms of a
> +.\" permission notice identical to this one.
> +.\"
> +.\" Since the Linux kernel and libraries are constantly changing, this
> +.\" manual page may be incorrect or out-of-date.  The author(s) assume no
> +.\" responsibility for errors or omissions, or for damages resulting from
> +.\" the use of the information contained herein.  The author(s) may not
> +.\" have taken the same level of care in the production of this manual,
> +.\" which is licensed free of charge, as they might when working
> +.\" professionally.
> +.\"
> +.\" Formatted or processed versions of this manual, if unaccompanied by
> +.\" the source, must acknowledge the copyright and authors of this work.
> +.\" %%%LICENSE_END
> +.\"
> +.TH PROCFD_SIGNAL 2 2017-09-15 "Linux" "Linux Programmer's Manual"

Bad timestamp :-)

> +.SH NAME
> +procfd_signal \- send signal to a process through a process descriptor

s/through/via/

> +.SH SYNOPSIS
> +.nf
> +.B #include <sys/types.h>
> +.B #include <signal.h>
> +.PP
> +.BI "int procfd_signal(int " fd ", int " sig ", siginfo_t *" info ", int " flags );
> +.fi
> +.SH DESCRIPTION
> +.BR procfd_signal ()
> +sends the signal specified in
> +.I sig
> +to the process identified by the file descriptor
> +.IR fd .

Here, I think we need some words about how one obtains that 
file descriptor.

> +The permissions required to send a signal are the same as for
> +.BR kill (2).
> +As with
> +.BR kill (2),
> +the null signal (0) can be used to check if a process with a given
> +PID exists.

But there is no PID mentioned on this page?

I suppose:

As with
.BR kill (2),
the null signal (0) can be used to check if the process referred to by
.I fd
exists.

?

> +.PP
> +The optional
> +.I info
> +argument specifies the data to accompany the signal.
> +This argument is a pointer to a structure of type
> +.IR siginfo_t ,
> +described in
> +.BR sigaction (2)
> +(and defined by including
> +.IR <sigaction.h> ).
> +The caller should set the following fields in this structure:
> +.TP
> +.I si_code
> +This must be one of the
> +.B SI_*
> +codes in the Linux kernel source file
> +.IR include/asm-generic/siginfo.h ,
> +with the restriction that the code must be negative
> +(i.e., cannot be
> +.BR SI_USER ,
> +which is used by the kernel to indicate a signal sent by
> +.BR kill (2))
> +and cannot (since Linux 2.6.39) be
> +.BR SI_TKILL
> +(which is used by the kernel to indicate a signal sent using
> +.\" tkill(2) or
> +.BR tgkill (2)).
> +.TP
> +.I si_pid
> +This should be set to a process ID,
> +typically the process ID of the sender.
> +.TP
> +.I si_uid
> +This should be set to a user ID,
> +typically the real user ID of the sender.
> +.TP
> +.I si_value
> +This field contains the user data to accompany the signal.
> +For more information, see the description of the last
> +.RI ( "union sigval" )
> +argument of
> +.BR sigqueue (3).

With sigqueue(3), one sends only a signal plus accompanying
data. It is of course based on the lower level rt_sigqueueinfo(2).
The man page for that system call says:

    These system calls are not intended for  direct  application  use;
    they  are  provided to allow the implementation of sigqueue(3) and
    pthread_sigqueue(3).

Is procfd_signal() intended to be the API directly used from
user space? If it is, then I think there should be some
explanation of why there is a 'siginfo_t' argument (vis-à-vis
sigqueue(3), which makes do with just union sigval).
If procfd_signal() is not intended to be the API used directly
from user space, then I think there needs to be a paragraph
similar to the one in the rt_sigqueueinfo(2) page queoted above.

> +.PP
> +Internally, the kernel sets the
> +.I si_signo
> +field to the value specified in
> +.IR sig ,
> +so that the receiver of the signal can also obtain
> +the signal number via that field.
> +.PP
> +The
> +.I flags
> +argument is reserved for future extension and must be set to 0.
> +.PP
> +.SH RETURN VALUE
> +On success, this system call returns 0.
> +On error, it returns \-1 and
> +.I errno
> +is set to indicate the error.
> +.SH ERRORS
> +.TP
> +.B EBADF
> +.I fd
> +is not a valid file descriptor.
> +.TP
> +.B EINVAL
> +An invalid signal was specified.
> +.TP
> +.B EINVAL
> +.I fd
> +does not refer to a process.
> +.TP
> +.B EINVAL
> +The flags argument was not 0.
> +.TP
> +.B EPERM
> +The caller does not have permission to send the signal to the target.
> +For the required permissions, see
> +.BR kill (2).
> +Or:
> +.I uinfo->si_code
> +is invalid.
> +.TP
> +.B ESRCH
> +The process or process group does not exist.

"or process group"? I suspect a cut and paste error here :-)

The connection between the preceding sentence and the one
that follows it is not quite clear:

> +Note that an existing process might be a zombie,
> +a process that has terminated execution, but
> +has not yet been
> +.BR wait (2)ed
> +for.

Is it the case that using procfd_signal() with a file
descriptor that refers to a zombie will yield EINVAL?
If yes, this could be made clearer with the following:

.B ESRCH
The specified process no longer exists or is a process in the
zombie state (a process that has terminated execution, but
has not yet been
BR wait (2)ed
for).

> +.SH CONFORMING TO
> +This system call is Linux-specific.
> +.SH SEE ALSO
> +.BR kill (2),
> +.BR sigaction (2),
> +.BR sigprocmask (2),
> +.BR tgkill (2),
> +.BR pthread_sigqueue (3),
> +.BR rt_sigqueueinfo (2),
> +.BR sigqueue (3),
> +.BR signal (7)

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
