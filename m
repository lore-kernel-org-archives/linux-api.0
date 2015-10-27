From: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode configurable
 signal
Date: Tue, 27 Oct 2015 15:37:47 -0400
Message-ID: <562FD28B.8020806@ezchip.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-7-git-send-email-cmetcalf@ezchip.com>
 <20151020205610.51b3d742@grimm.local.home> <5626EABC.9060202@ezchip.com>
 <CALCETrXqDi24EPn79X9SXuz+5sYGZBF3yCRzb8PwdL=YbxVujw@mail.gmail.com>
 <AM2PR02MB041772AEFFA939F2F8619B36BD380@AM2PR02MB0417.eurprd02.prod.outlook.com>
 <CALCETrVuE_VCk-7_VMJ-orL8pg+0F5vq6qvt4SfgXzt_MRr-SQ@mail.gmail.com>
 <56294ACA.4000700@ezchip.com>
 <CALCETrVQXwYwhEwbJsvN18w8qD-qVVCQAa8b9RcXD=RmXSqLiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVQXwYwhEwbJsvN18w8qD-qVVCQAa8b9RcXD=RmXSqLiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/22/2015 05:00 PM, Andy Lutomirski wrote:
> On Thu, Oct 22, 2015 at 1:44 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
>> On 10/21/2015 02:53 PM, Andy Lutomirski wrote:
>>> On Tue, Oct 20, 2015 at 11:41 PM, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>>> wrote:
>>>>
>>>>> From: Andy Lutomirski [mailto:luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org]
>>>>> Sent: Wednesday, October 21, 2015 4:43 AM
>>>>> To: Chris Metcalf
>>>>> Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode
>>>>> configurable signal
>>>>>
>>>>> On Tue, Oct 20, 2015 at 6:30 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>>>>> wrote:
>>>>>> On 10/20/2015 8:56 PM, Steven Rostedt wrote:
>>>>>>> On Tue, 20 Oct 2015 16:36:04 -0400
>>>>>>> Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
>>>>>>>
>>>>>>>> Allow userspace to override the default SIGKILL delivered
>>>>>>>> when a task_isolation process in STRICT mode does a syscall
>>>>>>>> or otherwise synchronously enters the kernel.
>>>>>>>>
>>>> <snip>
>>>>>> It doesn't map SIGKILL to some other signal unconditionally.  It just
>>>>>> allows
>>>>>> the "hey, you broke the STRICT contract and entered the kernel" signal
>>>>>> to be something besides the default SIGKILL.
>>>>>>
>>>> <snip>
>>>>> I still dislike this thing.  It seems like a debugging feature being
>>>>> implemented using signals instead of existing APIs.  I *still* don't
>>>>> see why perf can't be used to accomplish your goal.
>>>>>
>>>> It is not (just) a debugging feature. There are workloads were not
>>>> performing an action is much preferred to being late.
>>>>
>>>> Consider the following artificial but representative scenario: a task
>>>> running in strict isolation is controlling a radiotherapy alpha emitter.
>>>> The code runs in a tight event loop, reading an MMIO register with
>>>> location data, making some calculation and in response writing an
>>>> MMIO register that triggers the alpha emitter. As a safety measure, each
>>>> trigger is for a specific very short time frame - the alpha emitter
>>>> auto stops.
>>>>
>>>> The code has a strict assumption that no more than X cycles pass between
>>>> reading the value and the response and the system is built in
>>>> such a way that as long as the code has mastery of the CPU the assumption
>>>> holds true. If something breaks this assumption (unplanned
>>>> context switch to kernel), what you want to do is just stop place
>>>> rather than fire the alpha emitter X nanoseconds too late.
>>>>
>>>> This feature lets you say: if the "contract" of isolation is broken,
>>>> notify/kill me at once.
>>> That's a fair point.  It's risky, though, for quite a few reasons.
>>>
>>> 1. If someone builds an alpha emitter like this, they did it wrong.
>>> The kernel should write a trigger *and* a timestamp to the hardware
>>> and the hardware should trigger at the specified time if the time is
>>> in the future and throw an error if it's in the past.  If you need to
>>> check that you made the deadline, check the actual desired condition
>>> (did you meat the deadline?) not a proxy (did the signal fire?).
>>
>> Definitely a better hardware design, but as we all know, hardware
>> designers too rarely consult the software people who have to
>> right the actual code to properly drive the hardware :-)
>>
>> My canonical example is high-performance userspace network
>> drivers, and though dropping is packet is less likely to kill a
>> patient, it's still a pretty bad thing if you're trying to design
>> a robust appliance.  In this case you really want to fix application
>> bugs that cause the code to enter the kernel when you think
>> you're in the internal loop running purely in userspace.  Things
>> like unexpected page faults, and third-party code that almost
>> never calls the kernel but in some dusty corner it occasionally
>> does, can screw up your userspace code pretty badly, and
>> mysteriously.  The "strict" mode support is not a hypothetical
>> insurance policy but a reaction to lots of Tilera customer support
>> over the years to folks failing to stay in userspace when they
>> thought they were doing the right thing.
> But this is *exactly* the case where perf or other out-of-band
> debugging could be a much better solution.  Perf could notify a
> non-isolated thread that an interrupt happened, you'd still drop a
> packet or two, but you wouldn't also drop the next ten thousand
> packets while handling the signal.

There's no reason the signal needs to be delivered to one of
the nohz_full cores.  If you're setting up to catch these signals
rather than have them just SIGKILL you, then you want to
run a separate thread on a housekeeping core that is doing
a sigwait() or equivalent.  I'm not sure why using perf to do
this is particularly better; I'm most interested in ensuring that
it is easy for applications to set this up if they want it, and
perf isn't always super-easy to use.

