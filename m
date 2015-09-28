From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v7 03/11] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Mon, 28 Sep 2015 15:38:28 -0700
Message-ID: <CALCETrV7npkg4MPi6Z6Wd_mYh1OrsKnGjB1RWGTAWOnaL+gARQ@mail.gmail.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-4-git-send-email-cmetcalf@ezchip.com> <CALCETrU7bheOSeuE8RxATBiyzQ=sPAC4jbXsqvZHgu8-5FY0zg@mail.gmail.com>
 <5609B713.5020709@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5609B713.5020709@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 2:54 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> On 09/28/2015 04:51 PM, Andy Lutomirski wrote:
>>
>> On Mon, Sep 28, 2015 at 11:17 AM, Chris Metcalf <cmetcalf@ezchip.com>
>>> @@ -35,8 +36,12 @@ static inline enum ctx_state exception_enter(void)
>>>                  return 0;
>>>
>>>          prev_ctx = this_cpu_read(context_tracking.state);
>>> -       if (prev_ctx != CONTEXT_KERNEL)
>>> -               context_tracking_exit(prev_ctx);
>>> +       if (prev_ctx != CONTEXT_KERNEL) {
>>> +               if (context_tracking_exit(prev_ctx)) {
>>> +                       if (task_isolation_strict())
>>> +                               task_isolation_exception();
>>> +               }
>>> +       }
>>>
>>>          return prev_ctx;
>>>   }
>>
>> x86 does not promise to call this function.  In fact, x86 is rather
>> likely to stop ever calling this function in the reasonably near
>> future.
>
>
> Yes, in which case we'd have to do it the same way we are doing
> it for arm64 (see patch 09/11), by calling task_isolation_exception()
> explicitly from within the relevant exception handlers.  If we start
> doing that, it's probably worth wrapping up the logic into a single
> inline function to keep the added code short and sweet.
>
> If in fact this might happen in the short term, it might be a good
> idea to hook the individual exception handlers in x86 now, and not
> hook the exception_enter() mechanism at all.

It's already like that in Linus' tree.

FWIW, most of those exception handlers send signals, so it might pay
to do it in notify_die or die instead.

>
>>> --- a/kernel/context_tracking.c
>>> +++ b/kernel/context_tracking.c
>>> @@ -144,15 +144,16 @@ NOKPROBE_SYMBOL(context_tracking_user_enter);
>>>    * This call supports re-entrancy. This way it can be called from any
>>> exception
>>>    * handler without needing to know if we came from userspace or not.
>>>    */
>>> -void context_tracking_exit(enum ctx_state state)
>>> +bool context_tracking_exit(enum ctx_state state)
>>
>> This needs clear documentation of what the return value means.
>
>
> Added:
>
>  * Return: if called with state == CONTEXT_USER, the function returns
>  * true if we were in fact previously in user mode.

This should note that it only returns true if context tracking is on.

>>> +void task_isolation_exception(void)
>>> +{
>>> +       pr_warn("%s/%d: task_isolation strict mode violated by
>>> exception\n",
>>> +               current->comm, current->pid);
>>> +       kill_task_isolation_strict_task();
>>> +}
>>
>> Should this say what exception?
>
>
> I could modify it to take a string argument (and then use it for
> the arm64 case at least).  For the exception_enter() caller, we actually
> don't have the information available to pass down, and it would
> be hard to get it.

For x86, the relevant info might be the actual hw error number
(error_code, which makes it into die) or the signal.  If we send a
death signal, then reporting the error number the usual way might make
sense.

--Andy
