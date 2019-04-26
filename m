From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] Add polling support to pidfd
Date: Fri, 26 Apr 2019 17:21:40 +0200
Message-ID: <20190426152139.jbyihycizb4x5sfd@brauner.io>
References: <20190425190010.46489-1-joel@joelfernandes.org>
 <20190425222359.sqhboc4x4daznr6r@brauner.io>
 <20190426142337.GC261279@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190426142337.GC261279@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, dancol@google.com, sspatil@google.com, jannh@google.com, surenb@google.com, timmurray@google.com, Jonathan Kowalski <bl0pbl33p@gmail.com>, torvalds@linux-foundation.org, kernel-team@android.com, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jann@thejh.net>, linux-kselftest@vger.kernel.org, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Serge Hallyn <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Thomas Gleixner <tglx@linutronix.de>, Tycho Andersen <tycho@ty>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 26, 2019 at 10:23:37AM -0400, Joel Fernandes wrote:
> On Fri, Apr 26, 2019 at 12:24:04AM +0200, Christian Brauner wrote:
> > On Thu, Apr 25, 2019 at 03:00:09PM -0400, Joel Fernandes (Google) wrote:
> > > pidfd are file descriptors referring to a process created with the
> > > CLONE_PIDFD clone(2) flag. Android low memory killer (LMK) needs pidfd
> > > polling support to replace code that currently checks for existence of
> > > /proc/pid for knowing that a process that is signalled to be killed has
> > > died, which is both racy and slow. The pidfd poll approach is race-free,
> > > and also allows the LMK to do other things (such as by polling on other
> > > fds) while awaiting the process being killed to die.
> > 
> > Thanks for the patch!
> > 
> > Ok, let me be a little bit anal.
> > Please start the commit message with what this patch does and then add
> 
> The subject title is "Add polling support to pidfd", but ok I should write a
> better commit message.

Yeah, it's really just that we should really just have a simple
paragraph that expresses this makes the codebase do X.

> 
> > the justification why. You just say the "pidfd-poll" approach. You can
> > probably assume that CLONE_PIDFD is available for this patch. So
> > something like:
> > 
> > "This patch makes pidfds pollable. Specifically, it allows listeners to
> > be informed when the process the pidfd referes to exits. This patch only
> > introduces the ability to poll thread-group leaders since pidfds
> > currently can only reference those..."
> > 
> > Then justify the use-case and then go into implementation details.
> > That's usually how I would think about this:
> > - Change the codebase to do X
> > - Why do we need X
> > - Are there any technical details worth mentioning in the commit message
> > (- Are there any controversial points that people stumbled upon but that
> >   have been settled sufficiently.)
> 
> Generally the "how" in the patch should be in the code, but ok.

That's why I said: technical details that are worth mentioning.
Sometimes you have controversial bits that are obviously to be
understood in the code but it still might be worth explaining why one
had to do it this way. Like say what we did for the pidfd_send_signal()
thing where we explained why O_PATH is disallowed.

> 
> I changed the first 3 paragraphs of the changelog to the following, is that
> better? :
> 
> Android low memory killer (LMK) needs to know when a process dies once
> it is sent the kill signal. It does so by checking for the existence of
> /proc/pid which is both racy and slow. For example, if a PID is reused
> between when LMK sends a kill signal and checks for existence of the
> PID, since the wrong PID is now possibly checked for existence.
> 
> This patch adds polling support to pidfd. Using the polling support, LMK
> will be able to get notified when a process exists in race-free and fast
> way, and allows the LMK to do other things (such as by polling on other
> fds) while awaiting the process being killed to die.
> 
> For notification to polling processes, we follow the same existing
> mechanism in the kernel used when the parent of the task group is to be
> notified of a child's death (do_notify_parent).  This is precisely when
> the tasks waiting on a poll of pidfd are also awakened in this patch.
> 
> > > pidfd are file descriptors referring to a process created with the
> > > CLONE_PIDFD clone(2) flag. Android low memory killer (LMK) needs pidfd
> > > polling support to replace code that currently checks for existence of
> > > /proc/pid for knowing that a process that is signalled to be killed has
> > > died, which is both racy and slow. The pidfd poll approach is race-free,
> > > and also allows the LMK to do other things (such as by polling on other
> > > fds) while awaiting the process being killed to die.
> > 
> > > 
> > > It prevents a situation where a PID is reused between when LMK sends a
> > > kill signal and checks for existence of the PID, since the wrong PID is
> > > now possibly checked for existence.
> > > 
> > > In this patch, we follow the same existing mechanism in the kernel used
> > > when the parent of the task group is to be notified (do_notify_parent).
> > > This is when the tasks waiting on a poll of pidfd are also awakened.
> > > 
> > > We have decided to include the waitqueue in struct pid for the following
> > > reasons:
> > > 1. The wait queue has to survive for the lifetime of the poll. Including
> > > it in task_struct would not be option in this case because the task can
> > > be reaped and destroyed before the poll returns.
> > > 
> > > 2. By including the struct pid for the waitqueue means that during
> > > de_thread(), the new thread group leader automatically gets the new
> > > waitqueue/pid even though its task_struct is different.
> > > 
> > > Appropriate test cases are added in the second patch to provide coverage
> > > of all the cases the patch is handling.
> > > 
> > > Andy had a similar patch [1] in the past which was a good reference
> > > however this patch tries to handle different situations properly related
> > > to thread group existence, and how/where it notifies. And also solves
> > > other bugs (waitqueue lifetime).  Daniel had a similar patch [2]
> > > recently which this patch supercedes.
> > > 
> > > [1] https://lore.kernel.org/patchwork/patch/345098/
> > > [2] https://lore.kernel.org/lkml/20181029175322.189042-1-dancol@google.com/
> > > 
> > > Cc: luto@amacapital.net
> > > Cc: rostedt@goodmis.org
> > > Cc: dancol@google.com
> > > Cc: sspatil@google.com
> > > Cc: christian@brauner.io
> > > Cc: jannh@google.com
> > > Cc: surenb@google.com
> > > Cc: timmurray@google.com
> > > Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
> > > Cc: torvalds@linux-foundation.org
> > > Cc: kernel-team@android.com
> > 
> > These should all be in the form:
> > 
> > Cc: Firstname Lastname <email@address.com>
> 
> If this bothers you too much, I can also just remove the CC list from the
> changelog here, and include it in my invocation of git-send-email instead..
> but I have seen commits in the tree that don't follow this rule.

