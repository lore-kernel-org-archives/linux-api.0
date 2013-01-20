From: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [CRIU] [PATCH 2/3] signalfd: add ability to return siginfo in a
 raw format (v2)
Date: Sun, 20 Jan 2013 21:41:54 +0400
Message-ID: <20130120174153.GA5675@paralelels.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
 <1358182435-19245-3-git-send-email-avagin@openvz.org>
 <20130116123502.70af6b85.akpm@linux-foundation.org>
 <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
 <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
 <CAKgNAkjK9iWh_PuJ92A-MKW6Q6_B8DvTL5-fkxyULqx9ZoDPfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkjK9iWh_PuJ92A-MKW6Q6_B8DvTL5-fkxyULqx9ZoDPfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


> > signalfd is a special descriptor, so I think it
> > is not a big deal, that it works a bit strange.
> 
> Sure, but the more we special case things, the uglier the ABI as a
> whole becomes. So special casing should be avoided as far as we can.
> 
> > If all other would
> > decides, that a new syscall is better, I will not ague.
> 
> And that's more or less how I see it too. I'm not going to argue for a
> new syscall, based on what I know so far.
> 
> Here is one idea to think about though, while more or less maintaining
> your proposed interface.
> 
> At the moment, you select signal queues in the pread() call. An
> alternative would be to do it in the signalfd() call. In other words,
> you could have the following flags used with signalfd()
> 
> SFD_RAW
> SFD_SHARED_QUEUE -- reads will be from process-wide shared signal queue
> SFD_PER_THREAD_QUEUE --reads will be from per-thread signal queue

I suggested this variant in the initial series, but then we decided to
avoid adding new flags. Oleg, what do you think about this?

> 
> Specifying both SFD_SHARED_QUEUE  and SFD_PER_THREAD_QUEUE would be
> the same as omitting them both, providing the default behavior of
> slecting from both queues.
> 
> My point here is that you can then separate the RAW functionality from
> the queue selector functionality. Now, it might be that at the moment
> you always require that if the caller specifies SFD_SHARED_QUEUE  or
> SFD_PER_THREAD_QUEUE, then they must also specify SFD_RAW. But later,
> that constraint might be relaxed, so that users could use signalfd()
> to select from a particular queue when reading traditional (non-RAW)
> signalfd_siginfo structures from a signalfd.

I am not sure, that you understood this moment correctly.
Currently SFD_RAW is independent on SFD_*_QUEUE. If signalfd is
created without SFD_RAW, pread returns signalfd_siginfo-s.
If SFD_RAW is set, read returns siginfo_t-s.

One more point for two flags is that we will be able to choose a queue
from which signals will be dequeued. Currently we can choose a queue only
for pread.

Thanks

> This does seem like a
> very sensible design optimization to make now (and an easy one, I
> would suppose). What do you think?
> 
> Cheers,
> 
> Michael
