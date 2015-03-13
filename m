From: josh@joshtriplett.org
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task
 exit notification via fd
Date: Fri, 13 Mar 2015 12:57:07 -0700
Message-ID: <20150313195707.GA10487@cloud>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org>
 <20150313162113.GA25966@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150313162113.GA25966@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 05:21:13PM +0100, Oleg Nesterov wrote:
> Josh,
> 
> I'll certainly try to read this series, but not before next week.

Thanks for looking at it.

> but a couple of nits right now.
> 
> On 03/12, Josh Triplett wrote:
> >
> > When passed CLONE_FD, clone4 will return a file descriptor rather than a
> > PID.  When the child process exits, it gets automatically reaped,
> 
> And even I have no idea what you are actually doing, this doesn't look
> right, see below.
> 
> > +static unsigned int clonefd_poll(struct file *file, poll_table *wait)
> > +{
> > +	struct task_struct *p = file->private_data;
> > +	poll_wait(file, &p->clonefd_wqh, wait);
> > +	return p->exit_state == EXIT_DEAD ? (POLLIN | POLLRDNORM) : 0;
> > +}
> > +
> > +static ssize_t clonefd_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
> > +{
> > +	struct task_struct *p = file->private_data;
> > +	int ret = 0;
> > +
> > +	/* EOF after first read */
> > +	if (*ppos)
> > +		return 0;
> > +
> > +	if (file->f_flags & O_NONBLOCK)
> > +		ret = -EAGAIN;
> > +	else
> > +		ret = wait_event_interruptible(p->clonefd_wqh, p->exit_state == EXIT_DEAD);
> > +
> > +	if (p->exit_state == EXIT_DEAD) {
> 
> Again, I simply do not know what this code does at all. But I bet the usage
> of EXIT_DEAD is wrong ;)
> 
> OK, OK, I can be wrong. But I simply do not see what protects this task_struct
> if it is EXIT_DEAD (in fact even if it is EXIT_ZOMBIE).

If by "what protects" you mean "what keeps it alive", the file
descriptor holds a reference to the task_struct by calling
get_task_struct when created and put_task_struct when released.

This wait_event_interruptible pairs with the wake_up_all called from
clonefd_do_notify, which exit_notify calls *after* setting the task to
TASK_DEAD.

Apart from that, what about what the code is doing isn't clear?

> > @@ -598,7 +600,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
> >  	if (group_dead)
> >  		kill_orphaned_pgrp(tsk->group_leader, NULL);
> >  
> > -	if (unlikely(tsk->ptrace)) {
> > +	if (tsk->autoreap) {
> > +		autoreap = true;
> 
> Debuggers won't be happy. A ptraced task should not autoreap itself.

A process launching a new process with CLONE_FD is explicitly requesting
that the process be automatically reaped without any other process
having to wait on it.  The task needs to not become a zombie, because
otherwise, it'll show up in waitpid(-1, ...) calls in the parent
process, which would break the ability to use this to completely
encapsulate process management within a library and not interfere with
the parent's process handling via SIGCHLD and wait{pid,3,4}.

- Josh Triplett
