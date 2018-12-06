From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v4] signal: add taskfd_send_signal() syscall
Date: Thu, 06 Dec 2018 07:40:24 -0600
Message-ID: <87efaun587.fsf@xmission.com>
References: <20181206121858.12215-1-christian@brauner.io>
        <87h8fq7s84.fsf@oldenburg2.str.redhat.com>
        <b0e946bcac12358841c9a99017da819b00794d9c.camel@bitron.ch>
        <87pnue6bp2.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87pnue6bp2.fsf@oldenburg2.str.redhat.com> (Florian Weimer's
        message of "Thu, 06 Dec 2018 14:12:41 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: =?utf-8?Q?J=C3=BCrg?= Billeter <j@bitron.ch>, Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, luto@kernel.org, arnd@arndb.de, serge@hallyn.com, jannh@google.com, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Florian Weimer <fweimer@redhat.com> writes:

> * Jürg Billeter:
>
>> On Thu, 2018-12-06 at 13:30 +0100, Florian Weimer wrote:
>>> * Christian Brauner:
>>> 
>>> > /* zombies */
>>> > Zombies can be signaled just as any other process. No special error will be
>>> > reported since a zombie state is an unreliable state (cf. [3]).
>>> 
>>> I still disagree with this analysis.  If I know that the target process
>>> is still alive, and it is not, this is a persistent error condition
>>> which can be reliably reported.  Given that someone might send SIGKILL
>>> to the process behind my back, detecting this error condition could be
>>> useful.
>>
>> As I understand it, kill() behaves the same way. I think it's good that
>> this new syscall keeps the behavior as close as possible to kill().
>
> No, kill does not behave in this way because the PID can be reused.
> The error condition is not stable there.

I am not quite certain what is being discussed here.

Posix says:
    [ESRCH]
        No process or process group can be found corresponding to that specified by pid.

The linux man page says:
       ESRCH  The process or process group does not exist.  Note that an
              existing process might be a zombie, a process that has terminated
              execution, but has not yet been wait(2)ed for.

What happens with this new system call is exactly the linux behavior.
Success is returned until the specified process or thread group has
been waited for.

The only difference from the behavior of kill is that because the
association between the file descriptor and the pid is not affected by
pid reuse once ESRCH is returned ESRCH will always be returned.

Floriam are you seeing a problem with this behavior or the way Christian
was describing it?

Eric
