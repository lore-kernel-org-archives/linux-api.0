From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
Date: Wed, 11 Jun 2014 00:22:26 +0400
Message-ID: <20140610202226.GG2243@moon>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de>
 <20140610163530.GF2243@moon>
 <CAKgNAkiR2xt7xnkgGDg5zKfGRoPtveWG8Jjh5=aD76L6jK7C8w@mail.gmail.com>
 <CALCETrV5augTv4bXFmfnifiAGZGw2DfNHrpBUYAp_bBsJvWRBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrV5augTv4bXFmfnifiAGZGw2DfNHrpBUYAp_bBsJvWRBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andrey Vagin <avagin@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, vdavydov@parallels.com, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 10, 2014 at 01:05:22PM -0700, Andy Lutomirski wrote:
> On Tue, Jun 10, 2014 at 1:03 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
> > [CC += linux-api@]

Thanks Michael!

> > On Tue, Jun 10, 2014 at 6:35 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> >> On Thu, May 22, 2014 at 06:58:19AM +0900, Thomas Gleixner wrote:
> >>> >
> >>> > So what wakes a potential waiter in read/poll?
> >>>
> >>> And who is updating timerfd_create(2) ?
> >>
> >> Thomas, could you please take a look if the approach below is acceptable?
> >> If it will be fine I update manpage then.
> >> ---
> >> From: Cyrill Gorcunov <gorcunov@openvz.org>
> >> Subject: timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks
> >>
> >> The read() of timerfd files allows to fetch the number of timer ticks
> >> while there is no way to set it back from userspace.
> >>
> >> To restore the timer's state as it was at checkpoint moment we need
> >> a path to bring @ticks back. Initially I thought about writing ticks
> >> back via write() interface but it seems such API is somehow obscure.
> >>
> >> Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
> >> command which requires CAP_SYS_RESOURCE capability to be able to
> >> set @ticks into arbitrary value. Note this command doesn't wake
> >> up readers/waiters and its purpose only to serve C/R needs
> >> (for same sake I wrapped code with CONFIG_CHECKPOINT_RESTORE).
> >> Still if needed the ioctl may be extended for new commands
> >> and CONFIG_CHECKPOINT_RESTORE dropped off.
> 
> Why does this need CAP_SYS_RESOURCE?

  Because I think this interface should not be used by a regular
applications, the only purpose is to restore the @ticks after
checkpoint. Requiring CAP_SYS_RESOURCE means that at least
program which use it knows what it's doing.

  Still if someone has a scenarion where we might need this
intarface out of this cap requirement -- we always can
drop it of without breaking existing users, but not the
reverse.

P.S. I remember Thomas' words about existence of the other
word out of c/r, still I treat this ioctl as exception
(as in prctl codes we use for c/r).
