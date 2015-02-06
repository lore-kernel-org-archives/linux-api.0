From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] kernel/fork: handle put_user errors for CLONE_CHILD_SETTID/CLEARTID
Date: Fri, 6 Feb 2015 23:27:59 +0300
Message-ID: <CALYGNiOsv9gBeL_67-_YeSRCrsK56Pke5ac8ySjjo_L5=p_RFA@mail.gmail.com>
References: <20150206162301.18031.32251.stgit@buzz>
	<20150206194405.GA13960@redhat.com>
	<20150206195529.GA15517@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150206195529.GA15517-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Nikita Vetoshkin <nekto0n-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 6, 2015 at 10:55 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/06, Oleg Nesterov wrote:
>>
>> On 02/06, Konstantin Khlebnikov wrote:
>> >
>> > Whole sequence looks like: task calls fork, glibc calls syscall clone with
>> > CLONE_CHILD_SETTID and passes pointer to TLS THREAD_SELF->tid as argument.
>> > Child task gets read-only copy of VM including TLS. Child calls put_user()
>> > to handle CLONE_CHILD_SETTID from schedule_tail(). put_user() trigger page
>> > fault and it fails because do_wp_page()  hits memcg limit without invoking
>> > OOM-killer because this is page-fault from kernel-space.
>>
>> Because of !FAULT_FLAG_USER?

Yep. As I see memcg triggers OOM only on page-faults and only from user-space.

>>
>> Perhaps we should fix this? Say mem_cgroup_oom_enable/disable around put_user(),
>> I dunno.
>>
>> > Put_user returns
>> > -EFAULT, which is ignored.  Child returns into user-space and catches here
>> > assert (THREAD_GETMEM (self, tid) != ppid),
>>
>> If only I understood why else we need CLONE_CHILD_SETTID ;)

I dunno, CLONE_PARENT_SETTID should be enough for everybody but it's
broken too. Twice. See the next patch =)

>>
>> > --- a/kernel/sched/core.c
>> > +++ b/kernel/sched/core.c
>> > @@ -2312,8 +2312,20 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
>> >     post_schedule(rq);
>> >     preempt_enable();
>> >
>> > -   if (current->set_child_tid)
>> > -           put_user(task_pid_vnr(current), current->set_child_tid);
>> > +   if (current->set_child_tid &&
>> > +       unlikely(put_user(task_pid_vnr(current), current->set_child_tid))) {
>> > +           int dummy;
>> > +
>> > +           /*
>> > +            * If this address is unreadable then userspace has not set
>> > +            * proper pointer. Application either doesn't care or will
>> > +            * notice this soon. If this address is readable then task
>> > +            * will be mislead about its own tid. It's better to die.
>> > +            */
>> > +           if (!get_user(dummy, current->set_child_tid) &&
>> > +               !fatal_signal_pending(current))
>> > +                   force_sig(SIGSEGV, current);
>> > +   }
>>
>> Well, get_user() can fail the same way? The page we need to cow can be
>> swapped out.
>>
>> At first glance, to me this problem should be solved somewhere else...
>> I'll try to reread this all tomorrow.
>
> And in fact I think that this is not set_child_tid/etc-specific. Perhaps
> I am totally confused, but I think that put_user() simply should not fail
> this way. Say, why a syscall should return -EFAULT if memory allocation
> "silently" fails? Confused.

That's how memcg works. All other places are handled explicitly and
returns into user-space as -ENOMEM or -EFAULT.
Probably some strange numa policy / memoryaffinity might trigger this too.

Probably all page-faults must be forced to succeed or die mode,
in this case all errors in put_user/copy_to_user could be simply ignored.

--
Konstantin
