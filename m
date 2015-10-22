From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode configurable signal
Date: Thu, 22 Oct 2015 14:00:15 -0700
Message-ID: <CALCETrVQXwYwhEwbJsvN18w8qD-qVVCQAa8b9RcXD=RmXSqLiQ@mail.gmail.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-7-git-send-email-cmetcalf@ezchip.com> <20151020205610.51b3d742@grimm.local.home>
 <5626EABC.9060202@ezchip.com> <CALCETrXqDi24EPn79X9SXuz+5sYGZBF3yCRzb8PwdL=YbxVujw@mail.gmail.com>
 <AM2PR02MB041772AEFFA939F2F8619B36BD380@AM2PR02MB0417.eurprd02.prod.outlook.com>
 <CALCETrVuE_VCk-7_VMJ-orL8pg+0F5vq6qvt4SfgXzt_MRr-SQ@mail.gmail.com> <56294ACA.4000700@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <56294ACA.4000700@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 22, 2015 at 1:44 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> On 10/21/2015 02:53 PM, Andy Lutomirski wrote:
>>
>> On Tue, Oct 20, 2015 at 11:41 PM, Gilad Ben Yossef <giladb@ezchip.com>
>> wrote:
>>>
>>>
>>>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>>>> Sent: Wednesday, October 21, 2015 4:43 AM
>>>> To: Chris Metcalf
>>>> Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode
>>>> configurable signal
>>>>
>>>> On Tue, Oct 20, 2015 at 6:30 PM, Chris Metcalf <cmetcalf@ezchip.com>
>>>> wrote:
>>>>>
>>>>> On 10/20/2015 8:56 PM, Steven Rostedt wrote:
>>>>>>
>>>>>> On Tue, 20 Oct 2015 16:36:04 -0400
>>>>>> Chris Metcalf <cmetcalf@ezchip.com> wrote:
>>>>>>
>>>>>>> Allow userspace to override the default SIGKILL delivered
>>>>>>> when a task_isolation process in STRICT mode does a syscall
>>>>>>> or otherwise synchronously enters the kernel.
>>>>>>>
>>> <snip>
>>>>>
>>>>> It doesn't map SIGKILL to some other signal unconditionally.  It just
>>>>> allows
>>>>> the "hey, you broke the STRICT contract and entered the kernel" signal
>>>>> to be something besides the default SIGKILL.
>>>>>
>>> <snip>
>>>>
>>>> I still dislike this thing.  It seems like a debugging feature being
>>>> implemented using signals instead of existing APIs.  I *still* don't
>>>> see why perf can't be used to accomplish your goal.
>>>>
>>> It is not (just) a debugging feature. There are workloads were not
>>> performing an action is much preferred to being late.
>>>
>>> Consider the following artificial but representative scenario: a task
>>> running in strict isolation is controlling a radiotherapy alpha emitter.
>>> The code runs in a tight event loop, reading an MMIO register with
>>> location data, making some calculation and in response writing an
>>> MMIO register that triggers the alpha emitter. As a safety measure, each
>>> trigger is for a specific very short time frame - the alpha emitter
>>> auto stops.
>>>
>>> The code has a strict assumption that no more than X cycles pass between
>>> reading the value and the response and the system is built in
>>> such a way that as long as the code has mastery of the CPU the assumption
>>> holds true. If something breaks this assumption (unplanned
>>> context switch to kernel), what you want to do is just stop place
>>> rather than fire the alpha emitter X nanoseconds too late.
>>>
>>> This feature lets you say: if the "contract" of isolation is broken,
>>> notify/kill me at once.
>>
>> That's a fair point.  It's risky, though, for quite a few reasons.
>>
>> 1. If someone builds an alpha emitter like this, they did it wrong.
>> The kernel should write a trigger *and* a timestamp to the hardware
>> and the hardware should trigger at the specified time if the time is
>> in the future and throw an error if it's in the past.  If you need to
>> check that you made the deadline, check the actual desired condition
>> (did you meat the deadline?) not a proxy (did the signal fire?).
>
>
> Definitely a better hardware design, but as we all know, hardware
> designers too rarely consult the software people who have to
> right the actual code to properly drive the hardware :-)
>
> My canonical example is high-performance userspace network
> drivers, and though dropping is packet is less likely to kill a
> patient, it's still a pretty bad thing if you're trying to design
> a robust appliance.  In this case you really want to fix application
> bugs that cause the code to enter the kernel when you think
> you're in the internal loop running purely in userspace.  Things
> like unexpected page faults, and third-party code that almost
> never calls the kernel but in some dusty corner it occasionally
> does, can screw up your userspace code pretty badly, and
> mysteriously.  The "strict" mode support is not a hypothetical
> insurance policy but a reaction to lots of Tilera customer support
> over the years to folks failing to stay in userspace when they
> thought they were doing the right thing.

