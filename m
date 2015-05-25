From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/8] kernel/exit.c: make sure current's nsproxy != NULL
	while checking caps
Date: Mon, 25 May 2015 13:33:18 +0200
Message-ID: <1432553598.1781.4.camel@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
	<1432209222-8479-2-git-send-email-l.pawelczyk@samsung.com>
	<878ucf2nh4.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-reply-to: <878ucf2nh4.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Rafal Krypa <r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>co
List-Id: linux-api@vger.kernel.org

On sob, 2015-05-23 at 12:49 -0500, Eric W. Biederman wrote:
> Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> writes:
> 
> > There is a rare case where current's nsproxy might be NULL but we are
> > required to check for credentials and capabilities. It sometimes happens
> > during an exit_group() syscall while destroying user's session (logging
> > out).
> >
> > My understanding is that while we have to lock the task to get task's
> > nsproxy and check whether it's NULL, for the 'current' we don't have to
> > and it's expected not to be NULL. There is a code in the kernel
> > currently that does current->nsproxy->user_ns without any checks.
> > And include/linux/nsproxy.h confirms that:
> >
> > 2. when accessing (i.e. reading) current task's namespaces - no
> >    precautions should be taken - just dereference the pointers
> >
> > There seem to be no crash currently because of this, but with accessing
> > nsproxy from LSM hooks there is. This is the backtrace:
> >
> > 0  smk_tskacc (task=0xffff88003b0b92e0, obj_known=0x2 <irq_stack_union+2>, mode=2, a=0xffff88003be53dd8) at security/smack/smack_access.c:261
> > 1  0xffffffff8130e2aa in smk_curacc (obj_known=<optimized out>, mode=<optimized out>, a=<optimized out>) at security/smack/smack_access.c:318
> > 2  0xffffffff8130a50d in smack_task_kill (p=0xffff88003b0b92e0, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/smack/smack_lsm.c:2071
> > 3  0xffffffff812ea4f6 in security_task_kill (p=<optimized out>, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/security.c:952
> > 4  0xffffffff8109ac80 in check_kill_permission (sig=15, info=0x0 <irq_stack_union>, t=0xffff88003b0b8000) at kernel/signal.c:796
> > 5  0xffffffff8109d3ab in group_send_sig_info (sig=15, info=0x0 <irq_stack_union>, p=0xffff88003b0b8000) at kernel/signal.c:1296
> > 6  0xffffffff8108e527 in forget_original_parent (father=<optimized out>) at kernel/exit.c:575
> > 7  exit_notify (group_dead=<optimized out>, tsk=<optimized out>) at kernel/exit.c:606
> > 8  do_exit (code=<optimized out>) at kernel/exit.c:775
> > 9  0xffffffff8108ec0f in do_group_exit (exit_code=0) at kernel/exit.c:891
> > 10 0xffffffff8108ec84 in SYSC_exit_group (error_code=<optimized out>) at kernel/exit.c:902
> > 11 SyS_exit_group (error_code=<optimized out>) at kernel/exit.c:900
> >
> > This backtrace clearly shows that there is an LSM hook task_kill() that
> > happens during an exit_group() syscall and that this happens after
> > exit_task_namespaces(). LSM hooks with namespaces might need nsproxy to
> > be able to check for capabilities. At this point this is impossible. The
> > current's nsproxy is already NULL/destroyed.
> >
> > This is the case because exit_task_namespaces() is called before the
> > exit_notify() where all of the above happens. This patch changes their
> > order.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> 
> current->nsproxy->user_ns does not exist,
> and changing where exit_task_namespaces is fragile and I am really not
> interested in messing with it right now, to solve a problem that does
> not exist.

I must have missed the moment where current->nsproxy->user_ns was
removed. I obviously even don't use it in my patches anymore (replaced
with cred->user_ns).

Back when I started to write my patches and wanted to use
current->nsproxy->user_ns in LSM hooks the problem was real.

Fortunately current->cred->user_ns does not exhibit the same issue. I'll
drop this patch.

Sorry for the confusion.


> 
> >
> > Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  kernel/exit.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 22fcc05..da1bb18 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -742,7 +742,6 @@ void do_exit(long code)
> >  	exit_fs(tsk);
> >  	if (group_dead)
> >  		disassociate_ctty(1);
> > -	exit_task_namespaces(tsk);
> >  	exit_task_work(tsk);
> >  	exit_thread();
> >  
> > @@ -763,6 +762,13 @@ void do_exit(long code)
> >  
> >  	TASKS_RCU(tasks_rcu_i = __srcu_read_lock(&tasks_rcu_exit_srcu));
> >  	exit_notify(tsk, group_dead);
> > +
> > +	/*
> > +	 * This should be after all things that potentially require
> > +	 * process's namespaces (e.g. capability checks).
> > +	 */
> > +	exit_task_namespaces(tsk);
> > +
> >  	proc_exit_connector(tsk);
> >  #ifdef CONFIG_NUMA
> >  	task_lock(tsk);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics
