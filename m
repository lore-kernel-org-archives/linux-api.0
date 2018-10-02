From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Tue, 2 Oct 2018 08:15:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1810020811290.32062@nanos.tec.linutronix.de>
References: <20180919205037.9574-1-dima@arista.com> <874lej6nny.fsf@xmission.com> <20180924205119.GA14833@outlook.office365.com> <874leezh8n.fsf@xmission.com> <20180925014150.GA6302@outlook.office365.com> <87zhw4rwiq.fsf@xmission.com>
 <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de> <alpine.DEB.2.21.1809272335430.8118@nanos.tec.linutronix.de> <20181001232033.GA31324@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181001232033.GA31324@outlook.office365.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@virtuozzo.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey
List-Id: linux-api@vger.kernel.org

On Mon, 1 Oct 2018, Andrey Vagin wrote:

> On Thu, Sep 27, 2018 at 11:41:49PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 Sep 2018, Thomas Gleixner wrote:
> > > Add time skew via NTP/PTP into the picture and you might have to adjust
> > > timers as well, because you need to guarantee that they are not expiring
> > > early.
> > > 
> > > I haven't looked through Dimitry's patches yet, but I don't see how this
> > > can work at all without introducing subtle issues all over the place.
> > 
> > And just a quick scan tells me that this is broken. Timers will expire
> > early or late. The latter is acceptible to some extent, but larger delays
> > might come with surprise. Expiring early is an absolute nono.
> 
> Do you mean that we have to adjust all timers after changing offset for
> CLOCK_MONOTONIC or CLOCK_BOOTTIME? Our idea is that offsets for
> monotonic and boot times will be set immediately after creating a time
> namespace before using any timers.

I explained that in detail in this thread, but it's not about the initial
setting of clock mono/boot before any timers have been armed.

It's about setting the offset or clock realtime (via settimeofday) when
timers are already armed. Also having a entirely different time domain,
e.g. separate NTP adjustments, makes that necessary.

Thanks,

	tglx
