From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 12:35:44 +0200
Message-ID: <20190725103543.GF4707@redhat.com>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190724144651.28272-5-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/24, Christian Brauner wrote:
>
> If CLONE_WAIT_PID is set the newly created process will not be
> considered by process wait requests that wait generically on children
> such as:

I have to admit this feature looks a bit exotic to me...

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1019,6 +1019,9 @@ eligible_child(struct wait_opts *wo, bool ptrace, struct task_struct *p)
>  	if (!eligible_pid(wo, p))
>  		return 0;
>
> +	if ((p->flags & PF_WAIT_PID) && (wo->wo_type != PIDTYPE_PID))
> +		return 0;

Even if ptrace == T ?

This doesn't look right. Say, strace should work even if its tracee (or
one of the tracees) has PF_WAIT_PID.

Oleg.
