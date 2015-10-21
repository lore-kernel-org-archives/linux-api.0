From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode configurable signal
Date: Tue, 20 Oct 2015 18:42:52 -0700
Message-ID: <CALCETrXqDi24EPn79X9SXuz+5sYGZBF3yCRzb8PwdL=YbxVujw@mail.gmail.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-7-git-send-email-cmetcalf@ezchip.com> <20151020205610.51b3d742@grimm.local.home>
 <5626EABC.9060202@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5626EABC.9060202@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 6:30 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> On 10/20/2015 8:56 PM, Steven Rostedt wrote:
>>
>> On Tue, 20 Oct 2015 16:36:04 -0400
>> Chris Metcalf <cmetcalf@ezchip.com> wrote:
>>
>>> Allow userspace to override the default SIGKILL delivered
>>> when a task_isolation process in STRICT mode does a syscall
>>> or otherwise synchronously enters the kernel.
>>>
>> Is this really a good idea? This means that there's no way to terminate
>> a task in this mode, even if it goes astray.
>
>
> It doesn't map SIGKILL to some other signal unconditionally.  It just allows
> the "hey, you broke the STRICT contract and entered the kernel" signal
> to be something besides the default SIGKILL.
>

...which has the odd side effect that sending a non-fatal signal from
another process will cause the strict process to enter the kernel and
receive an extra signal.

I still dislike this thing.  It seems like a debugging feature being
implemented using signals instead of existing APIs.  I *still* don't
see why perf can't be used to accomplish your goal.

--Andy
