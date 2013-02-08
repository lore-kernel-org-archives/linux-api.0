From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
	dequeuing signals (v2)
Date: Fri, 8 Feb 2013 20:10:56 +0100
Message-ID: <20130208191056.GA13674@redhat.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org> <1359486181-29088-1-git-send-email-avagin@openvz.org> <20130207173447.GA5888@redhat.com> <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANaxB-xmSiPfbUAh+rQSgVxBzTXmVQcC7U741WYKaasG3_yc5w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrey Wagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

On 02/08, Andrey Wagin wrote:
>
> 2013/2/7 Oleg Nesterov <oleg@redhat.com>:
> > Andrey, sorry for delay.
> >
> > As for API, I leave this to you and Michael. Not that I like these
> > new flags, but I agree that pread() hack was not pretty too.
> >
> > On 01/29, Andrey Vagin wrote:
> >> +static ssize_t signalfd_peek(struct signalfd_ctx *ctx,
> >> +                             siginfo_t *info, loff_t *ppos, int queue_mask)
> >> +{
> >> +     loff_t seq = *ppos / sizeof(struct signalfd_siginfo);
> >> +     int signr = 0;
> >> +
> >> +     if (queue_mask & SIGQUEUE_PRIVATE)
> >> +             signr = peek_signal(&current->pending,
> >> +                                     &ctx->sigmask, info, &seq);
> >> +     else if (queue_mask & SIGQUEUE_SHARED)
> >> +             signr = peek_signal(&current->signal->shared_pending,
> >> +                                      &ctx->sigmask, info, &seq);
> >> +     (*ppos) += sizeof(struct signalfd_siginfo);
> >
> > Now that this can work even with normal read(), we will actually change
> > f_pos. Then perhaps signalfd_fops->llseek() should work too. But this
> > is minor...
>
> lseek works only if FMODE_LSEEK is set.
>
> You have explained why read&lseek have strange semantics for SIGNALFD_PEEK.
>
> >Damn. But after I wrote this email I realized that llseek() probably can't
> > work. Because peek_offset/f_pos/whatever has to be shared with all processes
> > which have this file opened.

Yes. but I thought you decided to ignore this oddity ;)

> So I want to suggest a way how to forbid read() for SIGNALFD_PEEK.
> file->f_pos can be initialized to -1. read() returns EINVAL in this
> case. In a man page we will write that signals can be dumped only with
> help pread(). Is it overload or too ugly?

Well. I do not know. Up to you and Michael.

But honestly, I can't say this all looks really nice. And why do we
need SIGNALFD_PEEK then?

Seriously, perhaps we should simply add signalfd_fops->ioctl() for PEEK.
Or add PTRACE_{PEEK,POKE}_SIGNAL which looks even logical and useful...
And much simpler/straightforward.

But I am not going to argue.

Oleg.

