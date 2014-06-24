From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v7 1/1] man-pages: seccomp.2: document syscall
Date: Tue, 24 Jun 2014 11:06:20 -0700
Message-ID: <CALCETrV=nAuWi8_Xj6KnJ6P1Yiaw36+n50-gHKaTgea4yH85Eg@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <20140623220150.GM5412@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140623220150.GM5412@outflux.net>
Sender: linux-security-module-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 23, 2014 at 3:01 PM, Kees Cook <keescook@chromium.org> wrote:
> Combines documentation from prctl, and in-kernel seccomp_filter.txt,
> along with new details specific to the new syscall.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  man2/seccomp.2 |  333 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 333 insertions(+)
>  create mode 100644 man2/seccomp.2
>
> diff --git a/man2/seccomp.2 b/man2/seccomp.2
> new file mode 100644
> index 0000000..de7fbf7
> --- /dev/null
> +++ b/man2/seccomp.2
> @@ -0,0 +1,333 @@
> +.\" Copyright (C) 2014 Kees Cook <keescook@chromium.org>
> +.\" and Copyright (C) 2012 Will Drewry <wad@chromium.org>
> +.\" and Copyright (C) 2008 Michael Kerrisk <mtk.manpages@gmail.com>
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
> +.TH SECCOMP 2 2014-06-23 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +seccomp \-
> +operate on Secure Computing state of the process
> +.SH SYNOPSIS
> +.nf
> +.B #include <linux/seccomp.h>
> +.B #include <linux/filter.h>
> +.B #include <linux/audit.h>
> +.B #include <linux/signal.h>
> +.B #include <sys/ptrace.h>
> +
> +.BI "int seccomp(unsigned int " operation ", unsigned int " flags ,
> +.BI "            unsigned char *" args );

At the very least, shouldn't this be void *args?

--Andy
