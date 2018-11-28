From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH] procfd_signal.2: document procfd_signal syscall
Date: Wed, 28 Nov 2018 21:59:52 +0100
Message-ID: <87in0g7waf.fsf@oldenburg.str.redhat.com>
References: <20181119103241.5229-1-christian@brauner.io>
        <20181119103241.5229-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119103241.5229-4-christian@brauner.io> (Christian Brauner's
        message of "Mon, 19 Nov 2018 11:32:40 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> +.\" Copyright (C) 2018 Christian Brauner <christian@brauner.io>

The text seems to be largely derived from rt_sigqueueinfo, so I'm not
sure if this appropriate here.

> +the null signal (0) can be used to check if a process with a given
> +PID exists.

What does this mean if hte process is identified by file descriptor?

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

Obsolete reference in this context.

> +.TP
> +.B ESRCH
> +The process or process group does not exist.
> +Note that an existing process might be a zombie,
> +a process that has terminated execution, but
> +has not yet been
> +.BR wait (2)ed
> +for.

Again: What does this mean if the process identified by a descriptor?
Does a process in zombie state exist in this sense or not?

Thanks,
Florian
