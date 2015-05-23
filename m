From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 1/8] kernel/exit.c: make sure current's nsproxy != NULL while checking caps
Date: Sat, 23 May 2015 12:49:27 -0500
Message-ID: <878ucf2nh4.fsf@x220.int.ebiederm.org>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
	<1432209222-8479-2-git-send-email-l.pawelczyk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432209222-8479-2-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
	(Lukasz Pawelczyk's message of "Thu, 21 May 2015 13:53:35 +0200")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Nick
List-Id: linux-api@vger.kernel.org


Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> writes:

> There is a rare case where current's nsproxy might be NULL but we are
> required to check for credentials and capabilities. It sometimes happens
> during an exit_group() syscall while destroying user's session (logging
> out).
>
> My understanding is that while we have to lock the task to get task's
> nsproxy and check whether it's NULL, for the 'current' we don't have to
> and it's expected not to be NULL. There is a code in the kernel
> currently that does current->nsproxy->user_ns without any checks.
> And include/linux/nsproxy.h confirms that:
>
> 2. when accessing (i.e. reading) current task's namespaces - no
>    precautions should be taken - just dereference the pointers
>
> There seem to be no crash currently because of this, but with accessing
> nsproxy from LSM hooks there is. This is the backtrace:
>
> 0  smk_tskacc (task=0xffff88003b0b92e0, obj_known=0x2 <irq_stack_union+2>, mode=2, a=0xffff88003be53dd8) at security/smack/smack_access.c:261
> 1  0xffffffff8130e2aa in smk_curacc (obj_known=<optimized out>, mode=<optimized out>, a=<optimized out>) at security/smack/smack_access.c:318
> 2  0xffffffff8130a50d in smack_task_kill (p=0xffff88003b0b92e0, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/smack/smack_lsm.c:2071
> 3  0xffffffff812ea4f6 in security_task_kill (p=<optimized out>, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/security.c:952
> 4  0xffffffff8109ac80 in check_kill_permission (sig=15, info=0x0 <irq_stack_union>, t=0xffff88003b0b8000) at kernel/signal.c:796
> 5  0xffffffff8109d3ab in group_send_sig_info (sig=15, info=0x0 <irq_stack_union>, p=0xffff88003b0b8000) at kernel/signal.c:1296
> 6  0xffffffff8108e527 in forget_original_parent (father=<optimized out>) at kernel/exit.c:575
> 7  exit_notify (group_dead=<optimized out>, tsk=<optimized out>) at kernel/exit.c:606
> 8  do_exit (code=<optimized out>) at kernel/exit.c:775
> 9  0xffffffff8108ec0f in do_group_exit (exit_code=0) at kernel/exit.c:891
> 10 0xffffffff8108ec84 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:902
> 11 SyS_exit_group (error_code=<optimized out>) at kernel/exit.c:900
>
> This backtrace clearly shows that there is an LSM hook task_kill() that
> happens during an exit_group() syscall and that this happens after
> exit_task_namespaces(). LSM hooks with namespaces might need nsproxy to
> be able to check for capabilities. At this point this is impossible. The
> current's nsproxy is already NULL/destroyed.
>
> This is the case because exit_task_namespaces() is called before the
> exit_notify() where all of the above happens. This patch changes their
> order.

Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

current->nsproxy->user_ns does not exist,
and changing where exit_task_namespaces is fragile and I am really not
interested in messing with it right now, to solve a problem that does
not exist.

>
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  kernel/exit.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 22fcc05..da1bb18 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -742,7 +742,6 @@ void do_exit(long code)
>  	exit_fs(tsk);
>  	if (group_dead)
>  		disassociate_ctty(1);
> -	exit_task_namespaces(tsk);
>  	exit_task_work(tsk);
>  	exit_thread();
>  
> @@ -763,6 +762,13 @@ void do_exit(long code)
>  
>  	TASKS_RCU(tasks_rcu_i = __srcu_read_lock(&tasks_rcu_exit_srcu));
>  	exit_notify(tsk, group_dead);
> +
> +	/*
> +	 * This should be after all things that potentially require
> +	 * process's namespaces (e.g. capability checks).
> +	 */
> +	exit_task_namespaces(tsk);
> +
>  	proc_exit_connector(tsk);
>  #ifdef CONFIG_NUMA
>  	task_lock(tsk);
