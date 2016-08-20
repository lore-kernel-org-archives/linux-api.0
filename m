From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH] Fix /proc/stat freezes (was [PATCH v15] "task_isolation"
 mode)
Date: Fri, 19 Aug 2016 21:42:19 -0400
Message-ID: <427287c8-3fa8-093c-29ac-d492a88a6337@mellanox.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1608171432200.30568@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1608171432200.30568@east.gentwo.org>
Sender: linux-doc-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 8/17/2016 3:37 PM, Christoph Lameter wrote:
> On Tue, 16 Aug 2016, Chris Metcalf wrote:
>
>> - Dropped Christoph Lameter's patch to avoid scheduling the
>>    clocksource watchdog on nohz cores; the recommendation is to just
>>    boot with tsc=reliable for NOHZ in any case, if necessary.
> We also said that there should be a WARN_ON if tsc=reliable is not
> specified and processors are put into NOHZ mode. This is something not
> obvious causing scheduling events on NOHZ processors.

Yes, I agree.  Frederic said he would queue a patch to do that, so I
didn't want to propose another patch that would conflict.

>> Frederic, do you have a sense of what is left to be done there?
>> I can certainly try to contribute to that effort as well.
> Here is a potential fix to the problem that /proc/stat values freeze when
> processors go into NOHZ busy mode. I'd like to hear what people think
> about the approach here. In particular one issue may be that I am
> accessing remote tick-sched structures without serialization. But for
> top/ps this may be ok. I noticed that other values shown by top/os also
> sometime are a bit fuzzy.

This seems pretty plausible to me, but I'm not an expert on what kind
of locking might be required for these data structures.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

