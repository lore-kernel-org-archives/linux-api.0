From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task
	other than ourself
Date: Thu, 23 Jul 2009 09:47:53 -0500
Message-ID: <20090723144753.GA12416@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1248256822-23416-23-git-send-email-orenl@librato.com>
Sender: owner-linux-mm@kvack.org
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@openvz.org>, Alexey Dobriyan <adobriyan@gmail.com>, Oren Laadan <orenl@cs.columbia.edu>
List-Id: linux-api@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> +/* setup checkpoint-specific parts of ctx */
> +static int init_checkpoint_ctx(struct ckpt_ctx *ctx, pid_t pid)
> +{
> +	struct task_struct *task;
> +	struct nsproxy *nsproxy;
> +	int ret;
> +
> +	/*
> +	 * No need for explicit cleanup here, because if an error
> +	 * occurs then ckpt_ctx_free() is eventually called.
> +	 */
> +
> +	ctx->root_pid = pid;
> +
> +	/* root task */
> +	read_lock(&tasklist_lock);
> +	task = find_task_by_vpid(pid);
> +	if (task)
> +		get_task_struct(task);
> +	read_unlock(&tasklist_lock);
> +	if (!task)
> +		return -ESRCH;
> +	else
> +		ctx->root_task = task;
> +
> +	/* root nsproxy */
> +	rcu_read_lock();
> +	nsproxy = task_nsproxy(task);
> +	if (nsproxy)
> +		get_nsproxy(nsproxy);
> +	rcu_read_unlock();
> +	if (!nsproxy)
> +		return -ESRCH;
> +	else
> +		ctx->root_nsproxy = nsproxy;
> +
> +	/* root freezer */
> +	ctx->root_freezer = task;
> +	geT_task_struct(task);
> +
> +	ret = may_checkpoint_task(ctx, task);
> +	if (ret) {
> +		ckpt_write_err(ctx, NULL);
> +		put_task_struct(task);
> +		put_task_struct(task);
> +		put_nsproxy(nsproxy);

I don't think this is safe - the ckpt_ctx_free() will
free them a second time because you're not setting them
to NULL, right?

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +

-serge

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
