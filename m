From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v7 3/9] seccomp: introduce writer locking
Date: Tue, 24 Jun 2014 18:52:16 +0200
Message-ID: <20140624165216.GA29272@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <1403560693-21809-4-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403560693-21809-4-git-send-email-keescook@chromium.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Kees,

I am still trying to force myself to read and try to understand what
this series does ;) Just a minor nit so far.

On 06/23, Kees Cook wrote:
>
> @@ -1142,6 +1168,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  {
>  	int retval;
>  	struct task_struct *p;
> +	unsigned long irqflags;
>  
>  	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
>  		return ERR_PTR(-EINVAL);
> @@ -1196,7 +1223,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  		goto fork_out;
>  
>  	ftrace_graph_init_task(p);
> -	get_seccomp_filter(p);
>  
>  	rt_mutex_init_task(p);
>  
> @@ -1434,7 +1460,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  		p->parent_exec_id = current->self_exec_id;
>  	}
>  
> -	spin_lock(&current->sighand->siglock);
> +	spin_lock_irqsave(&current->sighand->siglock, irqflags);
> +
> +	/*
> +	 * Copy seccomp details explicitly here, in case they were changed
> +	 * before holding tasklist_lock.
> +	 */
> +	copy_seccomp(p);
>  
>  	/*
>  	 * Process group and session signals need to be delivered to just the
> @@ -1446,7 +1478,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	*/
>  	recalc_sigpending();
>  	if (signal_pending(current)) {
> -		spin_unlock(&current->sighand->siglock);
> +		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
>  		write_unlock_irq(&tasklist_lock);
>  		retval = -ERESTARTNOINTR;
>  		goto bad_fork_free_pid;
> @@ -1486,7 +1518,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	}
>  
>  	total_forks++;
> -	spin_unlock(&current->sighand->siglock);
> +	spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
>  	write_unlock_irq(&tasklist_lock);
>  	proc_fork_connector(p);
>  	cgroup_post_fork(p);

It seems that the only change copy_process() needs is copy_seccomp() under the locks.
Everythinh else (irqflags games) looks obviously unneeded?

> @@ -524,6 +528,9 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
>  	}
>  #endif
>
> +	if (unlikely(!lock_task_sighand(current, &irqflags)))
> +		goto out_free;
> +

Unless this task is exiting (namely, it has already called exit_notify()),
lock_task_sighand(current) must not fail. Looks like you can simly do
spin_lock_irq(->siglock).

Oleg.
