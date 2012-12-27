From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] setns.2: Document the pid, user, and mount namespace support.
Date: Thu, 27 Dec 2012 12:08:51 +0100
Message-ID: <CAKgNAkiaw5L_oNE8NENjmoBS8Hq_uj+iaEdhyXc1+hje4HdnNQ@mail.gmail.com>
References: <87a9u4rmz0.fsf@xmission.com> <87k3t7q39u.fsf@xmission.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87k3t7q39u.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Eric,

Some questions below.

On Tue, Nov 27, 2012 at 1:48 AM, Eric W. Biederman
<ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> ---
>  man2/setns.2 |   41 +++++++++++++++++++++++++++++++++--------
>  1 files changed, 33 insertions(+), 8 deletions(-)
>
> diff --git a/man2/setns.2 b/man2/setns.2
> index 6aa01e1..63b04dc 100644
> --- a/man2/setns.2
> +++ b/man2/setns.2
> @@ -48,6 +48,18 @@ must refer to a network namespace.
>  .BR CLONE_NEWUTS
>  .I fd
>  must refer to a UTS namespace.
> +.TP
> +.BR CLONE_NEWPID
> +.I fd
> +must refer to a PID namespace.
> +.TP
> +.BR CLONE_NEWUSER
> +.I fd
> +must refer to a user namespace.
> +.TP
> +.BR CLONE_NEWNS
> +.I fd
> +must refer to a mount namespace.
>  .PP
>  Specifying
>  .I nstype
> @@ -63,6 +75,25 @@ and wants to ensure that the namespace is of a particular type.
>  .IR fd
>  if the file descriptor was opened by another process and, for example,
>  passed to the caller via a UNIX domain socket.)
> +
> +The pid namespace is a little different.  Reassociating the calling
> +thread with a pid namespace only changes the pid namespace that the
> +child processes will be created in.
> +
> +Changing the pid namespace for child processes is only allowed if the
> +pid namespace specified by
> +.IR fd
> +is a child pid namespace of the pid namespace of the current thread.

I assume "current thread" above should be "calling thread", right?

> +
> +A multi-threaded process may not change user namespace with setns.  A
> +process may not reassociate the thread with the current user
> +namespace.

What do you mean by "the current user nsamesapce"?

> The process reassociating itself with a user namespace
> +must have CAP_SYS_ADMIN privileges in the target user namespace.
> +
> +A process may not be reassociated with a new mount namespace if it is
> +multi-threaded

I tried to verify the precdeing two lines from the kernel source, but
did not work out where this check is made. Where is it?

> or it does not possess both CAP_SYS_CHROOT privileges
> +and CAP_SYS_ADMIN rights over the target mount namespace.

Could you please expand/clarify the preceding two lines. As they
stand, I don't really understand them.

>  .SH RETURN VALUE
>  On success,
>  .IR setns ()
> @@ -94,7 +125,8 @@ for this operation.
>  The
>  .BR setns ()
>  system call first appeared in Linux in kernel 3.0;
> -library support was added to glibc in version 2.14.
> +library support was added to glibc in version 2.14;
> +Support for PID, user and mount namespaces first appeard in Linux in kernel 3.8.
>  .SH CONFORMING TO
>  The
>  .BR setns ()
> @@ -106,13 +138,6 @@ a new thread is created using
>  can be changed using
>  .BR setns ().
>  .SH BUGS
> -The PID namespace and the mount namespace are not currently supported.
> -(See the descriptions of
> -.BR CLONE_NEWPID
> -and
> -.BR CLONE_NEWNS
> -in
> -.BR clone (2).)
>  .SH SEE ALSO
>  .BR clone (2),
>  .BR fork (2),

Cheers,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
