From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
 dequeuing signals (v2)
Date: Fri, 8 Feb 2013 01:51:29 +0100
Message-ID: <CAKgNAkhrtkfeq1+_W-fK1+H5=teSoCJEA7dzzg5kmyOFGvw92g@mail.gmail.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <1359486181-29088-1-git-send-email-avagin@openvz.org> <20130207173447.GA5888@redhat.com>
 <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrey Wagin <avagin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 7, 2013 at 10:13 PM, Andrey Wagin <avagin@gmail.com> wrote:
> 2013/2/7 Oleg Nesterov <oleg@redhat.com>:
>> Andrey, sorry for delay.
>>
>> As for API, I leave this to you and Michael. Not that I like these
>> new flags, but I agree that pread() hack was not pretty too.
>>
>> On 01/29, Andrey Vagin wrote:

[...]

>>Damn. But after I wrote this email I realized that llseek() probably can't
>> work. Because peek_offset/f_pos/whatever has to be shared with all processes
>> which have this file opened.
>>
>> Suppose that the task forks after sys_signalfd(). Now if parent or child
>> do llseek this affects them both. This is insane because signalfd is
>> "strange" to say at least, fork/dup/etc inherits signalfd_ctx but not the
>> "source" of the data.

(Good catch, Oleg.)

> So I want to suggest a way how to forbid read() for SIGNALFD_PEEK.
> file->f_pos can be initialized to -1. read() returns EINVAL in this
> case. In a man page we will write that signals can be dumped only with
> help pread(). Is it overload or too ugly?

>From an interface perspective I have no problem with limiting the API
to allow just pread(). If we later decide that there is some way that
the semantics using read() + lseek() could be sensible (which seems
unlikely), we could relax things and allow read().

[...]

> Oleg, thank you for the comments. I'm waiting an answer on the
> question and after that I'm going to send a final version.

It would be nice if the new patch series has a changelog of the
changes to date, and also includes a fairly detailed description of
the user-space API. Would that be possible?

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
