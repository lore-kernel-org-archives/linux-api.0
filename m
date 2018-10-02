From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Tue, 2 Oct 2018 22:05:15 +0100
Message-ID: <CAJwJo6a+WWpAxVAUuYt8TrCF+1a=BdoFQjU9vto0iiUN5vygsA@mail.gmail.com>
References: <20180919205037.9574-1-dima@arista.com> <874lej6nny.fsf@xmission.com>
 <20180924205119.GA14833@outlook.office365.com> <874leezh8n.fsf@xmission.com>
 <20180925014150.GA6302@outlook.office365.com> <87zhw4rwiq.fsf@xmission.com>
 <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1809272335430.8118@nanos.tec.linutronix.de>
 <20181001232033.GA31324@outlook.office365.com> <alpine.DEB.2.21.1810020811290.32062@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1810020811290.32062@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrei Vagin <avagin@virtuozzo.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, open list <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, crml <criu@openvz.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Thomas, Andrei, Eric,

On Tue, 2 Oct 2018 at 07:15, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Mon, 1 Oct 2018, Andrey Vagin wrote:
>
> > On Thu, Sep 27, 2018 at 11:41:49PM +0200, Thomas Gleixner wrote:
> > > On Thu, 27 Sep 2018, Thomas Gleixner wrote:
> > > > Add time skew via NTP/PTP into the picture and you might have to adjust
> > > > timers as well, because you need to guarantee that they are not expiring
> > > > early.
> > > >
> > > > I haven't looked through Dimitry's patches yet, but I don't see how this
> > > > can work at all without introducing subtle issues all over the place.
> > >
> > > And just a quick scan tells me that this is broken. Timers will expire
> > > early or late. The latter is acceptible to some extent, but larger delays
> > > might come with surprise. Expiring early is an absolute nono.
> >
> > Do you mean that we have to adjust all timers after changing offset for
> > CLOCK_MONOTONIC or CLOCK_BOOTTIME? Our idea is that offsets for
> > monotonic and boot times will be set immediately after creating a time
> > namespace before using any timers.
>
> I explained that in detail in this thread, but it's not about the initial
> setting of clock mono/boot before any timers have been armed.
>
> It's about setting the offset or clock realtime (via settimeofday) when
> timers are already armed. Also having a entirely different time domain,
> e.g. separate NTP adjustments, makes that necessary.

It looks like, there is a bit of misunderstanding each other:
Andrei was talking about the current RFC version, where we haven't
introduced offsets for clock realtime. While Thomas IIUC, is looking
how-to expand time namespace over realtime.

As CLOCK_REALTIME virtualization raises so many complex questions
like a different length of the second or list of realtime timers in ns we
haven't added any realization for it.

It seems like an initial introduction for timens can be expanded after to cover
realtime clocks too. While it may seem incomplete, it solves issues for
restoring/migration of real-world applications like nodejs, Oracle DB server
which fails after being restored if there is a leap in monotonic time.

While solving the mentioned issues, it doesn't bring overhead.
(well, Andy noted that cmp for zero-offsets on vdso can be optimized too,
which will be done in v1).

Thomas, thanks much for your input - now we know that we'll need to
introduce list for timers in namespace when we'll add realtime clocks.
Do you believe that CLOCK_MONOTONIC_SYNC would be an easier
concept than offsets per-namespace?

Thanks,
             Dmitry
