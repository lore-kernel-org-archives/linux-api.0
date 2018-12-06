From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 06 Dec 2018 16:22:23 -0600
Message-ID: <87in0647og.fsf@xmission.com>
References: <20181206121858.12215-1-christian@brauner.io>
        <87sgzahf7k.fsf@xmission.com>
        <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io>
        <875zw6bh2z.fsf@xmission.com>
        <20181206193017.wpxls5p3zgjd6rv2@brauner.io>
        <871s6u9z6u.fsf@xmission.com>
        <CAKOZuevgPv1CbAZF-ha0njdq6rd6QkU7T8qmmERJLsL45CeVzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuevgPv1CbAZF-ha0njdq6rd6QkU7T8qmmERJLsL45CeVzg@mail.gmail.com>
        (Daniel Colascione's message of "Thu, 6 Dec 2018 12:37:20 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Daniel Colascione <dancol@google.com> writes:

> On Thu, Dec 6, 2018 at 12:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Christian Brauner <christian@brauner.io> writes:
>>
>> > [1]: You cannot replicate certain aspects of kill *yet*. We have
>> > established this before. If we want process group support later we do
>> > have the flags argument to extend the sycall.
>>
>> Then you have horrible contradiction in the API.
>>
>> Either the grouping is a property of your file descriptor or the
>> grouping comes from the flags argument.
>>
>> If the grouping is specified in the flags argument then pidfd is the
>> proper name for your file descriptors, and the appropriate prefix
>> for your system call.
>
> Yes and no. "taskfd" is fine, since even if we do add a
> kill-process-group capability, the general facility under discussion
> is still *about* tasks in general, so "taskfd" still tells you in a
> general sense what the thing does. "pidfd" would be wrong, and for the
> same reason that the kernel's "struct pid" is badly-named: the object
> being named is a *task*, and signaling a particular task instead of
> whatever task happens to be labeled with a particular numeric PID at
> the time of all is the whole point of this change.

No.  The object being named by struct pid is an identifier.

The same identifier can label processes, the same identifier can
label threads, the same identifier can label process groups the
same identifier can label sessions.

That is fundamental to how that identifier works.

Now the new file descriptor can either be a handle to the struct pid
the general purpose identifier, or the file descriptor can be a handle
to a process.  Other file descriptor types would be handles to different
kinds of processes.


When people tell me the new interface can handle process groups or
sessions by just adding a flag.  I hear they want to have an handle
to struct pid then general purpose identifier.  Because it doesn't make
any sense at all to add a flag to when you need to add a new file
descriptor type to keep the API consistent.

Later when I hear people say that they want an identifier for a process
and not have a handle to a general purpose identifier I think they need
to think about differnt types of file descriptors for the different
purposes.  The flags argument does not help at all there.

>> If the grouping is a property of your file descriptor it does not make
>> sense to talk about using the flags argument later.
>>
>> Your intention is to add the thread case to support pthreads once the
>> process case is sorted out.  So this is something that needs to be made
>> clear.  Did I miss how you plan to handle threads?
>>
>> And this fundamentally and definitely gets into all of my concerns about
>> proper handling of pid_task and PIDTYPE_TGID etc.
>
> To the extent that it's possible, this system call should mimic the
> behavior of a signal-send to a positive numeric PID (i.e., a specific
> task), so if we change one, we should change both.

There is a special case in kill(2) where we treat an identifier that
only identifies a thread as an identifier of a process.  We should
not copy that.

Making kill(2) only accept the pid of thread group leaders would make
all kinds of sense.  Unfortunately we need to stay bug compatible with
past versions of linux.  So kill(2) won't be changing unless it appears
clear that not a single application cares about that case.

I will eventually be changing kill(2) to not sending signals through
zombie group leaders so the permission checks are performed correctly.

All I am asking is that we don't copy that bug compatibility code into a
new system call, and that use use the current internal APIs in a fashion
that shows you are not replicating misfeatures of old system calls.

I know it takes understanding a little more kernel code but for people
designing a signal sending API it is not unreasonable to ask that they
understand the current APIs and the current code.  The fact that this
discussion has revealed some significant misconceptions of how the
current code works, and what I am asking for concerns me.

Eric
