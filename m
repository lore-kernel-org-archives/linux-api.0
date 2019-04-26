From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] Add polling support to pidfd
Date: Fri, 26 Apr 2019 17:31:47 +0200
Message-ID: <C7BC66F2-7330-48E4-AC20-F0106A729878@brauner.io>
References: <20190425190010.46489-1-joel@joelfernandes.org> <20190425222359.sqhboc4x4daznr6r@brauner.io> <20190426142337.GC261279@google.com> <20190426152139.jbyihycizb4x5sfd@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190426152139.jbyihycizb4x5sfd@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, dancol@google.com, sspatil@google.com, jannh@google.com, surenb@google.com, timmurray@google.com, Jonathan Kowalski <bl0pbl33p@gmail.com>, torvalds@linux-foundation.org, kernel-team@android.com, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jann@thejh.net>, linux-kselftest@vger.kernel.org, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Serge Hallyn <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Thomas Gleixner <tglx@linutronix.de>, Tycho Andersen <tycho@ty>
List-Id: linux-api@vger.kernel.org

On April 26, 2019 5:21:40 PM GMT+02:00, Christian Brauner <christian@braune=
r=2Eio> wrote:
>On Fri, Apr 26, 2019 at 10:23:37AM -0400, Joel Fernandes wrote:
>> On Fri, Apr 26, 2019 at 12:24:04AM +0200, Christian Brauner wrote:
>> > On Thu, Apr 25, 2019 at 03:00:09PM -0400, Joel Fernandes (Google)
>wrote:
>> > > pidfd are file descriptors referring to a process created with
>the
>> > > CLONE_PIDFD clone(2) flag=2E Android low memory killer (LMK) needs
>pidfd
>> > > polling support to replace code that currently checks for
>existence of
>> > > /proc/pid for knowing that a process that is signalled to be
>killed has
>> > > died, which is both racy and slow=2E The pidfd poll approach is
>race-free,
>> > > and also allows the LMK to do other things (such as by polling on
>other
>> > > fds) while awaiting the process being killed to die=2E
>> >=20
>> > Thanks for the patch!
>> >=20
>> > Ok, let me be a little bit anal=2E
>> > Please start the commit message with what this patch does and then
>add
>>=20
>> The subject title is "Add polling support to pidfd", but ok I should
>write a
>> better commit message=2E
>
>Yeah, it's really just that we should really just have a simple
>paragraph that expresses this makes the codebase do X=2E
>
>>=20
>> > the justification why=2E You just say the "pidfd-poll" approach=2E Yo=
u
>can
>> > probably assume that CLONE_PIDFD is available for this patch=2E So
>> > something like:
>> >=20
>> > "This patch makes pidfds pollable=2E Specifically, it allows
>listeners to
>> > be informed when the process the pidfd referes to exits=2E This patch
>only
>> > introduces the ability to poll thread-group leaders since pidfds
>> > currently can only reference those=2E=2E=2E"
>> >=20
>> > Then justify the use-case and then go into implementation details=2E
>> > That's usually how I would think about this:
>> > - Change the codebase to do X
>> > - Why do we need X
>> > - Are there any technical details worth mentioning in the commit
>message
>> > (- Are there any controversial points that people stumbled upon but
>that
>> >   have been settled sufficiently=2E)
>>=20
>> Generally the "how" in the patch should be in the code, but ok=2E
>
>That's why I said: technical details that are worth mentioning=2E
>Sometimes you have controversial bits that are obviously to be
>understood in the code but it still might be worth explaining why one
>had to do it this way=2E Like say what we did for the pidfd_send_signal()
>thing where we explained why O_PATH is disallowed=2E
>
>>=20
>> I changed the first 3 paragraphs of the changelog to the following,
>is that
>> better? :
>>=20
>> Android low memory killer (LMK) needs to know when a process dies
>once
>> it is sent the kill signal=2E It does so by checking for the existence
>of
>> /proc/pid which is both racy and slow=2E For example, if a PID is
>reused
>> between when LMK sends a kill signal and checks for existence of the
>> PID, since the wrong PID is now possibly checked for existence=2E
>>=20
>> This patch adds polling support to pidfd=2E Using the polling support,
>LMK
>> will be able to get notified when a process exists in race-free and
>fast
>> way, and allows the LMK to do other things (such as by polling on
>other
>> fds) while awaiting the process being killed to die=2E
>>=20
>> For notification to polling processes, we follow the same existing
>> mechanism in the kernel used when the parent of the task group is to
>be
>> notified of a child's death (do_notify_parent)=2E  This is precisely
>when
>> the tasks waiting on a poll of pidfd are also awakened in this patch=2E
>>=20
>> > > pidfd are file descriptors referring to a process created with
>the
>> > > CLONE_PIDFD clone(2) flag=2E Android low memory killer (LMK) needs
>pidfd
>> > > polling support to replace code that currently checks for
>existence of
>> > > /proc/pid for knowing that a process that is signalled to be
>killed has
>> > > died, which is both racy and slow=2E The pidfd poll approach is
>race-free,
>> > > and also allows the LMK to do other things (such as by polling on
>other
>> > > fds) while awaiting the process being killed to die=2E
>> >=20
>> > >=20
>> > > It prevents a situation where a PID is reused between when LMK
>sends a
>> > > kill signal and checks for existence of the PID, since the wrong
>PID is
>> > > now possibly checked for existence=2E
>> > >=20
>> > > In this patch, we follow the same existing mechanism in the
>kernel used
>> > > when the parent of the task group is to be notified
>(do_notify_parent)=2E
>> > > This is when the tasks waiting on a poll of pidfd are also
>awakened=2E
>> > >=20
>> > > We have decided to include the waitqueue in struct pid for the
>following
>> > > reasons:
>> > > 1=2E The wait queue has to survive for the lifetime of the poll=2E
>Including
>> > > it in task_struct would not be option in this case because the
>task can
>> > > be reaped and destroyed before the poll returns=2E
>> > >=20
>> > > 2=2E By including the struct pid for the waitqueue means that
>during
>> > > de_thread(), the new thread group leader automatically gets the
>new
>> > > waitqueue/pid even though its task_struct is different=2E
>> > >=20
>> > > Appropriate test cases are added in the second patch to provide
>coverage
>> > > of all the cases the patch is handling=2E
>> > >=20
>> > > Andy had a similar patch [1] in the past which was a good
>reference
>> > > however this patch tries to handle different situations properly
>related
>> > > to thread group existence, and how/where it notifies=2E And also
>solves
>> > > other bugs (waitqueue lifetime)=2E  Daniel had a similar patch [2]
>> > > recently which this patch supercedes=2E
>> > >=20
>> > > [1] https://lore=2Ekernel=2Eorg/patchwork/patch/345098/
>> > > [2]
>https://lore=2Ekernel=2Eorg/lkml/20181029175322=2E189042-1-dancol@google=
=2Ecom/
>> > >=20
>> > > Cc: luto@amacapital=2Enet
>> > > Cc: rostedt@goodmis=2Eorg
>> > > Cc: dancol@google=2Ecom
>> > > Cc: sspatil@google=2Ecom
>> > > Cc: christian@brauner=2Eio
>> > > Cc: jannh@google=2Ecom
>> > > Cc: surenb@google=2Ecom
>> > > Cc: timmurray@google=2Ecom
>> > > Cc: Jonathan Kowalski <bl0pbl33p@gmail=2Ecom>
>> > > Cc: torvalds@linux-foundation=2Eorg
>> > > Cc: kernel-team@android=2Ecom
>> >=20
>> > These should all be in the form:
>> >=20
>> > Cc: Firstname Lastname <email@address=2Ecom>
>>=20
>> If this bothers you too much, I can also just remove the CC list from
>the
>> changelog here, and include it in my invocation of git-send-email
>instead=2E=2E
>> but I have seen commits in the tree that don't follow this rule=2E
>
>Yeah, but they should=2E There are people with multiple emails over the
>years and they might not necessarily contain their first and last
>name=2E And I don't want to have to mailmap them or sm=2E Having their
>names
>in there just makes it easier=2E Also, every single other DCO-*related*
>line follows:
>
>Random J Developer <random@developer=2Eexample=2Eorg>
>
>This should too=2E If others are sloppy and allow this, fine=2E No reason
>we
>should=2E
>
>>=20
>> >=20
>> > There are people missing from the Cc that really should be there=2E=
=2E=2E
>>=20
>> If you look at the CC list of the email, people in the
>get_maintainer=2Epl
>> script were also added=2E I did run get_maintainer=2Epl and checkpatch=
=2E
>But ok, I
>> will add the folks you are suggesting as well=2E Thanks=2E
>
>get_maintainer=2Epl is not the last word=2E=20
>
>>=20
>> > Even though he usually doesn't respond that often, please Cc Al on
>this=2E
>> > If he responds it's usually rather important=2E
>>=20
>> No issues on that, but I am wondering if he should also be in
>MAINTAINERS
>> file somewhere such that get_maintainer=2Epl does pick him up=2E I adde=
d
>him=2E
>
>It's often not about someone being a maintainer but whether or not they
>have valuable input=2E
>
>"[=2E=2E=2E] This tag documents that potentially interested parties have =
been
>included in the discussion=2E"
>
>>=20
>> > Oleg has reviewed your RFC patch quite substantially and given
>valuable
>> > feedback and has an opinion on this thing and is best acquainted
>with
>> > the exit code=2E So please add him to the Cc of the commit message in
>the
>> > appropriate form and also add him to the Cc of the thread=2E
>>=20
>> Done=2E
>
>Thanks!
>
>>=20
>> > Probably also want linux-api for good measure since a lot of people
>are
>> > subscribed that would care about pollable pidfds=2E I'd also add Kees
>> > since he had some interest in this work and David (Howells)=2E
>>=20
>> Done, I added all of them and CC will go out to them next time=2E
>Thanks=2E
>
>Cool=2E That really wasn't a "you've done this wrong"=2E It's rather real=
ly
>just to make sure that everyone who might catch a big f*ck up on our
>part has had a chance to tell us so=2E :)
>
>>=20
>> >=20
>> > > Co-developed-by: Daniel Colascione <dancol@google=2Ecom>
>> >=20
>> > Every CDB needs to give a SOB as well=2E
>>=20
>> Ok, done=2E thanks=2E
>
>Fwiw, I only learned this recently too=2E
>
>>=20
>> >=20
>> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes=2Eorg>
>> > >=20
>> > > ---
>> > >=20
>> > > RFC -> v1:
>> > > * Based on CLONE_PIDFD patches: https://lwn=2Enet/Articles/786244/
>> > > * Updated selftests=2E
>> > > * Renamed poll wake function to do_notify_pidfd=2E
>> > > * Removed depending on EXIT flags
>> > > * Removed POLLERR flag since semantics are controversial and
>> > >   we don't have usecases for it right now (later we can add if
>there's
>> > >   a need for it)=2E
>> > >=20
>> > >  include/linux/pid=2Eh |  3 +++
>> > >  kernel/fork=2Ec       | 33 +++++++++++++++++++++++++++++++++
>> > >  kernel/pid=2Ec        |  2 ++
>> > >  kernel/signal=2Ec     | 14 ++++++++++++++
>> > >  4 files changed, 52 insertions(+)
>> > >=20
>> > > diff --git a/include/linux/pid=2Eh b/include/linux/pid=2Eh
>> > > index 3c8ef5a199ca=2E=2E1484db6ca8d1 100644
>> > > --- a/include/linux/pid=2Eh
>> > > +++ b/include/linux/pid=2Eh
>> > > @@ -3,6 +3,7 @@
>> > >  #define _LINUX_PID_H
>> > > =20
>> > >  #include <linux/rculist=2Eh>
>> > > +#include <linux/wait=2Eh>
>> > > =20
>> > >  enum pid_type
>> > >  {
>> > > @@ -60,6 +61,8 @@ struct pid
>> > >  	unsigned int level;
>> > >  	/* lists of tasks that use this pid */
>> > >  	struct hlist_head tasks[PIDTYPE_MAX];
>> > > +	/* wait queue for pidfd notifications */
>> > > +	wait_queue_head_t wait_pidfd;
>> > >  	struct rcu_head rcu;
>> > >  	struct upid numbers[1];
>> > >  };
>> > > diff --git a/kernel/fork=2Ec b/kernel/fork=2Ec
>> > > index 5525837ed80e=2E=2Efb3b614f6456 100644
>> > > --- a/kernel/fork=2Ec
>> > > +++ b/kernel/fork=2Ec
>> > > @@ -1685,8 +1685,41 @@ static void pidfd_show_fdinfo(struct
>seq_file *m, struct file *f)
>> > >  }
>> > >  #endif
>> > > =20
>> > > +static unsigned int pidfd_poll(struct file *file, struct
>poll_table_struct *pts)
>> > > +{
>> > > +	struct task_struct *task;
>> > > +	struct pid *pid;
>> > > +	int poll_flags =3D 0;
>> > > +
>> > > +	/*
>> > > +	 * tasklist_lock must be held because to avoid racing with
>> > > +	 * changes in exit_state and wake up=2E Basically to avoid:
>> > > +	 *
>> > > +	 * P0: read exit_state =3D 0
>> > > +	 * P1: write exit_state =3D EXIT_DEAD
>> > > +	 * P1: Do a wake up - wq is empty, so do nothing
>> > > +	 * P0: Queue for polling - wait forever=2E
>> > > +	 */
>> > > +	read_lock(&tasklist_lock);
>> > > +	pid =3D file->private_data;
>> > > +	task =3D pid_task(pid, PIDTYPE_PID);
>> > > +	WARN_ON_ONCE(task && !thread_group_leader(task));
>> > > +
>> > > +	if (!task || (task->exit_state && thread_group_empty(task)))
>> > > +		poll_flags =3D POLLIN | POLLRDNORM;
>> >=20
>> > So we block until the thread-group is empty? Hm, the thread-group
>leader
>> > remains in zombie state until all threads are gone=2E Should probably
>just
>> > be a short comment somewhere that callers are only informed about a
>> > whole thread-group exit and not about when the thread-group leader
>has
>> > actually exited=2E
>>=20
>> Ok, I'll add a comment=2E
>>=20
>> > I would like the ability to extend this interface in the future to
>allow
>> > for actually reading data from the pidfd on EPOLLIN=2E
>> > POSIX specifies that POLLIN and POLLRDNORM are set even if the
>> > message to be read is zero=2E So one cheap way of doing this would
>> > probably be to do a 0 read/ioctl=2E That wouldn't hurt your very
>limited
>> > usecase and people could test whether the read returned non-0 data
>and
>> > if so they know this interface got extended=2E If we never extend it
>here
>> > it won't matter=2E
>>=20
>> I am a bit confused=2E What specific changes to this patch are you
>proposing?
>> This patch makes poll block until the process exits=2E In the future,
>we can
>> make it unblock for a other reasons as well, that's fine with me=2E I
>don't see
>> how this patch prevents such extensions=2E
>
>I guess I should've asked the following:
>What happens right now, when you get EPOLLIN on the pidfd and you and
>out of ignorance you do:
>
>read(pidfd, =2E=2E=2E)

I guess it returns EINVAL which is fine=2E
So you can ignore that comment=2E

>
>>=20
>> > > +	if (!poll_flags)
>> > > +		poll_wait(file, &pid->wait_pidfd, pts);
>> > > +
>> > > +	read_unlock(&tasklist_lock);
>> > > +
>> > > +	return poll_flags;
>> > > +}
>> >=20
>> >=20
>> > > +
>> > > +
>> > >  const struct file_operations pidfd_fops =3D {
>> > >  	=2Erelease =3D pidfd_release,
>> > > +	=2Epoll =3D pidfd_poll,
>> > >  #ifdef CONFIG_PROC_FS
>> > >  	=2Eshow_fdinfo =3D pidfd_show_fdinfo,
>> > >  #endif
>> > > diff --git a/kernel/pid=2Ec b/kernel/pid=2Ec
>> > > index 20881598bdfa=2E=2E5c90c239242f 100644
>> > > --- a/kernel/pid=2Ec
>> > > +++ b/kernel/pid=2Ec
>> > > @@ -214,6 +214,8 @@ struct pid *alloc_pid(struct pid_namespace
>*ns)
>> > >  	for (type =3D 0; type < PIDTYPE_MAX; ++type)
>> > >  		INIT_HLIST_HEAD(&pid->tasks[type]);
>> > > =20
>> > > +	init_waitqueue_head(&pid->wait_pidfd);
>> > > +
>> > >  	upid =3D pid->numbers + ns->level;
>> > >  	spin_lock_irq(&pidmap_lock);
>> > >  	if (!(ns->pid_allocated & PIDNS_ADDING))
>> > > diff --git a/kernel/signal=2Ec b/kernel/signal=2Ec
>> > > index 1581140f2d99=2E=2E16e7718316e5 100644
>> > > --- a/kernel/signal=2Ec
>> > > +++ b/kernel/signal=2Ec
>> > > @@ -1800,6 +1800,17 @@ int send_sigqueue(struct sigqueue *q,
>struct pid *pid, enum pid_type type)
>> > >  	return ret;
>> > >  }
>> > > =20
>> > > +static void do_notify_pidfd(struct task_struct *task)
>> >=20
>> > Maybe a short command that this helper can only be called when we
>know
>> > that task is a thread-group leader wouldn't hurt so there's no
>confusion
>> > later=2E
>>=20
>> Ok, will do=2E
>>=20
>> thanks,
>>=20
>>  - Joel
>>=20
