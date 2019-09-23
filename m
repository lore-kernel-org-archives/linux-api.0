From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_open(2) manual page
Date: Mon, 23 Sep 2019 22:22:22 +0200
Message-ID: <39790bc7-f417-1172-0f06-5cdefabda7e1@gmail.com>
References: <90399dee-53d8-a82c-3871-9ec8f94601ce@gmail.com>
 <87tv939td6.fsf@mid.deneb.enyo.de>
 <CAKOZuetTgKjgWZpCaBz8q662MwVQ-UhrV4oWFqKEWr35mQTFLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetTgKjgWZpCaBz8q662MwVQ-UhrV4oWFqKEWr35mQTFLw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>, Florian Weimer <fw@deneb.enyo.de>
Cc: mtk.manpages@gmail.com, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

Hello Daniel,

Than you for reviewing the page!

On 9/23/19 1:26 PM, Daniel Colascione wrote:
> On Mon, Sep 23, 2019 at 3:53 AM Florian Weimer <fw@deneb.enyo.de> wrote:
>>
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
>>
>>>        A  PID  file descriptor can be monitored using poll(2), select(2),
>>>        and epoll(7).  When the process that it refers to terminates,  the
>>>        file descriptor indicates as readable.
> 
> The phrase "becomes readable" is simpler than "indicates as readable"
> and conveys the same meaning. I agree with Florian's comment on this
> point below.

See my reply to Florian. (I did change the text here.)

>>> Note, however, that in the
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
> 
> Referring to procfs directory FDs as pidfds will probably confuse
> people. I'd just omit this paragraph.

See my reply to Christian (and feel free to argue the point, please).
So far, I have made no change here.

>> One question is whether the glibc wrapper should fall back back to the
>> /proc subdirectory if it is not available.  Probably not.
> 
> I'd prefer that glibc not provide this kind of fallback.
> posix_fallocate-style emulation is, IMHO, too surprising.

Agreed.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
