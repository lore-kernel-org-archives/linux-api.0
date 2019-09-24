From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Tue, 24 Sep 2019 21:44:49 +0200
Message-ID: <90dd38d5-34b3-b72f-8e5a-b51f944f22fb@gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <87pnjr9rth.fsf@mid.deneb.enyo.de>
 <20190923142325.jowzbnwjw7g7si7j@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190923142325.jowzbnwjw7g7si7j@wittgenstein>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>
Cc: mtk.manpages@gmail.com, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello Christian,

On 9/23/19 4:23 PM, Christian Brauner wrote:
> On Mon, Sep 23, 2019 at 01:26:34PM +0200, Florian Weimer wrote:
>> * Michael Kerrisk:
>>
>>> SYNOPSIS
>>>        int pidfd_send_signal(int pidfd, int sig, siginfo_t info,
>>>                              unsigned int flags);
>>
>> This probably should reference a header for siginfo_t.
> 
> Agreed.
> 
>>
>>>        ESRCH  The target process does not exist.
>>
>> If the descriptor is valid, does this mean the process has been waited
>> for?  Maybe this can be made more explicit.
> 
> If by valid you mean "refers to a process/thread-group leader" aka is a
> pidfd then yes: Getting ESRCH means that the process has exited and has
> already been waited upon.
> If it had only exited but not waited upon aka is a zombie, then sending
> a signal will just work because that's currently how sending signals to
> zombies works, i.e. if you only send a signal and don't do any
> additional checks you won't notice a difference between a process being
> alive and a process being a zombie. The userspace visible behavior in
> terms of signaling them is identical.

(Thanks for the clarification. I added the text "(i.e., it has 
terminated and been waited on)" to the ESRCH error.)

>>>        The  pidfd_send_signal()  system call allows the avoidance of race
>>>        conditions that occur when using traditional interfaces  (such  as
>>>        kill(2)) to signal a process.  The problem is that the traditional
>>>        interfaces specify the target process via a process ID (PID), with
>>>        the  result  that the sender may accidentally send a signal to the
>>>        wrong process if the originally intended target process has termi‐
>>>        nated  and its PID has been recycled for another process.  By con‐
>>>        trast, a PID file descriptor is a stable reference to  a  specific
>>>        process;  if  that  process  terminates,  then the file descriptor
>>>        ceases to be  valid  and  the  caller  of  pidfd_send_signal()  is
>>>        informed of this fact via an ESRCH error.
>>
>> It would be nice to explain somewhere how you can avoid the race using
>> a PID descriptor.  Is there anything else besides CLONE_PIDFD?
> 
> If you're the parent of the process you can do this without CLONE_PIDFD:
> pid = fork();
> pidfd = pidfd_open();
> ret = pidfd_send_signal(pidfd, 0, NULL, 0);
> if (ret < 0 && errno == ESRCH)
> 	/* pidfd refers to another, recycled process */

Although there is still the race between the fork() and the
pidfd_open(), right?

>>>        static
>>>        int pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
>>>                unsigned int flags)
>>>        {
>>>            return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
>>>        }
>>
>> Please use a different function name.  Thanks.

Covered in another thread. I await some further feedback from Florian.

Thanks,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