Yeah, but they should. There are people with multiple emails over the
years and they might not necessarily contain their first and last
name. And I don't want to have to mailmap them or sm. Having their names
in there just makes it easier. Also, every single other DCO-*related*
line follows:

Random J Developer <random@developer.example.org>

This should too. If others are sloppy and allow this, fine. No reason we
should.

> 
> > 
> > There are people missing from the Cc that really should be there...
> 
> If you look at the CC list of the email, people in the get_maintainer.pl
> script were also added. I did run get_maintainer.pl and checkpatch. But ok, I
> will add the folks you are suggesting as well. Thanks.

get_maintainer.pl is not the last word. 

> 
> > Even though he usually doesn't respond that often, please Cc Al on this.
> > If he responds it's usually rather important.
> 
> No issues on that, but I am wondering if he should also be in MAINTAINERS
> file somewhere such that get_maintainer.pl does pick him up. I added him.

It's often not about someone being a maintainer but whether or not they
have valuable input.

"[...] This tag documents that potentially interested parties have been
included in the discussion."

> 
> > Oleg has reviewed your RFC patch quite substantially and given valuable
> > feedback and has an opinion on this thing and is best acquainted with
> > the exit code. So please add him to the Cc of the commit message in the
> > appropriate form and also add him to the Cc of the thread.
> 
> Done.

Thanks!

> 
> > Probably also want linux-api for good measure since a lot of people are
> > subscribed that would care about pollable pidfds. I'd also add Kees
> > since he had some interest in this work and David (Howells).
> 
> Done, I added all of them and CC will go out to them next time. Thanks.

Cool. That really wasn't a "you've done this wrong". It's rather really
just to make sure that everyone who might catch a big f*ck up on our
part has had a chance to tell us so. :)

> 
> > 
> > > Co-developed-by: Daniel Colascione <dancol@google.com>
> > 
> > Every CDB needs to give a SOB as well.
> 
> Ok, done. thanks.

Fwiw, I only learned this recently too.

