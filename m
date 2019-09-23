From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_open(2) manual page
Date: Mon, 23 Sep 2019 22:20:31 +0200
Message-ID: <63566f1f-667d-50ca-ae85-784924d09af4@gmail.com>
References: <90399dee-53d8-a82c-3871-9ec8f94601ce@gmail.com>
 <87tv939td6.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tv939td6.fsf@mid.deneb.enyo.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: mtk.manpages@gmail.com, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

Hello Florian,

Thanks for taking a look at this page.

On 9/23/19 12:53 PM, Florian Weimer wrote:
> * Michael Kerrisk:
> 
>> SYNOPSIS
>>        int pidfd_open(pid_t pid, unsigned int flags);
> 
> Should this mention <sys/types.h> for pid_t?

Seems reasonable. I added this.

>> ERRORS
>>        EINVAL flags is not 0.
>>
>>        EINVAL pid is not valid.
>>
>>        ESRCH  The process specified by pid does not exist.
> 
> Presumably, EMFILE and ENFILE are also possible errors, and so is
> ENOMEM.

Thanks. I've added those.

>>        A  PID  file descriptor can be monitored using poll(2), select(2),
>>        and epoll(7).  When the process that it refers to terminates,  the
>>        file descriptor indicates as readable.  Note, however, that in the
>>        current implementation, nothing can be read from the file descrip‐
>>        tor.
> 
> “is indicated as readable” or “becomes readable”?  Will reading block?

It won't block. Reads from a pidfd always fail with the error EINVAL
(regardless of whether the target process has terminated).

I specifically wanted to avoid "becomes readable" to avoid any
suggestion that read() does something for a pidfd. I thought 
"indicates as readable" was fine, but you, Christian and Joel 
all called this wording out, so I changed this to:

"When the process that it refers to terminates,
these interfaces indicate the file descriptor as readable."

>>        The  pidfd_open()  system call is the preferred way of obtaining a
>>        PID file descriptor.  The alternative is to obtain a file descrip‐
>>        tor by opening a /proc/[pid] directory.  However, the latter tech‐
>>        nique is possible only if the proc(5) file system is mounted; fur‐
>>        thermore,  the  file  descriptor  obtained in this way is not pol‐
>>        lable.
> 
> One question is whether the glibc wrapper should fall back back to the
> /proc subdirectory if it is not available.  Probably not.

No, since the FD returned by opening /proc/PID is less functional
(it is not pollable) than the one returned by pidfd_open().

>>        static
>>        int pidfd_open(pid_t pid, unsigned int flags)
>>        {
>>            return syscall(__NR_pidfd_open, pid, flags);
>>        }
> 
> Please call this function something else (not pidfd_open), so that the
> example continues to work if glibc provides the system call wrapper.

I figured that if the syscall does get added to glibc, then I would
modify the example. In the meantime, this does seem the most natural
way of doing things, since the example then uses the real syscall
name as it would be used if there were a wrapper function.
 
But, this leads to the question: what do you think the likelihood
is that this system call will land in glibc?

Thanks for your feedback, Florian. I've pushed various changes
to the Git branch at 
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_pidfd

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
