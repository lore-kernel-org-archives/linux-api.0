From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: [PATCH v12 06/13] task_isolation: support
 PR_TASK_ISOLATION_STRICT mode
Date: Wed, 18 May 2016 12:34:59 -0400
Message-ID: <4c0e9098-248c-eca1-03f6-b7b2eee997a9@mellanox.com>
References: <1459877922-15512-1-git-send-email-cmetcalf@mellanox.com>
 <1459877922-15512-7-git-send-email-cmetcalf@mellanox.com>
 <20160518134406.GI3193@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160518134406.GI3193@twins.programming.kicks-ass.net>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 5/18/2016 9:44 AM, Peter Zijlstra wrote:
> On Tue, Apr 05, 2016 at 01:38:35PM -0400, Chris Metcalf wrote:
>> +void task_isolation_interrupt(struct task_struct *task, const char *buf)
>> +{
>> +	siginfo_t info = {};
>> +	int sig;
>> +
>> +	pr_warn("%s/%d: task_isolation strict mode violated by %s\n",
>> +		task->comm, task->pid, buf);
>> +
> So the function name suggests this is called for interrupts, except its
> purpose is to deliver a signal.

Fair point.  I'll name it task_isolation_deliver_signal() in the next patch series.

> Now, in case of exceptions the violation isn't necessarily _by_ the task
> itself. You might want to change that to report the exception
> type/number instead of the affected task.

Well, we do report whatever exception information we have.  For example
a page fault exception will report the address or whatever other info is
handy; it's easy to tune since it's just a vsnprintf of some varargs from the
architecture layer.

For things like IPIs or TLB invalidations or whatever, the code currently just
reports "interrupt"; I could arrange to pass down more informative varargs
from the caller for that as well.  Let me look into it.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

