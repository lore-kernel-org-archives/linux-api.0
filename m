From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC 00/20] ns: Introduce Time Namespace
Date: Tue, 25 Sep 2018 00:02:32 +0200
Message-ID: <874leezh8n.fsf@xmission.com>
References: <20180919205037.9574-1-dima@arista.com>
        <874lej6nny.fsf@xmission.com>
        <20180924205119.GA14833@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180924205119.GA14833@outlook.office365.com> (Andrey Vagin's
        message of "Mon, 24 Sep 2018 20:51:33 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Vagin <avagin@virtuozzo.com>
Cc: Dmitry Safonov <dima@arista.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelianov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "criu@openvz.org" <criu@openvz.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Alexey
List-Id: linux-api@vger.kernel.org

Andrey Vagin <avagin@virtuozzo.com> writes:

> On Fri, Sep 21, 2018 at 02:27:29PM +0200, Eric W. Biederman wrote:
>> Dmitry Safonov <dima@arista.com> writes:
>> 
>> > Discussions around time virtualization are there for a long time.
>> > The first attempt to implement time namespace was in 2006 by Jeff Dike.
>> > From that time, the topic appears on and off in various discussions.
>> >
>> > There are two main use cases for time namespaces:
>> > 1. change date and time inside a container;
>> > 2. adjust clocks for a container restored from a checkpoint.
>> >
>> > “It seems like this might be one of the last major obstacles keeping
>> > migration from being used in production systems, given that not all
>> > containers and connections can be migrated as long as a time dependency
>> > is capable of messing it up.” (by github.com/dav-ell)
>> >
>> > The kernel provides access to several clocks: CLOCK_REALTIME,
>> > CLOCK_MONOTONIC, CLOCK_BOOTTIME. Last two clocks are monotonous, but the
>> > start points for them are not defined and are different for each running
>> > system. When a container is migrated from one node to another, all
>> > clocks have to be restored into consistent states; in other words, they
>> > have to continue running from the same points where they have been
>> > dumped.
>> >
>> > The main idea behind this patch set is adding per-namespace offsets for
>> > system clocks. When a process in a non-root time namespace requests
>> > time of a clock, a namespace offset is added to the current value of
>> > this clock on a host and the sum is returned.
>> >
>> > All offsets are placed on a separate page, this allows up to map it as 
>> > part of vvar into user processes and use offsets from vdso calls.
>> >
>> > Now offsets are implemented for CLOCK_MONOTONIC and CLOCK_BOOTTIME
>> > clocks.
>> >
>> > Questions to discuss:
>> >
>> > * Clone flags exhaustion. Currently there is only one unused clone flag
>> > bit left, and it may be worth to use it to extend arguments of the clone
>> > system call.
>> >
>> > * Realtime clock implementation details:
>> >   Is having a simple offset enough?
>> >   What to do when date and time is changed on the host?
>> >   Is there a need to adjust vfs modification and creation times? 
>> >   Implementation for adjtime() syscall.
>> 
>> Overall I support this effort.  In my quick skim this code looked good.
>
> Hi Eric,
>
> Thank you for the feedback.
>
>> 
>> My feeling is that we need to be able to support running ntpd and
>> support one namespace doing googles smoothing of leap seconds while
>> another namespace takes the leap second.
>> 
>> What I was imagining when I was last thinking about this was one
>> instance of struct timekeeper aka tk_core per time namespace.  That
>> structure already keeps offsets for all of the various clocks from
>> the kerne internal time sources.  What would be needed would be to
>> pass in an appropriate time namespace pointer.
>> 
>> I could be completely wrong as I have not take the time to completely
>> trace through the code.  Have you looked at pushing the time namespace
>> down as far as tk_core?
>> 
>> What I think would be the big advantage (besides ntp working) is that
>> the bulk of the code could be reused.  Allowing testing of the kernel's
>> time code by setting up a new time namespace.  So a person in production
>> could setup a time namespace with the time set ahead a little  bit and
>> be able to verify that the kernel handles the upcoming leap second
>> properly.
>>
>
> It is an interesting idea, but I have a few questions:
>
> 1. Does it mean that timekeeping_update() will be called for each
> namespace? This functions is called periodically, it updates times on the
> timekeeper structure, updates vsyscall_gtod_data, etc. What will be an
> overhead of this?

I don't know if periodically is a proper characterization.  There may be
a code path that does that.  But from what I can see timekeeping_update
is the guts of settimeofday (and a few related functions).

So it appears to make sense for timekeeping_update to be per namespace.

Hmm.  Looking at what is updated in the vsyscall_gtod_data it does
look like you would have to periodically update things, but I don't know
big that period would be.  As long as the period is reasonably large,
or the time namespaces were sufficiently deschronized it should not
be a problem.  But that is the class of problem that could make
my ideal impractical if there is measuarable overhead.

Where were you seeing timekeeping_update being called periodically?

> 2. What will we do with vdso? It looks like we will have to have a
> separate vsyscall_gtod_data for each ns and update each of them
> separately.

Yes.  But you don't have to have introduce another variable just make
certain vsyscall_gtod_data is a page aligned thing per time namespace.

If I read the summary of the existing patchset something very similiar
is already going on.

Each process would only map one.  And unshare of the time namespace
would need to act like the pid namespace or be limited to only being
allowed when there is only a single task using the mm.

Eric
