From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 06 Dec 2018 13:17:24 -0600
Message-ID: <875zw6bh2z.fsf@xmission.com>
References: <20181206121858.12215-1-christian@brauner.io>
        <87sgzahf7k.fsf@xmission.com>
        <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D372C766-572C-4897-8F02-2FD0E72CCFAC@brauner.io> (Christian
        Brauner's message of "Fri, 07 Dec 2018 06:14:34 +1300")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, fweimer@redhat.com, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Christian Brauner <christian@brauner.io> writes:

> On December 7, 2018 4:01:19 AM GMT+13:00, ebiederm@xmission.com wrote:
>>Christian Brauner <christian@brauner.io> writes:
>>
>>> The kill() syscall operates on process identifiers (pid). After a
>>process
>>> has exited its pid can be reused by another process. If a caller
>>sends a
>>> signal to a reused pid it will end up signaling the wrong process.
>>This
>>> issue has often surfaced and there has been a push [1] to address
>>this
>>> problem.
>>>
>>> This patch uses file descriptors (fd) from proc/<pid> as stable
>>handles on
>>> struct pid. Even if a pid is recycled the handle will not change. The
>>fd
>>> can be used to send signals to the process it refers to.
>>> Thus, the new syscall taskfd_send_signal() is introduced to solve
>>this
>>> problem. Instead of pids it operates on process fds (taskfd).
>>
>>I am not yet thrilled with the taskfd naming.
>
> Userspace cares about what does this thing operate on?
> It operates on processes and threads.
> The most common term people use is "task".
> I literally "polled" ten non-kernel people for that purpose and asked:
> "What term would you use to refer to a process and a thread?"
> Turns out it is task. So if find this pretty apt.
> Additionally, the proc manpage uses task in the exact same way (also see the commit message).
> If you can get behind that name even if feeling it's not optimal it would be great.

Once I understand why threads and not process groups.  I don't see that
logic yet.

>>Is there any plan to support sesssions and process groups?
>
> I don't see the necessity.
> As I said in previous mails:
> we can emulate all interesting signal syscalls with this one.

I don't know what you mean by all of the interesting signal system
calls.  I do know you can not replicate kill(2).

Sending signals to a process group the "kill(-pgrp)" case with kill
sends the signals to an atomic snapshot of processes.  If the signal
is SIGKILL then it is guaranteed that then entire process group is
killed with no survivors.

> We succeeded in doing that.

I am not certain you have.

> No need to get more fancy.
> There's currently no obvious need for more features.
> Features should be implemented when someone actually needs them.

That is fair.  I don't understand what you are doing with sending
signals to a thread.  That seems like one of the least useful
corner cases of sending signals.

Eric
