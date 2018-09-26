From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Wed, 26 Sep 2018 19:36:29 +0200
Message-ID: <87zhw4rwiq.fsf@xmission.com>
References: <20180919205037.9574-1-dima@arista.com>
        <874lej6nny.fsf@xmission.com>
        <20180924205119.GA14833@outlook.office365.com>
        <874leezh8n.fsf@xmission.com>
        <20180925014150.GA6302@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925014150.GA6302@outlook.office365.com> (Andrey Vagin's
        message of "Tue, 25 Sep 2018 01:42:02 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@virtuozzo.com>
Cc: Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey
List-Id: linux-api@vger.kernel.org

Andrey Vagin <avagin@virtuozzo.com> writes:

> On Tue, Sep 25, 2018 at 12:02:32AM +0200, Eric W. Biederman wrote:
>> Andrey Vagin <avagin@virtuozzo.com> writes:
>> 
>> > On Fri, Sep 21, 2018 at 02:27:29PM +0200, Eric W. Biederman wrote:
>> >> Dmitry Safonov <dima@arista.com> writes:
>> >> 
>> >> > Discussions around time virtualization are there for a long time.
>> >> > The first attempt to implement time namespace was in 2006 by Jeff Dike.
>> >> > From that time, the topic appears on and off in various discussions.
>> >> >
>> >> > There are two main use cases for time namespaces:
>> >> > 1. change date and time inside a container;
>> >> > 2. adjust clocks for a container restored from a checkpoint.
>> >> >
>> >> > “It seems like this might be one of the last major obstacles keeping
>> >> > migration from being used in production systems, given that not all
>> >> > containers and connections can be migrated as long as a time dependency
>> >> > is capable of messing it up.” (by github.com/dav-ell)
>> >> >
>> >> > The kernel provides access to several clocks: CLOCK_REALTIME,
>> >> > CLOCK_MONOTONIC, CLOCK_BOOTTIME. Last two clocks are monotonous, but the
>> >> > start points for them are not defined and are different for each running
>> >> > system. When a container is migrated from one node to another, all
>> >> > clocks have to be restored into consistent states; in other words, they
>> >> > have to continue running from the same points where they have been
>> >> > dumped.
>> >> >
>> >> > The main idea behind this patch set is adding per-namespace offsets for
>> >> > system clocks. When a process in a non-root time namespace requests
>> >> > time of a clock, a namespace offset is added to the current value of
>> >> > this clock on a host and the sum is returned.
>> >> >
>> >> > All offsets are placed on a separate page, this allows up to map it as 
>> >> > part of vvar into user processes and use offsets from vdso calls.
>> >> >
>> >> > Now offsets are implemented for CLOCK_MONOTONIC and CLOCK_BOOTTIME
>> >> > clocks.
>> >> >
>> >> > Questions to discuss:
>> >> >
>> >> > * Clone flags exhaustion. Currently there is only one unused clone flag
>> >> > bit left, and it may be worth to use it to extend arguments of the clone
>> >> > system call.
>> >> >
>> >> > * Realtime clock implementation details:
>> >> >   Is having a simple offset enough?
>> >> >   What to do when date and time is changed on the host?
>> >> >   Is there a need to adjust vfs modification and creation times? 
>> >> >   Implementation for adjtime() syscall.
>> >> 
>> >> Overall I support this effort.  In my quick skim this code looked good.
>> >
>> > Hi Eric,
>> >
>> > Thank you for the feedback.
>> >
>> >> 
>> >> My feeling is that we need to be able to support running ntpd and
>> >> support one namespace doing googles smoothing of leap seconds while
>> >> another namespace takes the leap second.
>> >> 
>> >> What I was imagining when I was last thinking about this was one
>> >> instance of struct timekeeper aka tk_core per time namespace.  That
>> >> structure already keeps offsets for all of the various clocks from
>> >> the kerne internal time sources.  What would be needed would be to
>> >> pass in an appropriate time namespace pointer.
>> >> 
>> >> I could be completely wrong as I have not take the time to completely
>> >> trace through the code.  Have you looked at pushing the time namespace
>> >> down as far as tk_core?
>> >> 
>> >> What I think would be the big advantage (besides ntp working) is that
>> >> the bulk of the code could be reused.  Allowing testing of the kernel's
>> >> time code by setting up a new time namespace.  So a person in production
>> >> could setup a time namespace with the time set ahead a little  bit and
>> >> be able to verify that the kernel handles the upcoming leap second
>> >> properly.
>> >>
>> >
>> > It is an interesting idea, but I have a few questions:
>> >
>> > 1. Does it mean that timekeeping_update() will be called for each
>> > namespace? This functions is called periodically, it updates times on the
>> > timekeeper structure, updates vsyscall_gtod_data, etc. What will be an
>> > overhead of this?
>> 
>> I don't know if periodically is a proper characterization.  There may be
>> a code path that does that.  But from what I can see timekeeping_update
>> is the guts of settimeofday (and a few related functions).
>> 
>> So it appears to make sense for timekeeping_update to be per namespace.
>> 
>> Hmm.  Looking at what is updated in the vsyscall_gtod_data it does
>> look like you would have to periodically update things, but I don't know
>> big that period would be.  As long as the period is reasonably large,
>> or the time namespaces were sufficiently deschronized it should not
>> be a problem.  But that is the class of problem that could make
>> my ideal impractical if there is measuarable overhead.
>> 
>> Where were you seeing timekeeping_update being called periodically?
>
> timekeeping_update() is called HZ times per-second:
>
> [   67.912858]  timekeeping_update.cold.26+0x5/0xa
> [   67.913332]  timekeeping_advance+0x361/0x5c0
> [   67.913857]  ? tick_sched_do_timer+0x55/0x70
> [   67.914409]  ? tick_sched_do_timer+0x70/0x70
> [   67.914947]  tick_sched_do_timer+0x55/0x70
> [   67.915505]  tick_sched_timer+0x27/0x70
> [   67.916042]  __hrtimer_run_queues+0x10f/0x440
> [   67.916639]  hrtimer_interrupt+0x100/0x220
> [   67.917305]  smp_apic_timer_interrupt+0x79/0x220
> [   67.918030]  apic_timer_interrupt+0xf/0x20

Interesting.

Reading the code the calling sequence there is:
tick_sched_do_timer
   tick_do_update_jiffies64
      update_wall_time
          timekeeping_advance
             timekeepging_update

If I read that properly under the right nohz circumstances that update
can be delayed indefinitely.

So I think we could prototype a time namespace that was per
timekeeping_update and just had update_wall_time iterate through
all of the time namespaces.

I don't think the naive version would scale to very many time
namespaces.

At the same time using the techniques from the nohz work and a little
smarts I expect we could get the code to scale.

I think this direction is definitely worth exploring.  My experience
with namespaces is that if we don't get the advanced features working
there is little to no interest from the core developers of the code,
and the namespaces don't solve additional problems.  Which makes the
namespace a hard sell.  Especially when it does not solve problems the
developers of the subsystem have.

The advantage of timekeeping_update per time namespace is that it allows
different lengths of seconds per time namespace.  Which allows testing
ntp and the kernel in interesting ways while still having a working
production configuration on the same system.

Eric
