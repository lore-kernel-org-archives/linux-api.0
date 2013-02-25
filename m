From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without
 removing from a queue (v2)
Date: Mon, 25 Feb 2013 14:12:34 -0800
Message-ID: <20130225141234.99b76738.akpm@linux-foundation.org>
References: <1361786813-14652-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361786813-14652-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 25 Feb 2013 14:06:53 +0400
Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:

> This patch adds a new ptrace request PTRACE_PEEKSIGINFO.
> 
> This request is used to retrieve information about signals starting with
> the specified sequence number. Siginfo_t structures are copied from the
> child into the buffer starting at "data".
> 
> The argument "addr" is a pointer to struct ptrace_peeksiginfo_args.
> struct ptrace_peeksiginfo_args {
> 	u64 off;	/* from which siginfo to start */
> 	u32 nr;		/* how may siginfos to take */
> 	u32 flags;
> };
> 
> Currently here is only one flag PTRACE_PEEKSIGINFO_SHARED for dumping
> signals from process-wide shared queue. If this flag is not set, a
> signal is read from a per-thread queue.  A result siginfo contains a
> kernel part of si_code which usually striped, but it's required for
> queuing the same siginfo back during restore of pending signals.
> 
> The request PTRACE_PEEKSIGINFO returns a number of dumped signals.
> If a signal with the specified sequence number doesn't exist, ptrace
> returns 0.
> 
> This functionality is required for checkpointing pending signals.
> 
> The prototype of this code was developed by Oleg Nesterov.
> 
> v2: * don't wrapped on CONFIG_CHECKPOINT_RESTORE. This functionality is
>       going to be used in gdb.

That this will be used by gdb is useful information.  Please expand
upon this within the main changelog.

>     * use ptrace_peeksiginfo_args, because addr is too small for
>       encoding a signal number and flags.
> 
> Cc: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Would like an Oleg ack, please.

>
> ...
>
> @@ -618,6 +619,77 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
>  	return error;
>  }
>  
> +static int ptrace_peek_siginfo(struct task_struct *child,
> +				unsigned long addr,
> +				unsigned long data)
> +{
> +	struct ptrace_peeksiginfo_args arg;
> +	struct sigpending *pending;
> +	struct sigqueue *q;
> +	siginfo_t info;
> +	long long off;
> +	int ret, i;
> +
> +	ret = copy_from_user(&arg, (void __user *) addr,
> +				sizeof(struct ptrace_peeksiginfo_args));
> +	if (ret)
> +		return ret;

return -EFAULT;

> +	if (arg.flags & PTRACE_PEEKSIGINFO_SHARED)
> +		pending = &child->signal->shared_pending;
> +	else
> +		pending = &child->pending;
>
> +	if (arg.flags & ~PTRACE_PEEKSIGINFO_SHARED)
> +		return -EINVAL; /* unknown flags */

You could perform this test before the previous one and save an
unmeasurably small amount of CPU time in circumstances which never
happen!

> +	for (i = 0; i < arg.nr; i++) {
> +		off = arg.off + i;

"long long" = "u64" + "int".

Wanna have a little think about what we're doing here, see if we can
pick the most appropriate types?

`off' could be made local to this loop, which is a bit neater.

> +		spin_lock_irq(&child->sighand->siglock);
> +		list_for_each_entry(q, &pending->list, list) {
> +			if (!off--) {
> +				copy_siginfo(&info, &q->info);
> +				break;
> +			}
> +		}
> +		spin_unlock_irq(&child->sighand->siglock);
> +
> +		if (off >= 0)
> +			break;

<scratches head>

Oh I see what you did there - the user requested an entry which is
beyond the end of the list?  A code comment would be nice.

What's the return value in this case?  "i".  So how does userspace find
out what happened?

Please fully describe the interface so things such as this can be
understood.

> +#ifdef CONFIG_COMPAT
> +		if (unlikely(is_compat_task())) {
> +			compat_siginfo_t __user *uinfo = compat_ptr(data);
> +
> +			ret = copy_siginfo_to_user32(uinfo, &info);
> +			if (!ret)
> +				ret = __put_user(info.si_code, &uinfo->si_code);
> +		} else
> +#endif
> +		{
> +			siginfo_t __user *uinfo = (siginfo_t __user *) data;
> +
> +			ret = copy_siginfo_to_user(uinfo, &info);
> +			if (!ret)
> +				ret = __put_user(info.si_code, &uinfo->si_code);
> +		}
> +
> +		if (ret)
> +			break;
> +
> +		data += sizeof(siginfo_t);
> +
> +		if (signal_pending(current)) {
> +			i++;

What does the i++ do?

> +			break;
> +		}
> +
> +		cond_resched();
> +	}
> +
> +	return i ? : ret;

I hate that gcc thing :(

Also, is it buggy?  `ret' might be -EFAULT here.  We appear to be using
read() return semantics here?

Please, document the interface *completely* so that others can review
the design and can then check that the implementation matches that
design.  As it stands, we're reduced to mind-reading.


> +}
>
> ...
>
