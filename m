From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Setting monotonic time?
Date: Wed, 3 Oct 2018 09:02:00 +0200
Message-ID: <CAK8P3a2cM4AWKQ9VsZFzUu0qJ-fYiLK5fMXRoTsVcgmFwoeJxg@mail.gmail.com>
References: <20180919205037.9574-1-dima@arista.com> <874lej6nny.fsf@xmission.com>
 <20180924205119.GA14833@outlook.office365.com> <874leezh8n.fsf@xmission.com>
 <20180925014150.GA6302@outlook.office365.com> <87zhw4rwiq.fsf@xmission.com>
 <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
 <87mus1ftb9.fsf@xmission.com> <alpine.DEB.2.21.1809282023350.1432@nanos.tec.linutronix.de>
 <877ej2xc23.fsf_-_@xmission.com> <alpine.DEB.2.21.1810012047520.32062@nanos.tec.linutronix.de>
 <CAK8P3a2zTqrCGURE3XVpn3_w6C4R5O+cq8TdtbyKCMGyRk9_jw@mail.gmail.com>
 <alpine.DEB.2.21.1810022205080.1435@nanos.tec.linutronix.de>
 <87in2jskew.fsf@xmission.com> <alpine.DEB.2.21.1810030711520.1435@nanos.tec.linutronix.de>
 <87in2jo8u6.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87in2jo8u6.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, avagin@virtuozzo.com, dima@arista.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 0x7f454c46@gmail.com, adrian@lisas.de, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, gorcunov@openvz.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, xemul@virtuozzo.com, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 3, 2018 at 8:14 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Thomas Gleixner <tglx@linutronix.de> writes:
>
> > On Wed, 3 Oct 2018, Eric W. Biederman wrote:
> >> Direct access to hardware/drivers and not through an abstraction like
> >> the vfs (an abstraction over block devices) can legitimately be handled
> >> by hotplug events.  I unplug one keyboard I plug in another.
> >>
> >> I don't know if the input layer is more of a general abstraction
> >> or more of a hardware device.  I have not dug into it but my guess
> >> is abstraction from what I have heard.
> >>
> >> The scary difficulty here is if after restart input is reporting times
> >> in CLOCK_MONOTONIC and the applications in the namespace are talking
> >> about times in CLOCK_MONOTONIC_SYNC.  Then there is an issue.  As even
> >> with a fixed offset the times don't match up.
> >>
> >> So a time namespace absolutely needs to do is figure out how to deal
> >> with all of the kernel interfaces reporting times and figure out how to
> >> report them in the current time namespace.
> >
> > So you want to talk to Arnd who is leading the y2038 effort. He knowns how
> > many and which interfaces are involved aside of the obvious core timer
> > ones. It's quite an amount and the problem is that you really need to do
> > that at the interface level, because many of those time stamps are taken in
> > contexts which are completely oblivious of name spaces. Ditto for timeouts
> > and similar things which are handed in through these interfaces.
>
> Yep.  That sounds right.

Let's stay with the input event example for the moment: Here, we have a
character device, and a user calls read() to retrieve one or more records
of type 'struct input_event' using the evdev_read() function. The original
timestamp gets put there using this logic:

        ktime_t time;
        struct timespec64 ts;
        time = client->clk_type == EV_CLK_REAL ?
                        ktime_get_real() :
                        client->clk_type == EV_CLK_MONO ?
                                ktime_get() :
                                ktime_get_boottime();
        ts = ktime_to_timespec64(time);
        ev.input_event_sec = ts.tv_sec;
        ev.input_event_usec = ts.tv_nsec / NSEC_PER_USEC;

clk_type can get set using an ioctl() to real, monotonic or
boottime. We have to stop using EV_CLK_REAL in the
future because that breaks in y2038, but I guess EV_CLK_MONO
and EV_CLK_BOOK should stay.

If we want this to work correctly in a namespace that has a
user defined CLOCK_MONOTONIC timebase, one way to
do it might be to always call ktime_get() when we record
the timestamp in the kernel-internal CLOCK_MONOTONIC
base, but then convert it to the correct base when copying to
user space.

Note that AFAIU practically all users of evdev do /not/ actually
care about the time base, they only care about the elapsed
time between intervals, e.g. to track how fast a pointer should
move based on input from a trackpad. I don't see any reason
why one would compare this timestamp to a clock_gettime()
value, but of course at the moment this has well-defined
behavior that would break if we change clock_gettime(), and
we have a process in the namespace that opens
/dev/input/eventX and relies on meaningful timestamps
relative to a particular base.

       Arnd
