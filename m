From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 1/2] fork: add clone3
Date: Tue, 4 Jun 2019 11:43:18 +0200
Message-ID: <20190604094317.4wfelmbw4lgxzide@brauner.io>
References: <20190603144331.16760-1-christian@brauner.io>
 <4020.1559640492@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4020.1559640492@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jannh@google.com, keescook@chromium.org, fweimer@redhat.com, oleg@redhat.com, arnd@arndb.de, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jun 04, 2019 at 10:28:12AM +0100, David Howells wrote:
> Christian Brauner <christian@brauner.io> wrote:
> 
> > +#include <linux/compiler_types.h>
> 
> I suspect you don't want to include that directly.
> 
> Also, to avoid bloating linux/sched/task.h yet further, maybe put this in
> linux/sched/clone.h?

Yeah, not the worst idea.
Though I'd leave the flags where they are and just add struct
kernel_clone_args in there. But I assume that's what you meant anyway.

> 
> > -extern long _do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *, unsigned long);
> > +extern long _do_fork(struct kernel_clone_args *kargs);
> >  extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
> 
> Maybe these could move into linux/sched/clone.h too.

Meh, that could be a separate cleanup patch after clone3() has been
merged.

> 
> > +#define CLONE_MAX ~0U
> 
> Can you add a comment summarising the meaning?

Yes, can do.

> 
> > +	u64 clone_flags = args->flags;
> > +	int __user *child_tidptr = args->child_tid;
> > +	unsigned long tls = args->tls;
> > +	unsigned long stack_start = args->stack;
> > +	unsigned long stack_size = args->stack_size;
> 
> Some of these are only used once, so it's probably not worth sticking them in
> local variables.

[1]:
Ok, will double check.
This was just to minimize copy-paste erros for variables which were used
multiple times.

> 
> > -		if (clone_flags &
> > -		    (CLONE_DETACHED | CLONE_PARENT_SETTID | CLONE_THREAD))
> > -			return ERR_PTR(-EINVAL);
> 
> Did this error check get lost?  I can see part of it further on, but the check
> on CLONE_PARENT_SETTID is absent.

No, it's only relevant for legacy clone() since it uses the
parent_tidptr argument to return the pidfd. clone3() has a dedicated
return argument for that in clone_args.
The check for legacy clone() is now done in legacy clone() directly.
copy_process() should only do generic checks for all version of
clone(),fork(),vfork(), etc.

> 
> > +	int __user *parent_tidptr = args->parent_tid;
> 
> There's only one usage remaining after this patch, so a local var doesn't gain
> a lot.

Yes, that leads back to [1].

> 
> >  pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
> >  {
> > -	return _do_fork(flags|CLONE_VM|CLONE_UNTRACED, (unsigned long)fn,
> > -		(unsigned long)arg, NULL, NULL, 0);
> > +	struct kernel_clone_args args = {
> > +		.flags = ((flags | CLONE_VM | CLONE_UNTRACED) & ~CSIGNAL),
> > +		.exit_signal = (flags & CSIGNAL),
> 
> Kernel threads can have exit signals?

Yes,

kernel/kthread.c:       pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
kernel/umh.c:   pid = kernel_thread(call_usermodehelper_exec_async, sub_info, SIGCHLD);

And even if they couldn't have. This is just to make sure that if they
ever would we'd be prepared.

> 
> > +static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
> > +				     struct clone_args __user *uargs,
> > +				     size_t size)
> 
> I would make this "noinline".  If it gets inlined, local variable "args" may
> still be on the stack when _do_fork() gets called.

Hm, can do.

Thanks!
Christian
