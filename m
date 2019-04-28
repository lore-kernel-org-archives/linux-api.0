From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v1 1/2] Add polling support to pidfd
Date: Sun, 28 Apr 2019 18:24:06 +0200
Message-ID: <20190428162405.GA6757@redhat.com>
References: <20190425190010.46489-1-joel@joelfernandes.org>
 <20190425222359.sqhboc4x4daznr6r@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190425222359.sqhboc4x4daznr6r@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, linux-kernel@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, dancol@google.com, sspatil@google.com, jannh@google.com, surenb@google.com, timmurray@google.com, Jonathan Kowalski <bl0pbl33p@gmail.com>, torvalds@linux-foundation.org, kernel-team@android.com, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jann@thejh.net>, linux-kselftest@vger.kernel.org, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Serge Hallyn <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Thomas
List-Id: linux-api@vger.kernel.org

Thanks for cc'ing me...

On 04/26, Christian Brauner wrote:
>
> On Thu, Apr 25, 2019 at 03:00:09PM -0400, Joel Fernandes (Google) wrote:
> > +static unsigned int pidfd_poll(struct file *file, struct poll_table_struct *pts)
> > +{
> > +	struct task_struct *task;
> > +	struct pid *pid;
> > +	int poll_flags = 0;
> > +
> > +	/*
> > +	 * tasklist_lock must be held because to avoid racing with
> > +	 * changes in exit_state and wake up. Basically to avoid:
> > +	 *
> > +	 * P0: read exit_state = 0
> > +	 * P1: write exit_state = EXIT_DEAD
> > +	 * P1: Do a wake up - wq is empty, so do nothing
> > +	 * P0: Queue for polling - wait forever.
> > +	 */
> > +	read_lock(&tasklist_lock);
> > +	pid = file->private_data;
> > +	task = pid_task(pid, PIDTYPE_PID);
> > +	WARN_ON_ONCE(task && !thread_group_leader(task));
> > +
> > +	if (!task || (task->exit_state && thread_group_empty(task)))
> > +		poll_flags = POLLIN | POLLRDNORM;

Joel, I still can't understand why do we need tasklist... and I don't really
understand the comment. The code looks as if you are trying to avoid poll_wait(),
but this would be strange.

OK, why can't pidfd_poll() do

	poll_wait(file, &pid->wait_pidfd, pts);

	rcu_read_lock();
	task = pid_task(pid, PIDTYPE_PID);
	if (!task || task->exit_state && thread_group_empty(task))
		poll_flags = POLLIN | ...;
	rcu_read_unlock();

	return poll_flags;

?

> > +static void do_notify_pidfd(struct task_struct *task)
>
> Maybe a short command that this helper can only be called when we know
> that task is a thread-group leader wouldn't hurt so there's no confusion
> later.

Not really. If the task is traced, do_notify_parent() (and thus do_notify_pidfd())
can be called to notify the debugger even if the task is not a leader and/or if
it is not the last thread. The latter means a spurious wakeup for pidfd_poll().

> > +{
> > +	struct pid *pid;
> > +
> > +	lockdep_assert_held(&tasklist_lock);
> > +
> > +	pid = get_task_pid(task, PIDTYPE_PID);
> > +	wake_up_all(&pid->wait_pidfd);
> > +	put_pid(pid);

Why get/put?

Oleg.
