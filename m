From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode configurable signal
Date: Wed, 21 Oct 2015 11:53:09 -0700
Message-ID: <CALCETrVuE_VCk-7_VMJ-orL8pg+0F5vq6qvt4SfgXzt_MRr-SQ@mail.gmail.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-7-git-send-email-cmetcalf@ezchip.com> <20151020205610.51b3d742@grimm.local.home>
 <5626EABC.9060202@ezchip.com> <CALCETrXqDi24EPn79X9SXuz+5sYGZBF3yCRzb8PwdL=YbxVujw@mail.gmail.com>
 <AM2PR02MB041772AEFFA939F2F8619B36BD380@AM2PR02MB0417.eurprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AM2PR02MB041772AEFFA939F2F8619B36BD380@AM2PR02MB0417.eurprd02.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@ezchip.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 11:41 PM, Gilad Ben Yossef <giladb@ezchip.com> wrote:
>
>
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Wednesday, October 21, 2015 4:43 AM
>> To: Chris Metcalf
>> Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode
>> configurable signal
>>
>> On Tue, Oct 20, 2015 at 6:30 PM, Chris Metcalf <cmetcalf@ezchip.com>
>> wrote:
>> > On 10/20/2015 8:56 PM, Steven Rostedt wrote:
>> >>
>> >> On Tue, 20 Oct 2015 16:36:04 -0400
>> >> Chris Metcalf <cmetcalf@ezchip.com> wrote:
>> >>
>> >>> Allow userspace to override the default SIGKILL delivered
>> >>> when a task_isolation process in STRICT mode does a syscall
>> >>> or otherwise synchronously enters the kernel.
>> >>>
> <snip>
>> >
>> > It doesn't map SIGKILL to some other signal unconditionally.  It just allows
>> > the "hey, you broke the STRICT contract and entered the kernel" signal
>> > to be something besides the default SIGKILL.
>> >
>>
>
> <snip>
>>
>> I still dislike this thing.  It seems like a debugging feature being
>> implemented using signals instead of existing APIs.  I *still* don't
>> see why perf can't be used to accomplish your goal.
>>
>
> It is not (just) a debugging feature. There are workloads were not performing an action is much preferred to being late.
>
> Consider the following artificial but representative scenario: a task running in strict isolation is controlling a radiotherapy alpha emitter.
> The code runs in a tight event loop, reading an MMIO register with location data, making some calculation and in response writing an
> MMIO register that triggers the alpha emitter. As a safety measure, each trigger is for a specific very short time frame - the alpha emitter
> auto stops.
>
> The code has a strict assumption that no more than X cycles pass between reading the value and the response and the system is built in
> such a way that as long as the code has mastery of the CPU the assumption holds true. If something breaks this assumption (unplanned
> context switch to kernel), what you want to do is just stop place
> rather than fire the alpha emitter X nanoseconds too late.
>
> This feature lets you say: if the "contract" of isolation is broken, notify/kill me at once.

That's a fair point.  It's risky, though, for quite a few reasons.

1. If someone builds an alpha emitter like this, they did it wrong.
The kernel should write a trigger *and* a timestamp to the hardware
and the hardware should trigger at the specified time if the time is
in the future and throw an error if it's in the past.  If you need to
check that you made the deadline, check the actual desired condition
(did you meat the deadline?) not a proxy (did the signal fire?).

2. This strict mode thing isn't exhaustive.  It's missing, at least,
coverage for NMI, MCE, and SMI.  Sure, you can think that you've
disabled all NMI sources, you can try to remember to set the
appropriate boot flag that panics on MCE (and hope that you don't get
screwed by broadcast MCE on Intel systems before it got fixed
(Skylake?  Is the fix even available in a released chip?), and, for
SMI, good luck...

3. You haven't dealt with IPIs.  The TLB flush code in particular
seems like it will break all your assumptions.

Maybe it would make sense to whack more of the moles before adding a
big assertion that there aren't any moles any more.

--Andy
