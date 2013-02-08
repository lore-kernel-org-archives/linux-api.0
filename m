From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
 dequeuing signals (v2)
Date: Fri, 8 Feb 2013 21:15:16 +0100
Message-ID: <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <1359486181-29088-1-git-send-email-avagin@openvz.org> <20130207173447.GA5888@redhat.com>
 <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com> <20130208191056.GA13674@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130208191056.GA13674-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 8, 2013 at 8:10 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/08, Andrey Wagin wrote:
>>
>> 2013/2/7 Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > Andrey, sorry for delay.
>> >
>> > As for API, I leave this to you and Michael. Not that I like these
>> > new flags, but I agree that pread() hack was not pretty too.
>> >
>> > On 01/29, Andrey Vagin wrote:
>> >> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
>> >> +                             siginfo_t *info, loff_t *ppos, int queue_mask)
>> >> +{
>> >> +     loff_t seq = *ppos / sizeof(struct signalfd_siginfo);
>> >> +     int signr = 0;
>> >> +
>> >> +     if (queue_mask & SIGQUEUE_PRIVATE)
>> >> +             signr = peek_signal(&current->pending,
>> >> +                                     &ctx->sigmask, info, &seq);
>> >> +     else if (queue_mask & SIGQUEUE_SHARED)
>> >> +             signr = peek_signal(&current->signal->shared_pending,
>> >> +                                      &ctx->sigmask, info, &seq);
>> >> +     (*ppos) += sizeof(struct signalfd_siginfo);
>> >
>> > Now that this can work even with normal read(), we will actually change
>> > f_pos. Then perhaps signalfd_fops->llseek() should work too. But this
>> > is minor...
>>
>> lseek works only if FMODE_LSEEK is set.
>>
>> You have explained why read&lseek have strange semantics for SIGNALFD_PEEK.
>>
>> >Damn. But after I wrote this email I realized that llseek() probably can't
>> > work. Because peek_offset/f_pos/whatever has to be shared with all processes
>> > which have this file opened.
>
> Yes. but I thought you decided to ignore this oddity ;)
>
>> So I want to suggest a way how to forbid read() for SIGNALFD_PEEK.
>> file->f_pos can be initialized to -1. read() returns EINVAL in this
>> case. In a man page we will write that signals can be dumped only with
>> help pread(). Is it overload or too ugly?
>
> Well. I do not know. Up to you and Michael.
>
> But honestly, I can't say this all looks really nice. And why do we
> need SIGNALFD_PEEK then?

It surely is no beauty. The hope is at least to make it less ugly than it was.

> Seriously, perhaps we should simply add signalfd_fops->ioctl() for PEEK.
> Or add PTRACE_{PEEK,POKE}_SIGNAL which looks even logical and useful...
> And much simpler/straightforward.
>
> But I am not going to argue.

I suppose I had wondered along similar lines, but in a slightly
different direction: would the use of a /proc interface to get the
queued signals make some sense?

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
