From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Fri, 28 Sep 2018 19:03:22 +0200
Message-ID: <87mus1ftb9.fsf@xmission.com>
References: <20180919205037.9574-1-dima@arista.com>
        <874lej6nny.fsf@xmission.com>
        <20180924205119.GA14833@outlook.office365.com>
        <874leezh8n.fsf@xmission.com>
        <20180925014150.GA6302@outlook.office365.com>
        <87zhw4rwiq.fsf@xmission.com>
        <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809272247270.8118@nanos.tec.linutronix.de>
        (Thomas Gleixner's message of "Thu, 27 Sep 2018 23:30:09 +0200
        (CEST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrey Vagin <avagin@virtuozzo.com>, Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey
List-Id: linux-api@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Wed, 26 Sep 2018, Eric W. Biederman wrote:
>> Reading the code the calling sequence there is:
>> tick_sched_do_timer
>>    tick_do_update_jiffies64
>>       update_wall_time
>>           timekeeping_advance
>>              timekeepging_update
>> 
>> If I read that properly under the right nohz circumstances that update
>> can be delayed indefinitely.
>> 
>> So I think we could prototype a time namespace that was per
>> timekeeping_update and just had update_wall_time iterate through
>> all of the time namespaces.
>
> Please don't go there. timekeeping_update() is already heavy and walking
> through a gazillion of namespaces will just make it horrible,
>
>> I don't think the naive version would scale to very many time
>> namespaces.
>
> :)
>
>> At the same time using the techniques from the nohz work and a little
>> smarts I expect we could get the code to scale.
>
> You'd need to invoke the update when the namespace is switched in and
> hasn't been updated since the last tick happened. That might be doable, but
> you also need to take the wraparound constraints of the underlying
> clocksources into account, which again can cause walking all name spaces
> when they are all idle long enough.

The wrap around constraints being how long before the time sources wrap
around so you have to read them once per wrap around?  I have not dug
deeply enough into the code to see that yet.

> From there it becomes hairy, because it's not only timekeeping,
> i.e. reading time, this is also affecting all timers which are armed from a
> namespace.
>
> That gets really ugly because when you do settimeofday() or adjtimex() for
> a particular namespace, then you have to search for all armed timers of
> that namespace and adjust them.
>
> The original posix timer code had the same issue because it mapped the
> clock realtime timers to the timer wheel so any setting of the clock caused
> a full walk of all armed timers, disarming, adjusting and requeing
> them. That's horrible not only performance wise, it's also a locking
> nightmare of all sorts.
>
> Add time skew via NTP/PTP into the picture and you might have to adjust
> timers as well, because you need to guarantee that they are not expiring
> early.
>
> I haven't looked through Dimitry's patches yet, but I don't see how this
> can work at all without introducing subtle issues all over the place.

Then it sounds like this will take some more digging.

Please pardon me for thinking out load.

There are one or more time sources that we use to compute the time
and for each time source we have a conversion from ticks of the
time source to nanoseconds.

Each time source needs to be sampled at least once per wrap-around
and something incremented so that we don't loose time when looking
at that time source.

There are several clocks presented to userspace and they all share the
same length of second and are all fundamentally offsets from
CLOCK_MONOTONIC.

I see two fundamental driving cases for a time namespace.
1) Migration from one node to another node in a cluster in almost
   real time.

   The problem is that CLOCK_MONOTONIC between nodes in the cluster
   has not relation ship to each other (except a synchronized length of
   the second).  So applications that migrate can see CLOCK_MONOTONIC
   and CLOCK_BOOTTIME go backwards.

   This is the truly pressing problem and adding some kind of offset
   sounds like it would be the solution.  Possibly by allowing a boot
   time synchronization of CLOCK_BOOTTIME and CLOCK_MONOTONIC.

2) Dealing with two separate time management domains.  Say a machine
   that needes to deal with both something inside of google where they
   slew time to avoid leap time seconds and something in the outside
   world proper UTC time is kept as an offset from TAI with the
   occasional leap seconds.

   In the later case it would fundamentally require having seconds of
   different length.


A pure 64bit nanoseond counter is good for 500 years.  So 64bit
variables can be used to hold time, and everything can be converted from
there.

This suggests we can for ticks have two values.
- The number of ticks from the time source.
- The number of times the ticks would have rolled over.

That sounds like it may be a little simplistic as it would require being
very diligent about firing a timer exactly at rollover and not losing
that, but for a handwaving argument is probably enough to generate
a 64bit tick counter.

If the focus is on a 64bit tick counter then what update_wall_time
has to do is very limited.  Just deal the accounting needed to cope with
tick rollover.

Getting the actual time looks like it would be as simple as now, with
perhaps an extra addition to account for the number of times the tick
counter has rolled over.  With limited precision arithmetic and various
optimizations I don't think it is that simple to implement but it feels
like it should be very little extra work.

For timers my inclination would be to assume no adjustments to the
current time parameters and set the timer to go off then.   If the time
on the appropriate clock has been changed since the timer was set and
the timer is going off early reschedule so the timer fires at the
appropriate time.

With the above I think it is theoretically possible to build a time
namespace that supports multiple lengths of second, and does not have
much overhead.

Not that I think a final implementation would necessary look like what I
have described. I just think it is possible with extreme care to evolve
the current code base into something that can efficiently handle
multiple time domains with slightly different lenghts of second.

Thomas does it sound like I am completely out of touch with reality?

It does though sound like it is going to take some serious digging
through the code to understand how what everything does and how and why
everthing works the way it does.  Not something grafted on top with just
a cursory understanding of how the code works.

Eric
