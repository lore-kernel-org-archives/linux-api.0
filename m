From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v7 03/11] task_isolation: support PR_TASK_ISOLATION_STRICT mode
Date: Tue, 29 Sep 2015 10:46:54 -0700
Message-ID: <CALCETrUp+8UG5dKLdybcmhhfzcyUP8h-RJHcG0Bo7Up=Rx6DVA@mail.gmail.com>
References: <1443453446-7827-1-git-send-email-cmetcalf@ezchip.com>
 <1443453446-7827-4-git-send-email-cmetcalf@ezchip.com> <CALCETrU7bheOSeuE8RxATBiyzQ=sPAC4jbXsqvZHgu8-5FY0zg@mail.gmail.com>
 <5609B713.5020709@ezchip.com> <CALCETrV7npkg4MPi6Z6Wd_mYh1OrsKnGjB1RWGTAWOnaL+gARQ@mail.gmail.com>
 <560ACBD9.90909@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560ACBD9.90909-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 29, 2015 at 10:35 AM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
> On 09/28/2015 06:38 PM, Andy Lutomirski wrote:
>>
>> On Mon, Sep 28, 2015 at 2:54 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>> wrote:
>>>
>>> On 09/28/2015 04:51 PM, Andy Lutomirski wrote:
>>>>
>>>> On Mon, Sep 28, 2015 at 11:17 AM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>>>>>
>>>>> @@ -35,8 +36,12 @@ static inline enum ctx_state exception_enter(void)
>>>>>                   return 0;
>>>>>
>>>>>           prev_ctx = this_cpu_read(context_tracking.state);
>>>>> -       if (prev_ctx != CONTEXT_KERNEL)
>>>>> -               context_tracking_exit(prev_ctx);
>>>>> +       if (prev_ctx != CONTEXT_KERNEL) {
>>>>> +               if (context_tracking_exit(prev_ctx)) {
>>>>> +                       if (task_isolation_strict())
>>>>> +                               task_isolation_exception();
>>>>> +               }
>>>>> +       }
>>>>>
>>>>>           return prev_ctx;
>>>>>    }
>>>>
>>>> x86 does not promise to call this function.  In fact, x86 is rather
>>>> likely to stop ever calling this function in the reasonably near
>>>> future.
>>>
>>>
>>> Yes, in which case we'd have to do it the same way we are doing
>>> it for arm64 (see patch 09/11), by calling task_isolation_exception()
>>> explicitly from within the relevant exception handlers.  If we start
>>> doing that, it's probably worth wrapping up the logic into a single
>>> inline function to keep the added code short and sweet.
>>>
>>> If in fact this might happen in the short term, it might be a good
>>> idea to hook the individual exception handlers in x86 now, and not
>>> hook the exception_enter() mechanism at all.
>>
>> It's already like that in Linus' tree.
>
>
> OK, I will restructure so that it doesn't rely on the context_tracking
> code at all, but instead requires a line of code in every relevant
> kernel exception handler.
>
>> FWIW, most of those exception handlers send signals, so it might pay
>> to do it in notify_die or die instead.
>
>
> Well, the most interesting category is things that don't actually
> trigger a signal (e.g. minor page fault) since those are things that
> cause significant issues with task isolation processes
> (kernel-induced jitter) but aren't otherwise user-visible,
> much like an undiscovered syscall in a third-party library
> can cause unexpected jitter.

Would it make sense to exempt the exceptions that result in signals?
After all, those are detectable even without your patches.  Going
through all of the exception types:

divide_error, overflow, invalid_op, coprocessor_segment_overrun,
invalid_TSS, segment_not_present, stack_segment, alignment_check:
these all send signals anyway.

double_fault is fatal.

bounds: MPX faults can be silently fixed up, and those will need
notification.  (Or user code should know not to do that, since it
requires an explicit opt in, and user code can flip it back off to get
the signals.)

general_protection: always signals except in vm86 mode.

int3: silently fixed if uprobes are in use, but I don't think
isolation cares about that.  Otherwise signals.

debug: The perf hw_breakpoint can result in silent fixups, but those
require explicit opt-in from the admin.  Otherwise, unless there's a
bug or a debugger, the user will get a signal.  (As a practical
matter, the only interesting case is the undocumented ICEBP
instruction.)

math_error, simd_coprocessor_error: Sends a signal.

spurious_interrupt_bug: Irrelevant on any modern CPU AFAIK.  We should
just WARN if this hits.

device_not_available: If you're using isolation without an FPU, you
have bigger problems.

page_fault: Needs notification.

NMI, MCE: arguably these should *not* notify or at least not fatally.

So maybe a better approach would be to explicitly notify for the
relevant entries: IRQs, non-signalling page faults, and non-signalling
MPX fixups.  Other arches would have their own lists, but they're
probably also short except for emulated instructions.

--Andy
