From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 1/2] fork: add clone3
Date: Tue, 04 Jun 2019 10:28:12 +0100
Message-ID: <4020.1559640492@warthog.procyon.org.uk>
References: <20190603144331.16760-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190603144331.16760-1-christian@brauner.io>
Content-ID: <4019.1559640492.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jannh@google.com, keescook@chromium.org, fweimer@redhat.com, oleg@redhat.com, arnd@arndb.de, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> wrote:

> +#include <linux/compiler_types.h>

I suspect you don't want to include that directly.

Also, to avoid bloating linux/sched/task.h yet further, maybe put this in
linux/sched/clone.h?

> -extern long _do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *, unsigned long);
> +extern long _do_fork(struct kernel_clone_args *kargs);
>  extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);

Maybe these could move into linux/sched/clone.h too.

> +#define CLONE_MAX ~0U

Can you add a comment summarising the meaning?

> +	u64 clone_flags = args->flags;
> +	int __user *child_tidptr = args->child_tid;
> +	unsigned long tls = args->tls;
> +	unsigned long stack_start = args->stack;
> +	unsigned long stack_size = args->stack_size;

Some of these are only used once, so it's probably not worth sticking them in
local variables.

> -		if (clone_flags &
> -		    (CLONE_DETACHED | CLONE_PARENT_SETTID | CLONE_THREAD))
> -			return ERR_PTR(-EINVAL);

Did this error check get lost?  I can see part of it further on, but the check
on CLONE_PARENT_SETTID is absent.

> +	int __user *parent_tidptr = args->parent_tid;

There's only one usage remaining after this patch, so a local var doesn't gain
a lot.

>  pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
>  {
> -	return _do_fork(flags|CLONE_VM|CLONE_UNTRACED, (unsigned long)fn,
> -		(unsigned long)arg, NULL, NULL, 0);
> +	struct kernel_clone_args args = {
> +		.flags = ((flags | CLONE_VM | CLONE_UNTRACED) & ~CSIGNAL),
> +		.exit_signal = (flags & CSIGNAL),

Kernel threads can have exit signals?

> +static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
> +				     struct clone_args __user *uargs,
> +				     size_t size)

I would make this "noinline".  If it gets inlined, local variable "args" may
still be on the stack when _do_fork() gets called.

David
