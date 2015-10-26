From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Mon, 26 Oct 2015 16:32:19 -0400
Message-ID: <562E8DD3.5070909@ezchip.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWzhrYreizoKG0w6Jtz3RLFjNx9Qk_JLykcLLUQcCXBEA@mail.gmail.com>
 <5626B00E.3010309@ezchip.com>
 <CALCETrX6e+mqfy-rNV3sA8xGVDNHviQ9vHBBhAPULeLecno7XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALCETrX6e+mqfy-rNV3sA8xGVDNHviQ9vHBBhAPULeLecno7XQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/20/2015 05:26 PM, Andy Lutomirski wrote:
>>   Even more importantly, we rely on
>> rescheduling to take care of the fact that the scheduler tick may still
>> be running, and therefore loop back to the schedule() call that's run
>> when TIF_NEED_RESCHED gets set.
> This just seems like a mis-design.  We don't know why the scheduler
> tick is on, so we're just going to reschedule until the problem goes
> away?

See my previous email about polite vs aggressive design for more
thoughts on this, but, yes.  I'm not sure there's a way to do anything
else, other than my proposal there to dig deep into the scheduler
and allow it to switch to idle for a few tasks - but again, I'm just
not sure the complexity is worth the runtime power savings.

>>> BTW, should isolation just be a scheduler class (SCHED_ISOLATED)?
>>
>> So a scheduler class is an interesting idea certainly, although not
>> one I know immediately how to implement.  I'm not sure whether
>> it makes sense to require a user be root or have a suitable rtprio
>> rlimit, but perhaps so.  The nice thing about the current patch
>> series is that you can affinitize yourself to a nohz_full core and
>> declare that you want to run task-isolated, and none of that
>> requires root nor really is there a reason it should.
> Your patches more or less implement "don't run me unless I'm
> isolated".  A scheduler class would be more like "isolate me (and
> maybe make me super high priority so it actually happens)".
>
> I'm not a scheduler person, so I don't know.  But "don't run me unless
> I'm isolated" seems like a design that will, at best, only ever work
> by dumb luck.  You have to disable migration, avoid other runnable
> tasks, hope that the kernel keeps working the way it did when you
> wrote the patch, hope you continue to get lucky enough that you ever
> get to user mode in the first place, etc.

Could you explain the "dumb luck" characterization a bit more?

You're definitely right that I need to test for isolcpus separately
now that it's been decoupled from nohz_full again, so I will
add that to the next release of the series.

But the rest of it seems like things you just control for when you
are running the application, and if you do it right, the
application runs.  If you don't (e.g. you intentionally schedule
multiple processes on the same core), the app doesn't run,
and you fix it in development.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

