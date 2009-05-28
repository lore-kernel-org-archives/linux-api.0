From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v16][PATCH 19/43] c/r: external checkpoint of a task other
	than ourself
Date: Thu, 28 May 2009 20:33:42 +0400
Message-ID: <20090528163342.GA18962@x200.localdomain>
References: <1243445589-32388-1-git-send-email-orenl@cs.columbia.edu> <1243445589-32388-20-git-send-email-orenl@cs.columbia.edu> <20090527211950.GA7855@x200.localdomain> <Pine.LNX.4.64.0905271831030.7284@takamine.ncl.cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905271831030.7284-CXF6herHY6ykSYb+qCZC/1i27PF6R63G9nwVQlTi/Pw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2009 at 06:32:28PM -0400, Oren Laadan wrote:
> On Thu, 28 May 2009, Alexey Dobriyan wrote:
> 
> > On Wed, May 27, 2009 at 01:32:45PM -0400, Oren Laadan wrote:
> > > Now we can do "external" checkpoint, i.e. act on another task.
> > 
> > > +static int may_checkpoint_task(struct ckpt_ctx *ctx, struct task_struct *t)
> > > +{
> > > +	if (t->state == TASK_DEAD) {
> > > +		pr_warning("c/r: task %d is TASK_DEAD\n", task_pid_vnr(t));
> > > +		return -EAGAIN;
> > > +	}
> > > +
> > > +	if (!ptrace_may_access(t, PTRACE_MODE_READ)) {
> > > +		__ckpt_write_err(ctx, "access to task %d (%s) denied",
> > > +				 task_pid_vnr(t), t->comm);
> > > +		return -EPERM;
> > > +	}
> > > +
> > > +	/* verify that the task is frozen (unless self) */
> > > +	if (t != current && !frozen(t)) {
> > > +		__ckpt_write_err(ctx, "task %d (%s) is not frozen",
> > > +				 task_pid_vnr(t), t->comm);
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	/* FIX: add support for ptraced tasks */
> > > +	if (task_ptrace(t)) {
> > > +		__ckpt_write_err(ctx, "task %d (%s) is ptraced",
> > > +				 task_pid_vnr(t), t->comm);
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int get_container(struct ckpt_ctx *ctx, pid_t pid)
> > > +{
> > > +	struct task_struct *task = NULL;
> > > +	struct nsproxy *nsproxy = NULL;
> > > +	int ret;
> > > +
> > > +	ctx->root_pid = pid;
> > > +
> > > +	read_lock(&tasklist_lock);
> > > +	task = find_task_by_vpid(pid);
> > > +	if (task)
> > > +		get_task_struct(task);
> > > +	read_unlock(&tasklist_lock);
> > > +
> > > +	if (!task)
> > > +		return -ESRCH;
> > > +
> > > +	ret = may_checkpoint_task(ctx, task);
> > > +	if (ret) {
> > > +		ckpt_write_err(ctx, NULL);
> > > +		put_task_struct(task);
> > > +		return ret;
> > > +	}
> > > +
> > > +	rcu_read_lock();
> > > +	nsproxy = task_nsproxy(task);
> > > +	get_nsproxy(nsproxy);
> > 
> > Will oops if init is multi-threaded and thread group leader exited
> > (nsproxy = NULL). I need to think what to do, too.
> 
> 
> ood catch. Since all threads share same nsproxy (except those
> who exits.. duh) we can test for this case, and get the nsproxy
> from any of the other threads, something like this (untested):

I don't know if such behaviour was intented, but threads have only common
pid_ns not whole nsproxy. CLONE_THREAD|CLONE_NEWUTS works just fine.

> --- a/checkpoint/checkpoint.c
> +++ b/checkpoint/checkpoint.c
> @@ -522,9 +522,33 @@ static int get_container(struct ckpt_ctx *ctx, pid_t pid)
>  
>  	rcu_read_lock();
>  	nsproxy = task_nsproxy(task);
> -	get_nsproxy(nsproxy);
> +	if (nsproxy)
> +		get_nsproxy(nsproxy);
>  	rcu_read_unlock();
>  
> +	/*
> +	 * If we hit a zombie thread-group-leader, nsproxy will be NULL,
> +	 * and we instead grab it from one of the other threads.
> +	 */
> +	if (!nsproxy) {
> +		struct task_struct *p = next_thread(task);
> +
> +		BUG_ON(task->state != TASK_DEAD);
> +		read_lock(&tasklist_lock);
> +		while (p != task && !task_nsproxy(p))
> +			p = next_thread(p);
> +		nsproxy = get_nsproxy(p);
> +		if (nsproxy)
> +			get_nsproxy(nsproxy);
> +		read_unlock(&tasklist_lock);
> +	}
> +
> +	/* still not ... too bad ... */
> +	if (!nsproxy) {
> +		put_task_struct(task);
> +		return -ESRCH;
> +	}
> +
>  	ctx->root_task = task;
>  	ctx->root_nsproxy = nsproxy;
>  	ctx->root_init = is_container_init(task);
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
