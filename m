From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_open(2) manual page
Date: Mon, 23 Sep 2019 22:22:07 +0200
Message-ID: <41e5ddd9-6935-7743-46aa-080d9a08a8bd@gmail.com>
References: <90399dee-53d8-a82c-3871-9ec8f94601ce@gmail.com>
 <87tv939td6.fsf@mid.deneb.enyo.de>
 <20190923144711.ssbrg6bdquhewo7q@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190923144711.ssbrg6bdquhewo7q@wittgenstein>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>
Cc: mtk.manpages@gmail.com, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

Hello Christian,

On 9/23/19 4:47 PM, Christian Brauner wrote:
> On Mon, Sep 23, 2019 at 12:53:09PM +0200, Florian Weimer wrote:
>> * Michael Kerrisk:
>>
>>> SYNOPSIS
>>>        int pidfd_open(pid_t pid, unsigned int flags);
>>
>> Should this mention <sys/types.h> for pid_t?
>>
>>> ERRORS
>>>        EINVAL flags is not 0.
>>>
>>>        EINVAL pid is not valid.
>>>
>>>        ESRCH  The process specified by pid does not exist.
>>
>> Presumably, EMFILE and ENFILE are also possible errors, and so is
>> ENOMEM.
> 
> So, error codes that could surface are:
> EMFILE: too many open files
> ENODEV: the anon inode filesystem is not available in this kernel (unlikely)
> ENOMEM: not enough memory (to allocate the backing struct file)
> ENFILE: you're over the max_files limit which can be set through proc
> 
> I think that should be it.

Thanks. I've added those.
>>>        A  PID  file descriptor can be monitored using poll(2), select(2),
>>>        and epoll(7).  When the process that it refers to terminates,  the
>>>        file descriptor indicates as readable.  Note, however, that in the
>>>        current implementation, nothing can be read from the file descrip‐
>>>        tor.
>>
>> “is indicated as readable” or “becomes readable”?  Will reading block?
>>
>>>        The  pidfd_open()  system call is the preferred way of obtaining a
>>>        PID file descriptor.  The alternative is to obtain a file descrip‐
>>>        tor by opening a /proc/[pid] directory.  However, the latter tech‐
>>>        nique is possible only if the proc(5) file system is mounted; fur‐
>>>        thermore,  the  file  descriptor  obtained in this way is not pol‐
>>>        lable.
>>
>> One question is whether the glibc wrapper should fall back back to the
>> /proc subdirectory if it is not available.  Probably not.
> 
> No, that would not be transparent to userspace. Especially because both
> fds differ in what can be done with them.
> 
>>
>>>        static
>>>        int pidfd_open(pid_t pid, unsigned int flags)
>>>        {
>>>            return syscall(__NR_pidfd_open, pid, flags);
>>>        }
>>
>> Please call this function something else (not pidfd_open), so that the
>> example continues to work if glibc provides the system call wrapper.
> 
> Agreed!

See my reply to Florian. (So far, I didn't change anything here.)

Thanks,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
