From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/3] clone3: allow spawning processes into cgroups
Date: Tue, 7 Jan 2020 08:32:04 -0800
Message-ID: <20200107163204.GB2677547@devbig004.ftw2.facebook.com>
References: <20191223061504.28716-1-christian.brauner@ubuntu.com>
 <20191223061504.28716-3-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191223061504.28716-3-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 23, 2019 at 07:15:03AM +0100, Christian Brauner wrote:
> +static struct cgroup *cgroup_get_from_file(struct file *f)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct cgroup *cgrp;
> +
> +	css = css_tryget_online_from_dir(f->f_path.dentry, NULL);
> +	if (IS_ERR(css))
> +		return ERR_CAST(css);
> +
> +	cgrp = css->cgroup;
> +	if (!cgroup_on_dfl(cgrp)) {
> +		cgroup_put(cgrp);
> +		return ERR_PTR(-EBADF);
> +	}
> +
> +	return cgrp;
> +}

It's minor but can you put this refactoring into a separate patch?

...
> +static int cgroup_css_set_fork(struct task_struct *parent,
> +			       struct kernel_clone_args *kargs)
> +	__acquires(&cgroup_mutex) __acquires(&cgroup_threadgroup_rwsem)
> +{
> +	int ret;
> +	struct cgroup *dst_cgrp = NULL, *src_cgrp;
> +	struct css_set *cset;
> +	struct super_block *sb;
> +	struct file *f;
> +
> +	if (kargs->flags & CLONE_INTO_CGROUP) {
> +		ret = mutex_lock_killable(&cgroup_mutex);
> +		if (ret)
> +			return ret;
> +	}

I don't think this is necessary.  cgroup_mutex should always only be
held for a finite enough time; otherwise, processes would get stuck on
random cgroupfs accesses or even /proc/self/cgroup.

...
> +	spin_lock_irq(&css_set_lock);
> +	src_cgrp = task_cgroup_from_root(parent, &cgrp_dfl_root);
> +	spin_unlock_irq(&css_set_lock);

You can simply do cset->dfl_root here, which is consistent with other
code paths which know that they want the dfl cgroup.

> +	ret = cgroup_attach_permissions(src_cgrp, dst_cgrp, sb,
> +					!!(kargs->flags & CLONE_THREAD));
> +	if (ret)
> +		goto err;

So, the existing perm check depends on the fact that for the write
operation to have started, it already should have passed write perm
check on the destination cgroup.procs file.  We're missing that here,
so we prolly need to check that explicitly.

> @@ -214,13 +215,21 @@ static void pids_cancel_attach(struct cgroup_taskset *tset)
> +static int pids_can_fork(struct task_struct *parent, struct task_struct *child,
> +			 struct kernel_clone_args *args)
>  {
> +	struct css_set *new_cset = NULL;
>  	struct cgroup_subsys_state *css;
>  	struct pids_cgroup *pids;
>  	int err;
>  
> -	css = task_css_check(current, pids_cgrp_id, true);
> +	if (args)
> +		new_cset = args->cset;
> +
> +	if (!new_cset)
> +		css = task_css_check(current, pids_cgrp_id, true);
> +	else
> +		css = new_cset->subsys[pids_cgrp_id];

Heh, this kinda sucks.  Would it be better to pass in the new css into
the callbacks rather than clone args?

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 2508a4f238a3..1604552f7cd3 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2165,16 +2165,15 @@ static __latent_entropy struct task_struct *copy_process(
>  	INIT_LIST_HEAD(&p->thread_group);
>  	p->task_works = NULL;
>  
> -	cgroup_threadgroup_change_begin(current);
>  	/*
>  	 * Ensure that the cgroup subsystem policies allow the new process to be
>  	 * forked. It should be noted the the new process's css_set can be changed
>  	 * between here and cgroup_post_fork() if an organisation operation is in
>  	 * progress.
>  	 */
> -	retval = cgroup_can_fork(p);
> +	retval = cgroup_can_fork(current, p, args);
>  	if (retval)
> -		goto bad_fork_cgroup_threadgroup_change_end;
> +		goto bad_fork_put_pidfd;
>  
>  	/*
>  	 * From this point on we must avoid any synchronous user-space

Maybe we can move these changes into a prep patch together with the
get_from_file change so that this patch only contains the actual
feature implementation?

Other than that, looks good to me.  Once the above review points are
addressed and Oleg is okay with it, I'll be happy to route this
through the cgroup tree.

Thanks so much for working on this.  This is really cool.

-- 
tejun