That said, maybe it's easier than I think to do that specific
thing, and worth considering doing it that way instead.  Is there
an easily-explained way to do what you suggest where perf
delivers a signal?  I assume you have in mind creating a
synthetic sampling perf event and using perf_event_open()
to get a file descriptor for it, and waiting with poll or SIGIO?
(Too bad perf_event_open isn't supported by glibc and we
have to use syscall() to even call it.)  Seems complex...

>>> 2. This strict mode thing isn't exhaustive.  It's missing, at least,
>>> coverage for NMI, MCE, and SMI.  Sure, you can think that you've
>>> disabled all NMI sources, you can try to remember to set the
>>> appropriate boot flag that panics on MCE (and hope that you don't get
>>> screwed by broadcast MCE on Intel systems before it got fixed
>>> (Skylake?  Is the fix even available in a released chip?), and, for
>>> SMI, good luck...
>>
>> You are confusing this strict mode support with the debug
>> support in patch 07/14.
> Nope.  I'm confusing this strict mode with what Gilad described: using
> strict mode to cause outright shutdown instead of failure to meet a
> deadline.

Yeah, fair point.  We certainly could wire up a mode to deliver
a signal or whatever for asynchronous interrupts (which I'm claiming
are primarily kernel bugs) instead of just synchronous interrupts
(which I'm claiming are application bugs).  That could be an
additional mode bit for prctl(), e.g. PR_TASK_ISOLATION_DEBUG
to align with the task_isolation_debug boot variable that enables
the kernel printk spew.

> (FWIW, you could also use an ordinary hardware watchdog timer to
> promote your failure to meet a deadline to a shutdown.  No new kernel
> support needed.)

But more hardware support is needed; there may not be a handy
hardware watchdog timer to use out of the box, and you don't
want to require the customer to buy new hardware to support
a feature like this if you don't have to.

>> Strict mode is for synchronous application errors.  You might
>> be right that there are cases that haven't been covered, but
>> certainly most of them are covered on the three platforms that
>> are supported in this initial series.  (You pointed me to one
>> that I would have missed on x86, namely the bounds check
>> exception from a bad bounds setup.)  I'm pretty confident I
>> have all of them for tile, since I know that hardware best,
>> and I think we're in good shape for arm64, though I'm still
>> coming up to speed on that architecture.
> Again, for this definition of strict mode, I still don't see why it's
> the right design.  If you want to debug your application to detect
> application errors, use a debugging interface.

Maybe.  But we basically want a single notification that the
app (and/or maybe kernel) screwed up.  Invoking all of perf
for that seems like overkill and a signal seems totally adequate,
whether for development fixing bugs, or production catching
bad things.  There are a reasonable number of precedents for
doing things this way: SIGPIPE and SIGFPE, to name two.


>> NMIs and machine checks are asynchronous interrupts that
>> don't have to do with what the application is doing, more or less.
>> Those should not be delivered to task-isolation cores at all,
>> so we just generate console spew when you set the
>> task_isolation_debug boot option.  I honestly don't know enough
>> about system management interrupts to comment on that,
>> though again, I would hope one can configure the system to
>> just not deliver them to nohz_full cores, and I think it would
>> be reasonable to generate some kernel spew if that happens.
> Hah hah yeah right.  On most existing Intel CPUs, you *cannot*
> configure machine checks to do anything other than broadcast to all
> cores or cause immediate shutdown.  And getting any sort of reasonable
> control over SMI more or less requires special firmware.

Yeah, as Gilad said, x86 may not be the best choice to run
a task-isolated application unless you can really set up those
kinds of things to stay off your core.

>>> 3. You haven't dealt with IPIs.  The TLB flush code in particular
>>> seems like it will break all your assumptions.
>>
>> Again, not a synchronous application error that we are trying
>> to catch with this signalling mechanism.
>>
>> That said it could obviously be a more general application error
>> (e.g. a process with threads on both nohz_full and housekeeping
>> cores, where the housekeeping core unmaps some memory and
>> thus requires a TLB flush IPI).  But this is covered by the
>> task_isolation_debug patch for kernel/smp.c.
>>
>>> Maybe it would make sense to whack more of the moles before adding a
>>> big assertion that there aren't any moles any more.
>>
>> Maybe, but I've whacked the ones I know how to whack.
>> If there are ones I've missed I'm happy to add them in a
>> subsequent version of this series, or in follow-on patches.
>>
> I agree that you can, in principle, catch all the synchronous
> application errors using this mechanism.  I'm saying that catching
> them seems quite useful, but catching them using a prctl that causes a
> signal and explicitly does *not* solve the deadline enforcement
> problem seems to have dubious value in the upstream kernel.

When you say "does not solve the deadline enforcement problem",
I'm not sure what point you're making.  The application presumably
can meet its own deadlines when it's not interrupted; the intent
here is to notice when the kernel gets in its way and notify it.

Granted you could add separate mechanisms to create deadlines
within the application, but that feels like a separate layer that
may or may not be desired for any given application.

> You can't catch the asynchronous application errors with this
> mechanism (or at least your ability to catch them depends on which
> patch version IIRC), which include calling anything like munmap or
> membarrier in another thread.

Yes, and munmap in another thread is certainly an application bug
at some level, so that's another reason to allow using the same
mechanism to notify the application of an asynchronous interrupt.
I'll add that for the next version of the patch series.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
