From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Setting monotonic time?
Date: Wed, 3 Oct 2018 08:14:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1810030812550.1435@nanos.tec.linutronix.de>
References: <20180919205037.9574-1-dima@arista.com> <874lej6nny.fsf@xmission.com> <20180924205119.GA14833@outlook.office365.com> <874leezh8n.fsf@xmission.com> <20180925014150.GA6302@outlook.office365.com> <87zhw4rwiq.fsf@xmission.com>
 <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de> <87mus1ftb9.fsf@xmission.com> <alpine.DEB.2.21.1809282023350.1432@nanos.tec.linutronix.de> <877ej2xc23.fsf_-_@xmission.com> <alpine.DEB.2.21.1810012047520.32062@nanos.tec.linutronix.de>
 <CAK8P3a2zTqrCGURE3XVpn3_w6C4R5O+cq8TdtbyKCMGyRk9_jw@mail.gmail.com> <alpine.DEB.2.21.1810022205080.1435@nanos.tec.linutronix.de> <87in2jskew.fsf@xmission.com> <alpine.DEB.2.21.1810030711520.1435@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1810030711520.1435@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arnd Bergmann <arnd@arndb.de>, avagin@virtuozzo.com, dima@arista.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 0x7f454c46@gmail.com, adrian@lisas.de, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, gorcunov@openvz.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, xemul@virtuozzo.com, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 3 Oct 2018, Thomas Gleixner wrote:
> On Wed, 3 Oct 2018, Eric W. Biederman wrote:
> > Direct access to hardware/drivers and not through an abstraction like
> > the vfs (an abstraction over block devices) can legitimately be handled
> > by hotplug events.  I unplug one keyboard I plug in another.
> > 
> > I don't know if the input layer is more of a general abstraction
> > or more of a hardware device.  I have not dug into it but my guess
> > is abstraction from what I have heard.
> > 
> > The scary difficulty here is if after restart input is reporting times
> > in CLOCK_MONOTONIC and the applications in the namespace are talking
> > about times in CLOCK_MONOTONIC_SYNC.  Then there is an issue.  As even
> > with a fixed offset the times don't match up.
> > 
> > So a time namespace absolutely needs to do is figure out how to deal
> > with all of the kernel interfaces reporting times and figure out how to
> > report them in the current time namespace.
> 
> So you want to talk to Arnd who is leading the y2038 effort. He knowns how
> many and which interfaces are involved aside of the obvious core timer
> ones. It's quite an amount and the problem is that you really need to do
> that at the interface level, because many of those time stamps are taken in
> contexts which are completely oblivious of name spaces. Ditto for timeouts
> and similar things which are handed in through these interfaces.

Plus you have to make sure, that any new interface will have that
treatment. For y2038 that's easy as we just require to use timespec64 for
new ones. For your problem that's not so trivial.

Thanks,

	tglx
