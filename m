From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Edited seccomp.2 man page for review [v2]
Date: Wed, 07 Jan 2015 12:53:27 +0100
Message-ID: <54AD1E37.8020509@gmail.com>
References: <54A29722.1010901@gmail.com>	<CAGXu5j+C0SWQ+CeOb2ADXdsLWorUHahX4UhUg+UGbT6UuWiQFQ@mail.gmail.com>	<54A300D0.7090802@gmail.com> <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jKCR8ft=2XNX+SsCOokEqCt9sZizKj4wfAGrXVzf6adcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Kees,

On 01/05/2015 09:25 PM, Kees Cook wrote:
> On Tue, Dec 30, 2014 at 11:45 AM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> The program counter will be as though the system call happened
>>>> (i.e., it will not point to the system call instruction).
>>>> The return value register will contain an architecture\-dependent value;
>>>> if resuming execution, set it to something sensible.
>>>> .\" FIXME Regarding the preceding line, can you give an example(s)
>>>> .\"       of "something sensible"? (Depending on the answer, maybe it
>>>> .\"       might be useful to add some text on this point.)
>>>
>>> This means sensible in the context of the syscall made, or the desired
>>> behavior. For example, setting the return value to ELOOP for something
>>> like a "bind" syscall isn't very sensible.
>>
>> Okay -- I did s/sensible/appropriate for the system call/
> 
> Yes, perfect. That captures it nicely.

Okay.

>>>> .\"
>>>> .\" FIXME Please check:
>>>> .\"     In an attempt to make the text clearer, I changed
>>>> .\"     "replacing it with" to "setting the return value register to"
>>>> .\"     Okay?
>>>> (The architecture dependency is because setting the return value register to
>>>> .BR ENOSYS
>>>> could overwrite some useful information.)
>>>
>>> Well, the arch dependency is really because _how_ to change the
>>> register, and the register itself, is different between architectures.
>>> (i.e. which ptrace call is needed, and which register is being
>>> changed.) The overwriting of useful information is certainly true too,
>>> though.
>>
>> So, revert to the previous wording? Or do you have a suggested
>> better wording?
> 
> I think the previous wording is better. I'm struggling to produce
> language that makes more sense here.

Okay -- reverted.

>> Thanks. We're getting close now.
> 
> Excellent! :)

Still hoping to hear from Will Drewy regarding this FIXME in the 
page source:

.\" FIXME What is the significance of the line
.\"           ftest->code = BPF_LDX | BPF_W | BPF_ABS;
.\"       in kernel/seccomp.c::seccomp_check_filter()?

Do you know if he's about?

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
