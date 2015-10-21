From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] seccomp, ptrace: add support for dumping seccomp
	filters
Date: Wed, 21 Oct 2015 20:51:46 +0200
Message-ID: <20151021185146.GA27176@redhat.com>
References: <1445370612-18843-1-git-send-email-tycho.andersen@canonical.com> <1445370612-18843-2-git-send-email-tycho.andersen@canonical.com> <20151020202024.GA5772@redhat.com> <20151020220814.GA3232@hopstrocity>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151020220814.GA3232@hopstrocity>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/20, Tycho Andersen wrote:
>
> Hi Kees, Oleg,
>
> On Tue, Oct 20, 2015 at 10:20:24PM +0200, Oleg Nesterov wrote:
> >
> > No, you can't do copy_to_user() from atomic context. You need to pin this
> > filter, drop the lock/irq, then copy_to_user().
>
> Attached is a patch which addresses this.

Looks good to me, feel free to add my reviewed-by.


a couple of questions, I am just curious...

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
> +		goto out;
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
> +		goto out;
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

Yes. but this looks a bit confusing. If we want this WARN_ON() check
because we are paranoid, then we should do

	WARN_ON(count != 1 || filter);

And "while we're using it" look misleading, we rely on ->siglock.

Plus if we could be shrinked the additional check can't help anyway,
we can used the free filter. So I don't really understand this check
and "filter != NULL" in the previous "while (filter && count > 1)".
Nevermind...

The question is:

> +	fprog = filter->prog->orig_prog;
> +	if (!fprog) {

So is it possible or not? I didn't see the previous changes which
added "bool save" to seccomp_attach_filter() so I simply can't know.

Now,

> +		/* This must be a new non-cBPF filter, since we save every
> +		 * every cBPF filter's orig_prog above when
> +		 * CONFIG_CHECKPOINT_RESTORE is enabled.
> +		 */
> +		ret = -EMEDIUMTYPE;

If this is possible, then probably we should simply change both
"while (filter)" loops above to skip a filter if orig_prog == NULL
and remove the -EMEDIUMTYPE code ?

Or what? Probably "a new non-cBPF filter" answers my question,
but I do not know what this cBPF/non-cBPF actually means ;)

In short. Who can attach a filter without "save => true" ?

Oleg.