> 
> > 
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > 
> > > ---
> > > 
> > > RFC -> v1:
> > > * Based on CLONE_PIDFD patches: https://lwn.net/Articles/786244/
> > > * Updated selftests.
> > > * Renamed poll wake function to do_notify_pidfd.
> > > * Removed depending on EXIT flags
> > > * Removed POLLERR flag since semantics are controversial and
> > >   we don't have usecases for it right now (later we can add if there's
> > >   a need for it).
> > > 
> > >  include/linux/pid.h |  3 +++
> > >  kernel/fork.c       | 33 +++++++++++++++++++++++++++++++++
> > >  kernel/pid.c        |  2 ++
> > >  kernel/signal.c     | 14 ++++++++++++++
> > >  4 files changed, 52 insertions(+)
> > > 
> > > diff --git a/include/linux/pid.h b/include/linux/pid.h
> > > index 3c8ef5a199ca..1484db6ca8d1 100644
> > > --- a/include/linux/pid.h
> > > +++ b/include/linux/pid.h
> > > @@ -3,6 +3,7 @@
> > >  #define _LINUX_PID_H
> > >  
> > >  #include <linux/rculist.h>
> > > +#include <linux/wait.h>
> > >  
> > >  enum pid_type
> > >  {
> > > @@ -60,6 +61,8 @@ struct pid
> > >  	unsigned int level;
> > >  	/* lists of tasks that use this pid */
> > >  	struct hlist_head tasks[PIDTYPE_MAX];
> > > +	/* wait queue for pidfd notifications */
> > > +	wait_queue_head_t wait_pidfd;
> > >  	struct rcu_head rcu;
> > >  	struct upid numbers[1];
> > >  };
> > > diff --git a/kernel/fork.c b/kernel/fork.c
> > > index 5525837ed80e..fb3b614f6456 100644
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -1685,8 +1685,41 @@ static void pidfd_show_fdinfo(struct seq_file *m, struct file *f)
> > >  }
> > >  #endif
> > >  
> > > +static unsigned int pidfd_poll(struct file *file, struct poll_table_struct *pts)
> > > +{
> > > +	struct task_struct *task;
> > > +	struct pid *pid;
> > > +	int poll_flags = 0;
> > > +
> > > +	/*
> > > +	 * tasklist_lock must be held because to avoid racing with
> > > +	 * changes in exit_state and wake up. Basically to avoid:
> > > +	 *
> > > +	 * P0: read exit_state = 0
> > > +	 * P1: write exit_state = EXIT_DEAD
> > > +	 * P1: Do a wake up - wq is empty, so do nothing
> > > +	 * P0: Queue for polling - wait forever.
> > > +	 */
> > > +	read_lock(&tasklist_lock);
> > > +	pid = file->private_data;
> > > +	task = pid_task(pid, PIDTYPE_PID);
> > > +	WARN_ON_ONCE(task && !thread_group_leader(task));
> > > +
> > > +	if (!task || (task->exit_state && thread_group_empty(task)))
> > > +		poll_flags = POLLIN | POLLRDNORM;
> > 
> > So we block until the thread-group is empty? Hm, the thread-group leader
> > remains in zombie state until all threads are gone. Should probably just
> > be a short comment somewhere that callers are only informed about a
> > whole thread-group exit and not about when the thread-group leader has
> > actually exited.
> 
> Ok, I'll add a comment.
> 
> > I would like the ability to extend this interface in the future to allow
> > for actually reading data from the pidfd on EPOLLIN.
> > POSIX specifies that POLLIN and POLLRDNORM are set even if the
> > message to be read is zero. So one cheap way of doing this would
> > probably be to do a 0 read/ioctl. That wouldn't hurt your very limited
> > usecase and people could test whether the read returned non-0 data and
> > if so they know this interface got extended. If we never extend it here
> > it won't matter.
> 
> I am a bit confused. What specific changes to this patch are you proposing?
> This patch makes poll block until the process exits. In the future, we can
> make it unblock for a other reasons as well, that's fine with me. I don't see
> how this patch prevents such extensions.

I guess I should've asked the following:
What happens right now, when you get EPOLLIN on the pidfd and you and
out of ignorance you do:

read(pidfd, ...)

> 
> > > +	if (!poll_flags)
> > > +		poll_wait(file, &pid->wait_pidfd, pts);
> > > +
> > > +	read_unlock(&tasklist_lock);
> > > +
> > > +	return poll_flags;
> > > +}
> > 
> > 
> > > +
> > > +
> > >  const struct file_operations pidfd_fops = {
> > >  	.release = pidfd_release,
> > > +	.poll = pidfd_poll,
> > >  #ifdef CONFIG_PROC_FS
> > >  	.show_fdinfo = pidfd_show_fdinfo,
> > >  #endif
> > > diff --git a/kernel/pid.c b/kernel/pid.c
> > > index 20881598bdfa..5c90c239242f 100644
> > > --- a/kernel/pid.c
> > > +++ b/kernel/pid.c
> > > @@ -214,6 +214,8 @@ struct pid *alloc_pid(struct pid_namespace *ns)
> > >  	for (type = 0; type < PIDTYPE_MAX; ++type)
> > >  		INIT_HLIST_HEAD(&pid->tasks[type]);
> > >  
> > > +	init_waitqueue_head(&pid->wait_pidfd);
> > > +
> > >  	upid = pid->numbers + ns->level;
> > >  	spin_lock_irq(&pidmap_lock);
> > >  	if (!(ns->pid_allocated & PIDNS_ADDING))
> > > diff --git a/kernel/signal.c b/kernel/signal.c
> > > index 1581140f2d99..16e7718316e5 100644
> > > --- a/kernel/signal.c
> > > +++ b/kernel/signal.c
> > > @@ -1800,6 +1800,17 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
> > >  	return ret;
> > >  }
> > >  
> > > +static void do_notify_pidfd(struct task_struct *task)
> > 
> > Maybe a short command that this helper can only be called when we know
> > that task is a thread-group leader wouldn't hurt so there's no confusion
> > later.
> 
> Ok, will do.
> 
> thanks,
> 
>  - Joel
> 
