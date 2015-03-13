From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Fri, 13 Mar 2015 14:34:58 -0700
Message-ID: <CALCETrVkZVa6zsd6gpW_AnQSO2cC___U8M3Dc7c6=PJdEiT9Pg@mail.gmail.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org>
 <20150313162113.GA25966@redhat.com> <20150313195707.GA10487@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150313195707.GA10487@cloud>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 12:57 PM,  <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> On Fri, Mar 13, 2015 at 05:21:13PM +0100, Oleg Nesterov wrote:
>> Josh,
>>
>> I'll certainly try to read this series, but not before next week.
>
> Thanks for looking at it.
>
>> but a couple of nits right now.
>>
>> On 03/12, Josh Triplett wrote:
>> >
>> > When passed CLONE_FD, clone4 will return a file descriptor rather than a
>> > PID.  When the child process exits, it gets automatically reaped,
>>
>> And even I have no idea what you are actually doing, this doesn't look
>> right, see below.
>>
>> > +static unsigned int clonefd_poll(struct file *file, poll_table *wait)
>> > +{
>> > +   struct task_struct *p = file->private_data;
>> > +   poll_wait(file, &p->clonefd_wqh, wait);
>> > +   return p->exit_state == EXIT_DEAD ? (POLLIN | POLLRDNORM) : 0;
>> > +}
>> > +
>> > +static ssize_t clonefd_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>> > +{
>> > +   struct task_struct *p = file->private_data;
>> > +   int ret = 0;
>> > +
>> > +   /* EOF after first read */
>> > +   if (*ppos)
>> > +           return 0;
>> > +
>> > +   if (file->f_flags & O_NONBLOCK)
>> > +           ret = -EAGAIN;
>> > +   else
>> > +           ret = wait_event_interruptible(p->clonefd_wqh, p->exit_state == EXIT_DEAD);
>> > +
>> > +   if (p->exit_state == EXIT_DEAD) {
>>
>> Again, I simply do not know what this code does at all. But I bet the usage
>> of EXIT_DEAD is wrong ;)
>>
>> OK, OK, I can be wrong. But I simply do not see what protects this task_struct
>> if it is EXIT_DEAD (in fact even if it is EXIT_ZOMBIE).
>
> If by "what protects" you mean "what keeps it alive", the file
> descriptor holds a reference to the task_struct by calling
> get_task_struct when created and put_task_struct when released.
>
> This wait_event_interruptible pairs with the wake_up_all called from
> clonefd_do_notify, which exit_notify calls *after* setting the task to
> TASK_DEAD.
>
> Apart from that, what about what the code is doing isn't clear?
>
>> > @@ -598,7 +600,9 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
>> >     if (group_dead)
>> >             kill_orphaned_pgrp(tsk->group_leader, NULL);
>> >
>> > -   if (unlikely(tsk->ptrace)) {
>> > +   if (tsk->autoreap) {
>> > +           autoreap = true;
>>
>> Debuggers won't be happy. A ptraced task should not autoreap itself.
>
> A process launching a new process with CLONE_FD is explicitly requesting
> that the process be automatically reaped without any other process
> having to wait on it.  The task needs to not become a zombie, because
> otherwise, it'll show up in waitpid(-1, ...) calls in the parent
> process, which would break the ability to use this to completely
> encapsulate process management within a library and not interfere with
> the parent's process handling via SIGCHLD and wait{pid,3,4}.

Wouldn't the correct behavior be to keep it alive as a zombie but
*not* show it in waitpid, etc?

--Andy
