From: Nathan Lynch <ntl@pobox.com>
Subject: Re: [RFC v12][PATCH 13/14] Checkpoint multiple processes
Date: Mon, 12 Jan 2009 17:14:52 -0600
Message-ID: <20090112231452.GC6850@localdomain>
References: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu>
 <1230542187-10434-14-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1230542187-10434-14-git-send-email-orenl@cs.columbia.edu>
Sender: owner-linux-mm@kvack.org
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, "H. Peter
 Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Mike Waychison <mikew@google.com>
List-Id: linux-api@vger.kernel.org

> +/* count number of tasks in tree (and optionally fill pid's in array) */
> +static int cr_tree_count_tasks(struct cr_ctx *ctx)
> +{
> +	struct task_struct *root = ctx->root_task;
> +	struct task_struct *task = root;
> +	struct task_struct *parent = NULL;
> +	struct task_struct **tasks_arr = ctx->tasks_arr;
> +	int tasks_nr = ctx->tasks_nr;
> +	int nr = 0;
> +
> +	read_lock(&tasklist_lock);
> +
> +	/* count tasks via DFS scan of the tree */
> +	while (1) {
> +		if (tasks_arr) {
> +			/* unlikely, but ... */
> +			if (nr == tasks_nr)
> +				return -EBUSY;	/* cleanup in cr_ctx_free() */

Returns without unlocking tasklist_lock?


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
