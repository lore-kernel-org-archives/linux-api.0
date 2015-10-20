From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v7] seccomp, ptrace: add support for dumping seccomp
 filters
Date: Tue, 20 Oct 2015 12:15:11 -0600
Message-ID: <20151020181511.GN3982@smitten>
References: <1444747626-8129-1-git-send-email-tycho.andersen@canonical.com>
 <1444747626-8129-2-git-send-email-tycho.andersen@canonical.com>
 <20151020180024.GA30486@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151020180024.GA30486-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Oleg,

On Tue, Oct 20, 2015 at 08:00:24PM +0200, Oleg Nesterov wrote:
> Sorry for delay...

No problem, thanks for the review.

> On 10/13, Tycho Andersen wrote:
> >
> > --- a/include/uapi/linux/ptrace.h
> > +++ b/include/uapi/linux/ptrace.h
> > @@ -23,6 +23,8 @@
> >
> >  #define PTRACE_SYSCALL		  24
> >
> > +#define PTRACE_SECCOMP_GET_FILTER	40
> 
> Probably it would be better to add this at the end of other 0x42..
> constants? After PTRACE_SETSIGMASK.

Ok, I'll switch it to 0x420c.

> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -347,6 +347,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
> >  {
> >  	struct seccomp_filter *sfilter;
> >  	int ret;
> > +	const bool save_orig = config_enabled(CONFIG_CHECKPOINT_RESTORE);
> >  
> >  	if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
> >  		return ERR_PTR(-EINVAL);
> > @@ -370,7 +371,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
> >  		return ERR_PTR(-ENOMEM);
> >  
> >  	ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
> > -					seccomp_check_filter, false);
> > +					seccomp_check_filter, save_orig);
> 
> Can't comment, this depends on other changes I missed... but I don't
> this you need my review here ;)
> 
> > +#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> > +long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
> > +			void __user *data)
> > +{
> > +	struct seccomp_filter *filter;
> > +	struct sock_fprog_kern *fprog;
> > +	long ret;
> > +	unsigned long count = 0;
> > +
> > +	spin_lock_irq(&current->sighand->siglock);
> > +	if (!capable(CAP_SYS_ADMIN) ||
> > +	    current->seccomp.mode != SECCOMP_MODE_DISABLED) {
> > +		ret = -EACCES;
> > +		goto out_self;
> > +	}
> > +
> > +	spin_lock_irq(&task->sighand->siglock);
> 
> Oh, no, you can't do this.
> 
> This is deadlockable. Suppose that this task's sub-thread traces the
> caller (the current task) and does PTRACE_SECCOMP_GET_FILTER too.
> 
> In this case it can take the same 2 locks in reverse order, deadlock.
> 
> But why do you need to hold both ->siglock's at the same time?

Based on some previous discussion, I don't think we need the current
task's lock at all really. The only reason I'm taking it here is
because we take it elsewhere in the code when we read
current->seccomp.mode, and both Kees and I were too paranoid to remove
it.

We could unlock right after we check the perms, but then a thread
which ptraced some task could inspect its filters at the same time as
a sibling was installing filters via TSYNC. I don't think this is
really a problem, but it's worth pointing out. If we're going to
unlock right after the checks, we probably don't need the current
task's lock at all.

Tycho
