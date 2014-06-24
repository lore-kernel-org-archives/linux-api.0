From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v7 1/1] man-pages: seccomp.2: document syscall
Date: Tue, 24 Jun 2014 12:18:25 -0700
Message-ID: <CAGXu5j+E1DVp+BDwTaTdexcOhPC=COE+uHXtj7yGdi2ewkrTTA@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<20140623220150.GM5412@outflux.net>
	<CALCETrV=nAuWi8_Xj6KnJ6P1Yiaw36+n50-gHKaTgea4yH85Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV=nAuWi8_Xj6KnJ6P1Yiaw36+n50-gHKaTgea4yH85Eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 24, 2014 at 11:06 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Mon, Jun 23, 2014 at 3:01 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> Combines documentation from prctl, and in-kernel seccomp_filter.txt,
>> along with new details specific to the new syscall.
>>
>> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> ---
>>  man2/seccomp.2 |  333 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 333 insertions(+)
>>  create mode 100644 man2/seccomp.2
>>
>> diff --git a/man2/seccomp.2 b/man2/seccomp.2
>> new file mode 100644
>> index 0000000..de7fbf7
>> --- /dev/null
>> +++ b/man2/seccomp.2
>> @@ -0,0 +1,333 @@
>> +.\" Copyright (C) 2014 Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> +.\" and Copyright (C) 2012 Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
>> +.\" and Copyright (C) 2008 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> +.\"
>> +.\" %%%LICENSE_START(VERBATIM)
>> +.\" Permission is granted to make and distribute verbatim copies of this
>> +.\" manual provided the copyright notice and this permission notice are
>> +.\" preserved on all copies.
>> +.\"
>> +.\" Permission is granted to copy and distribute modified versions of this
>> +.\" manual under the conditions for verbatim copying, provided that the
>> +.\" entire resulting derived work is distributed under the terms of a
>> +.\" permission notice identical to this one.
>> +.\"
>> +.\" Since the Linux kernel and libraries are constantly changing, this
>> +.\" manual page may be incorrect or out-of-date.  The author(s) assume no
>> +.\" responsibility for errors or omissions, or for damages resulting from
>> +.\" the use of the information contained herein.  The author(s) may not
>> +.\" have taken the same level of care in the production of this manual,
>> +.\" which is licensed free of charge, as they might when working
>> +.\" professionally.
>> +.\"
>> +.\" Formatted or processed versions of this manual, if unaccompanied by
>> +.\" the source, must acknowledge the copyright and authors of this work.
>> +.\" %%%LICENSE_END
>> +.\"
>> +.TH SECCOMP 2 2014-06-23 "Linux" "Linux Programmer's Manual"
>> +.SH NAME
>> +seccomp \-
>> +operate on Secure Computing state of the process
>> +.SH SYNOPSIS
>> +.nf
>> +.B #include <linux/seccomp.h>
>> +.B #include <linux/filter.h>
>> +.B #include <linux/audit.h>
>> +.B #include <linux/signal.h>
>> +.B #include <sys/ptrace.h>
>> +
>> +.BI "int seccomp(unsigned int " operation ", unsigned int " flags ,
>> +.BI "            unsigned char *" args );
>
> At the very least, shouldn't this be void *args?

Yeah, good point. Fixed for the next version...

-Kees

-- 
Kees Cook
Chrome OS Security
