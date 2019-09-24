From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Tue, 24 Sep 2019 21:43:38 +0200
Message-ID: <f4330496-f34e-59f2-6de4-0aafdf639c7a@gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <87pnjr9rth.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87pnjr9rth.fsf@mid.deneb.enyo.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: mtk.manpages@gmail.com, Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello Florian,

On 9/23/19 1:26 PM, Florian Weimer wrote:
> * Michael Kerrisk:
> 
>> SYNOPSIS
>>        int pidfd_send_signal(int pidfd, int sig, siginfo_t info,
>>                              unsigned int flags);
> 
> This probably should reference a header for siginfo_t.

Thanks. I added: #include <signal.h>

>>        ESRCH  The target process does not exist.
> 
> If the descriptor is valid, does this mean the process has been waited
> for?  Maybe this can be made more explicit.

Yes. I added "(i.e., it has terminated and been waited on)".

>>        The  pidfd_send_signal()  system call allows the avoidance of race
>>        conditions that occur when using traditional interfaces  (such  as
>>        kill(2)) to signal a process.  The problem is that the traditional
>>        interfaces specify the target process via a process ID (PID), with
>>        the  result  that the sender may accidentally send a signal to the
>>        wrong process if the originally intended target process has termi‐
>>        nated  and its PID has been recycled for another process.  By con‐
>>        trast, a PID file descriptor is a stable reference to  a  specific
>>        process;  if  that  process  terminates,  then the file descriptor
>>        ceases to be  valid  and  the  caller  of  pidfd_send_signal()  is
>>        informed of this fact via an ESRCH error.
> 
> It would be nice to explain somewhere how you can avoid the race using
> a PID descriptor.  Is there anything else besides CLONE_PIDFD?

Please see my comment in reply to Christian (which will be sent just
after this).

>>        static
>>        int pidfd_send_signal(int pidfd, int sig, siginfo_t *info,
>>                unsigned int flags)
>>        {
>>            return syscall(__NR_pidfd_send_signal, pidfd, sig, info, flags);
>>        }
> 
> Please use a different function name.  Thanks.

Please see my open question in the thread on pidfd_open().

Thanks for the review, Florian.

Cheers,

Michael

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