But this is *exactly* the case where perf or other out-of-band
debugging could be a much better solution.  Perf could notify a
non-isolated thread that an interrupt happened, you'd still drop a
packet or two, but you wouldn't also drop the next ten thousand
packets while handling the signal.

>
>> 2. This strict mode thing isn't exhaustive.  It's missing, at least,
>> coverage for NMI, MCE, and SMI.  Sure, you can think that you've
>> disabled all NMI sources, you can try to remember to set the
>> appropriate boot flag that panics on MCE (and hope that you don't get
>> screwed by broadcast MCE on Intel systems before it got fixed
>> (Skylake?  Is the fix even available in a released chip?), and, for
>> SMI, good luck...
>
>
> You are confusing this strict mode support with the debug
> support in patch 07/14.

Nope.  I'm confusing this strict mode with what Gilad described: using
strict mode to cause outright shutdown instead of failure to meet a
deadline.

(FWIW, you could also use an ordinary hardware watchdog timer to
promote your failure to meet a deadline to a shutdown.  No new kernel
support needed.)

>
> Strict mode is for synchronous application errors.  You might
> be right that there are cases that haven't been covered, but
> certainly most of them are covered on the three platforms that
> are supported in this initial series.  (You pointed me to one
> that I would have missed on x86, namely the bounds check
> exception from a bad bounds setup.)  I'm pretty confident I
> have all of them for tile, since I know that hardware best,
> and I think we're in good shape for arm64, though I'm still
> coming up to speed on that architecture.

Again, for this definition of strict mode, I still don't see why it's
the right design.  If you want to debug your application to detect
application errors, use a debugging interface.

>
> NMIs and machine checks are asynchronous interrupts that
> don't have to do with what the application is doing, more or less.
> Those should not be delivered to task-isolation cores at all,
> so we just generate console spew when you set the
> task_isolation_debug boot option.  I honestly don't know enough
> about system management interrupts to comment on that,
> though again, I would hope one can configure the system to
> just not deliver them to nohz_full cores, and I think it would
> be reasonable to generate some kernel spew if that happens.

Hah hah yeah right.  On most existing Intel CPUs, you *cannot*
configure machine checks to do anything other than broadcast to all
cores or cause immediate shutdown.  And getting any sort of reasonable
control over SMI more or less requires special firmware.

>
>> 3. You haven't dealt with IPIs.  The TLB flush code in particular
>> seems like it will break all your assumptions.
>
>
> Again, not a synchronous application error that we are trying
> to catch with this signalling mechanism.
>
> That said it could obviously be a more general application error
> (e.g. a process with threads on both nohz_full and housekeeping
> cores, where the housekeeping core unmaps some memory and
> thus requires a TLB flush IPI).  But this is covered by the
> task_isolation_debug patch for kernel/smp.c.
>
>> Maybe it would make sense to whack more of the moles before adding a
>> big assertion that there aren't any moles any more.
>
>
> Maybe, but I've whacked the ones I know how to whack.
> If there are ones I've missed I'm happy to add them in a
> subsequent version of this series, or in follow-on patches.
>

I agree that you can, in principle, catch all the synchronous
application errors using this mechanism.  I'm saying that catching
them seems quite useful, but catching them using a prctl that causes a
signal and explicitly does *not* solve the deadline enforcement
problem seems to have dubious value in the upstream kernel.

You can't catch the asynchronous application errors with this
mechanism (or at least your ability to catch them depends on which
patch version IIRC), which include calling anything like munmap or
membarrier in another thread.

--Andy
