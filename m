From: Francis Giraldeau <francis.giraldeau@gmail.com>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Tue, 13 Sep 2016 12:00:33 -0400
Message-ID: <6651d87b-d827-ad2e-a38c-278eb0427bdb@gmail.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <20160912161444.GA5008@twins.programming.kicks-ass.net>
 <7820672.sYOlvzebIZ@vostro.rjw.lan> <1790609.DoEbHQ4oEN@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1790609.DoEbHQ4oEN@vostro.rjw.lan>
Sender: linux-doc-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Peter Zijlstra <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2016-09-12 08:05 PM, Rafael J. Wysocki wrote:
> On Monday, September 12, 2016 11:15:45 PM Rafael J. Wysocki wrote:
>> On Monday, September 12, 2016 06:14:44 PM Peter Zijlstra wrote:
>>> On Mon, Sep 12, 2016 at 12:01:58PM -0400, Chris Metcalf wrote:
>>>> On 9/7/2016 5:11 PM, Francis Giraldeau wrote:
>>>>> When running only the test_jitter(), the isolation mode is lost:
>>>>>
>>>>>     [ 6741.566048] isolation/9515: task_isolation mode lost due to irq_work
>>>>>
>>>>> With ftrace (events/workqueue/workqueue_execute_start), I get a bit more info:
>>>>>
>>>>>      kworker/1:1-676   [001] ....  6610.097128: workqueue_execute_start: work struct ffff8801a784ca20: function dbs_work_handler
>>>>>
>>>>> The governor was ondemand, so I tried to set the frequency scaling
>>>>> governor to performance, but that does not solve the issue.
>>>
>>> Rafael, I'm thinking the performance governor should be able to run
>>> without sending IPIs. Is there anything we can quickly do about that?
>>
>> The performance governor doesn't do any IPIs.
>>
>> At this point I'm not sure what's going on.
> 
> I've just tried and switching over to the performance governor makes
> dbs_work_handler go away for me (w/ -rc4 with some extra irrelevant patches
> on top) as it should.

Ho gosh, the command "cpufreq-set -g performance" sets the governor only
for cpu0. I was expecting it to set for all cpus. The isolation test runs
on cpu1 and this cpu was still with ondemand governor. With performance
governor, the dbs_work_handler does not occurs anymore and the isolated
task is not preempted by that kworker thread anymore.

Sorry for the noise and thanks for checking!

Francis
