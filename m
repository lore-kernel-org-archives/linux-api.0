From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v3 4/5] pselect6: use __kernel_timespec
Date: Mon, 17 Sep 2018 14:16:09 -0700
Message-ID: <CABeXuvrZHRLjiyqs_rGXWCKqjiWXkQPBr=mHntpZ6xdoc3z_Zg@mail.gmail.com>
References: <20180917010458.23159-1-deepa.kernel@gmail.com>
 <20180917010458.23159-5-deepa.kernel@gmail.com> <20180917203438.maary2eo64dbuhw2@sghpc.golosunov.pp.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917203438.maary2eo64dbuhw2@sghpc.golosunov.pp.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: stepan@golosunov.pp.ru
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, y2038 Mailman List <y2038@lists.linaro.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-aio <linux-aio@kvack.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 17, 2018 at 1:34 PM Stepan Golosunov <stepan@golosunov.pp.ru> wrote:
>
> On Sun, Sep 16, 2018 at 06:04:57PM -0700, Deepa Dinamani wrote:
> >  static long do_compat_pselect(int n, compat_ulong_t __user *inp,
> >       compat_ulong_t __user *outp, compat_ulong_t __user *exp,
> > -     struct old_timespec32 __user *tsp, compat_sigset_t __user *sigmask,
> > -     compat_size_t sigsetsize)
> > +     void __user *tsp, compat_sigset_t __user *sigmask,
> > +     compat_size_t sigsetsize, enum poll_time_type type)
> >  {
> >       sigset_t ksigmask, sigsaved;
> >       struct timespec64 ts, end_time, *to = NULL;
> >       int ret;
> >
> >       if (tsp) {
> > -             if (get_old_timespec32(&ts, tsp))
> > -                     return -EFAULT;
> > +             switch (type) {
> > +             case PT_OLD_TIMESPEC:
> > +                     if (get_old_timespec32(&ts, tsp))
> > +                             return -EFAULT;
> > +                     break;
> > +             case PT_TIMESPEC:
> > +                     if (get_old_timespec32(&ts, tsp))
> > +                             return -EFAULT;
> > +                     break;
> > +             default:
> > +                     BUG();
> > +             }
>
> One of the two get_old_timespec32 calls here should be
> get_timespec64.

Right. It is a copy paste bug.

Thanks,
Deepa
