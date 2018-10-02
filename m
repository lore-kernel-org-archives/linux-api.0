From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Setting monotonic time?
Date: Tue, 2 Oct 2018 22:06:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1810022205080.1435@nanos.tec.linutronix.de>
References: <20180919205037.9574-1-dima@arista.com> <874lej6nny.fsf@xmission.com> <20180924205119.GA14833@outlook.office365.com> <874leezh8n.fsf@xmission.com> <20180925014150.GA6302@outlook.office365.com> <87zhw4rwiq.fsf@xmission.com>
 <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de> <87mus1ftb9.fsf@xmission.com> <alpine.DEB.2.21.1809282023350.1432@nanos.tec.linutronix.de> <877ej2xc23.fsf_-_@xmission.com> <alpine.DEB.2.21.1810012047520.32062@nanos.tec.linutronix.de>
 <CAK8P3a2zTqrCGURE3XVpn3_w6C4R5O+cq8TdtbyKCMGyRk9_jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2zTqrCGURE3XVpn3_w6C4R5O+cq8TdtbyKCMGyRk9_jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>, avagin@virtuozzo.com, dima@arista.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 0x7f454c46@gmail.com, adrian@lisas.de, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, gorcunov@openvz.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, xemul@virtuozzo.com, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2 Oct 2018, Arnd Bergmann wrote:
> On Mon, Oct 1, 2018 at 8:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > On Mon, 1 Oct 2018, Eric W. Biederman wrote:
> > > In the context of process migration there is a simpler subproblem that I
> > > think it is worth exploring if we can do something about.
> > >
> > > For a cluster of machines all running with synchronized
> > > clocks. CLOCK_REALTIME matches. CLOCK_MONOTNIC does not match between
> > > machines.   Not having a matching CLOCK_MONOTONIC prevents successful
> > > process migration between nodes in that cluster.
> > >
> > > Would it be possible to allow setting CLOCK_MONOTONIC at the very
> > > beginning of time?  So that all of the nodes in a cluster can be in
> > > sync?
> > >
> > > No change in skew just in offset for CLOCK_MONOTONIC.
> > >
> > > There are also dragons involved in coordinating things so that
> > > CLOCK_MONOTONIC gets set before CLOCK_MONOTONIC gets used.  So I don't
> > > know if allowing CLOCK_MONOTONIC to be set would be practical but it
> > > seems work exploring all on it's own.
> >
> > It's used very early on in the kernel, so that would be a major surprise
> > for many things including user space which has expectations on clock
> > monotonic.
> >
> > It would be reasonably easy to add CLOCK_MONONOTIC_SYNC which can be set in
> > the way you described and then in name spaces make it possible to magically
> > map CLOCK_MONOTONIC to CLOCK_MONOTONIC_SYNC.
> >
> > It still wouldn't allow to have different NTP/PTP time domains, but might
> > be a good start to address the main migration headaches.
> 
> If we make CLOCK_MONOTONIC settable this way in a namespace,
> do you think that should include device drivers that report timestamps
> in CLOCK_MONOTONIC base, or only the timekeeping clock and timer
> interfaces?

Uurgh. That gets messy very fast.

> Examples for drivers that can report timestamps are input, sound, v4l,
> and drm. I think most of these can report stamps in either monotonic
> or realtime base, while socket timestamps notably are always in
> realtime.
> 
> We can probably get away with not setting the timebase for those
> device drivers as long as the checkpoint/restart and migration features
> are not expected to restore the state of an open character device
> in that way. I don't know if that is a reasonable assumption to make
> for the examples I listed.

No idea. I'm not a container migration wizard.

Thanks,

	tglx
