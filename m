From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp
	filters
Date: Tue, 20 Oct 2015 22:20:24 +0200
Message-ID: <20151020202024.GA5772@redhat.com>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com> <1445370612-18843-2-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445370612-18843-2-git-send-email-tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/20, Tycho Andersen wrote:
>
> +long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
> +			void __user *data)
> +{
> +	struct seccomp_filter *filter;
> +	struct sock_fprog_kern *fprog;
> +	long ret;
> +	unsigned long count = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN) ||
> +	    current->seccomp.mode != SECCOMP_MODE_DISABLED) {
> +		return -EACCES;
> +	}
> +
> +	spin_lock_irq(&task->sighand->siglock);
> +	if (task->seccomp.mode != SECCOMP_MODE_FILTER) {
> +		ret = -EINVAL;
> +		goto out_task;
> +	}
> +
> +	filter = task->seccomp.filter;
> +	while (filter) {
> +		filter = filter->prev;
> +		count++;
> +	}
> +
> +	if (filter_off >= count) {
> +		ret = -ENOENT;
> +		goto out_task;
> +	}
> +	count -= filter_off;
> +
> +	filter = task->seccomp.filter;
> +	while (filter && count > 1) {
> +		filter = filter->prev;
> +		count--;
> +	}
> +
> +	if (WARN_ON(count != 1)) {
> +		/* The filter tree shouldn't shrink while we're using it. */
> +		ret = -ENOENT;
> +		goto out_task;
> +	}
> +
> +	fprog = filter->prog->orig_prog;
> +	if (!fprog) {
> +		/* This must be a new non-cBPF filter, since we save every
> +		 * every cBPF filter's orig_prog above when
> +		 * CONFIG_CHECKPOINT_RESTORE is enabled.
> +		 */
> +		ret = -EMEDIUMTYPE;
> +		goto out_task;
> +	}
> +
> +	ret = fprog->len;
> +	if (!data)
> +		goto out_task;
> +
> +	if (copy_to_user(data, fprog->filter, bpf_classic_proglen(fprog))) {
> +		ret = -EFAULT;
> +		goto out_task;
> +	}

Oh wait, I didn't notice this when I looked at v7.

No, you can't do copy_to_user() from atomic context. You need to pin this
filter, drop the lock/irq, then copy_to_user().

Oleg.
