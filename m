From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 3/9] seccomp: introduce writer locking
Date: Tue, 24 Jun 2014 11:02:04 -0700
Message-ID: <CAGXu5j+G8qAkGD7H=3R2iw2ZTqZSrMPa2f=czoEjwSW5wKqUWQ@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-4-git-send-email-keescook@chromium.org>
	<20140624165216.GA29272@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140624165216.GA29272@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 24, 2014 at 9:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Kees,
>
> I am still trying to force myself to read and try to understand what
> this series does ;) Just a minor nit so far.

The use-case this solves is when a userspace process does not control
(or know) when a thread is spawned (e.g. via shared library init, or
LD_PRELOAD) but wants to make sure seccomp filters have been applied
to it. Specifically, Chrome, when loading some proprietary graphics
drivers, will have those drivers spawning threads before there has
been an ability to call seccomp. While some games can be played to get
ahead of it, it's not always possible, or racey, depending on the
drivers. With seccomp thread-sync, we can be certain that all threads
have had the filter applied.

>
> On 06/23, Kees Cook wrote:
>>
>> @@ -1142,6 +1168,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>  {
>>       int retval;
>>       struct task_struct *p;
>> +     unsigned long irqflags;
>>
>>       if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
>>               return ERR_PTR(-EINVAL);
>> @@ -1196,7 +1223,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>               goto fork_out;
>>
>>       ftrace_graph_init_task(p);
>> -     get_seccomp_filter(p);
>>
>>       rt_mutex_init_task(p);
>>
>> @@ -1434,7 +1460,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>               p->parent_exec_id = current->self_exec_id;
>>       }
>>
>> -     spin_lock(&current->sighand->siglock);
>> +     spin_lock_irqsave(&current->sighand->siglock, irqflags);
>> +
>> +     /*
>> +      * Copy seccomp details explicitly here, in case they were changed
>> +      * before holding tasklist_lock.
>> +      */
>> +     copy_seccomp(p);
>>
>>       /*
>>        * Process group and session signals need to be delivered to just the
>> @@ -1446,7 +1478,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       */
>>       recalc_sigpending();
>>       if (signal_pending(current)) {
>> -             spin_unlock(&current->sighand->siglock);
>> +             spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
>>               write_unlock_irq(&tasklist_lock);
>>               retval = -ERESTARTNOINTR;
>>               goto bad_fork_free_pid;
>> @@ -1486,7 +1518,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>       }
>>
>>       total_forks++;
>> -     spin_unlock(&current->sighand->siglock);
>> +     spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
>>       write_unlock_irq(&tasklist_lock);
>>       proc_fork_connector(p);
>>       cgroup_post_fork(p);
>
> It seems that the only change copy_process() needs is copy_seccomp() under the locks.
> Everythinh else (irqflags games) looks obviously unneeded?

I got irq lock dep warnings without these changes. If they're
unneeded, that's totally fine by me, but some change (either this or
markings to keep lockdep happy) is needed.

>> @@ -524,6 +528,9 @@ static long seccomp_set_mode(unsigned long seccomp_mode, char __user *filter)
>>       }
>>  #endif
>>
>> +     if (unlikely(!lock_task_sighand(current, &irqflags)))
>> +             goto out_free;
>> +
>
> Unless this task is exiting (namely, it has already called exit_notify()),
> lock_task_sighand(current) must not fail. Looks like you can simply do
> spin_lock_irq(->siglock).

Okay. I wasn't sure if I needed to be extra careful here or not. I
opted for just using lock_task_sighand since that seemed to be the
most used. :)

-Kees

-- 
Kees Cook
Chrome OS Security
