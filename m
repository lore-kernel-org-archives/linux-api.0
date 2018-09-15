From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v2 4/5] pselect6: use __kernel_timespec
Date: Sat, 15 Sep 2018 12:04:11 -0700
Message-ID: <CABeXuvrU_B0gFhdHiYvEAUgDMso_94=M8iPJj+w7N1LnGMrKAw@mail.gmail.com>
References: <20180915050843.19183-1-deepa.kernel@gmail.com>
 <20180915050843.19183-5-deepa.kernel@gmail.com> <CAK8P3a2Kkm2ubg_MVN_BJL=s7qpUB1-np=9zVpcJ2U-aPAJswg@mail.gmail.com>
 <CABeXuvoOEW9+5BPiDN+2S1boyMSg+csvSAd4ue03TB+yEO6dLg@mail.gmail.com> <alpine.DEB.2.21.1809152039440.1650@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <alpine.DEB.2.21.1809152039440.1650@nanos.tec.linutronix.de>
Sender: owner-linux-aio@kvack.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-aio <linux-aio@kvack.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 15, 2018 at 11:42 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Sat, 15 Sep 2018, Deepa Dinamani wrote:
>
> > On Sat, Sep 15, 2018 at 8:28 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Sat, Sep 15, 2018 at 7:09 AM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> > >
> > > > +#if defined(CONFIG_64BIT_TIME)
> > > > +
> > > > +COMPAT_SYSCALL_DEFINE6(pselect6_time64, int, n, compat_ulong_t __user *, inp,
> > > > +       compat_ulong_t __user *, outp, compat_ulong_t __user *, exp,
> > > > +       struct __kernel_timespec __user *, tsp, void __user *, sig)
> > >
> > > I got a link error here since compat_sys_pselect6_time64 and
> > > compat_sys_ppoll_time64 are only defined when CONFIG_64BIT_TIME
> > > is set.
> > >
> > > I did not think we would select this symbol on arm64, is that a mistake
> > > on my side, or should the #ifdef check be removed?
> >
> > But, this is a compat syscall.
> > When we introduced this CONFIG_64BIT_TIME we planned to use it for
> > compat syscalls also is my understanding.
> >
> > config 64BIT_TIME
> >          def_bool ARCH_HAS_64BIT_TIME
> >          help
> >           This should be selected by all architectures that need to support
> >            new system calls with a 64-bit time_t. This is relevant on all 32-bit
> >            architectures, and 64-bit architectures as part of compat syscall
> >            handling.
> >
> > This means it should be set on 64 bit architechtures also right?
>
> It's only set when 32bit compat mode is enabled on the 64bit kernel.

Ok, then we could delete the #ifdef like Arnd suggested. So this will
be defined for all architectures that enable CONFIG_COMPAT
unconditionally.
I will post an updated version.

Thanks,
Deepa

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
