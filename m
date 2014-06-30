From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 5/5] man-pages: cap_rights_get: retrieve Capsicum fd rights
Date: Mon, 30 Jun 2014 15:28:14 -0700
Message-ID: <CALCETrW94NY+SNGsW3PYsdHfwpykPYs55FFDztQ2MVwMLmwJ4Q@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com> <1404124096-21445-17-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404124096-21445-17-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  man2/cap_rights_get.2 | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 126 insertions(+)
>  create mode 100644 man2/cap_rights_get.2
>
> diff --git a/man2/cap_rights_get.2 b/man2/cap_rights_get.2
> new file mode 100644
> index 000000000000..966c0ed7e336
> --- /dev/null
> +++ b/man2/cap_rights_get.2
> @@ -0,0 +1,126 @@
> +.\"
> +.\" Copyright (c) 2008-2010 Robert N. M. Watson
> +.\" Copyright (c) 2012-2013 The FreeBSD Foundation
> +.\" Copyright (c) 2013-2014 Google, Inc.
> +.\" All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(BSD_2_CLAUSE)
> +.\" Redistribution and use in source and binary forms, with or without
> +.\" modification, are permitted provided that the following conditions
> +.\" are met:
> +.\" 1. Redistributions of source code must retain the above copyright
> +.\"    notice, this list of conditions and the following disclaimer.
> +.\" 2. Redistributions in binary form must reproduce the above copyright
> +.\"    notice, this list of conditions and the following disclaimer in the
> +.\"    documentation and/or other materials provided with the distribution.
> +.\"
> +.\" THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
> +.\" ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> +.\" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> +.\" ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
> +.\" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> +.\" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> +.\" OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> +.\" HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> +.\" LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> +.\" OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> +.\" SUCH DAMAGE.
> +.\" %%%LICENSE_END
> +.\"
> +.TH CAP_RIGHTS_GET 2 2014-05-07 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +cap_rights_get \- retrieve Capsicum capability rights
> +.SH SYNOPSIS
> +.nf
> +.B #include <sys/capsicum.h>
> +.sp
> +.BI "int cap_rights_get(int " fd ", struct cap_rights *" rights ,
> +.BI "                   unsigned int *" fcntls ,
> +.BI "                   int *" nioctls ", unsigned int *" ioctls );
> +.SH DESCRIPTION
> +Obtain the current Capsicum capability rights for a file descriptor.
> +.PP
> +The function will fill the
> +.I rights
> +argument (if non-NULL) with the primary capability rights of the
> +.I fd
> +descriptor.  The result can be examined with the
> +.BR cap_rights_is_set (3)
> +family of functions.  The complete list of primary rights can be found in the
> +.BR rights (7)
> +manual page.
> +.PP
> +If the
> +.I fcntls
> +argument is non-NULL, it will be filled in with a bitmask of allowed
> +.BR fcntl (2)
> +commands; see
> +.BR cap_rights_limit (2)
> +for values.  If the file descriptor does not have the
> +.B CAP_FCNTL
> +primary right, the returned
> +.I fcntls
> +value will be zero.
> +.PP
> +If the
> +.I nioctls
> +argument is non-NULL, it will be filled in with the number of allowed
> +.BR ioctl (2)
> +commands, or with the value CAP_IOCTLS_ALL to indicate that all
> +.BR ioctl (2)
> +commands are allowed.  If the file descriptor does not have the
> +.B CAP_IOCTL
> +primary right, the returned
> +.I nioctls
> +value will be zero.
> +.PP
> +The
> +.I ioctls
> +argument (if non-NULL) should point at memory that can hold up to
> +.I nioctls
> +values.
> +The system call populates the provided buffer with up to
> +.I nioctls
> +elements, but always returns the total number of

I assume you mean "up to the initial value of *nioctls elements" or
something.  Can you clarify?

--Andy
