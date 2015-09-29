From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v7 03/11] task_isolation: support PR_TASK_ISOLATION_STRICT
 mode
Date: Tue, 29 Sep 2015 13:35:21 -0400
Message-ID: <560ACBD9.90909@ezchip.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-4-git-send-email-cmetcalf@ezchip.com>
 <CALCETrU7bheOSeuE8RxATBiyzQ=sPAC4jbXsqvZHgu8-5FY0zg@mail.gmail.com>
 <5609B713.5020709@ezchip.com>
 <CALCETrV7npkg4MPi6Z6Wd_mYh1OrsKnGjB1RWGTAWOnaL+gARQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALCETrV7npkg4MPi6Z6Wd_mYh1OrsKnGjB1RWGTAWOnaL+gARQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 09/28/2015 06:38 PM, Andy Lutomirski wrote:
> On Mon, Sep 28, 2015 at 2:54 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
>> On 09/28/2015 04:51 PM, Andy Lutomirski wrote:
>>> On Mon, Sep 28, 2015 at 11:17 AM, Chris Metcalf <cmetcalf@ezchip.com>
>>>> @@ -35,8 +36,12 @@ static inline enum ctx_state exception_enter(void)
>>>>                   return 0;
>>>>
>>>>           prev_ctx = this_cpu_read(context_tracking.state);
>>>> -       if (prev_ctx != CONTEXT_KERNEL)
>>>> -               context_tracking_exit(prev_ctx);
>>>> +       if (prev_ctx != CONTEXT_KERNEL) {
>>>> +               if (context_tracking_exit(prev_ctx)) {
>>>> +                       if (task_isolation_strict())
>>>> +                               task_isolation_exception();
>>>> +               }
>>>> +       }
>>>>
>>>>           return prev_ctx;
>>>>    }
>>> x86 does not promise to call this function.  In fact, x86 is rather
>>> likely to stop ever calling this function in the reasonably near
>>> future.
>>
>> Yes, in which case we'd have to do it the same way we are doing
>> it for arm64 (see patch 09/11), by calling task_isolation_exception()
>> explicitly from within the relevant exception handlers.  If we start
>> doing that, it's probably worth wrapping up the logic into a single
>> inline function to keep the added code short and sweet.
>>
>> If in fact this might happen in the short term, it might be a good
>> idea to hook the individual exception handlers in x86 now, and not
>> hook the exception_enter() mechanism at all.
> It's already like that in Linus' tree.

OK, I will restructure so that it doesn't rely on the context_tracking
code at all, but instead requires a line of code in every relevant
kernel exception handler.

> FWIW, most of those exception handlers send signals, so it might pay
> to do it in notify_die or die instead.

Well, the most interesting category is things that don't actually
trigger a signal (e.g. minor page fault) since those are things that
cause significant issues with task isolation processes
(kernel-induced jitter) but aren't otherwise user-visible,
much like an undiscovered syscall in a third-party library
can cause unexpected jitter.

> For x86, the relevant info might be the actual hw error number
> (error_code, which makes it into die) or the signal.  If we send a
> death signal, then reporting the error number the usual way might make
> sense.

I may just choose to use a task_isolation_exception(fmt, ...)
signature so that code can printk a suitable one-liner before
delivering the SIGKILL (or whatever signal was configured).

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

