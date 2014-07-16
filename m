From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v10 0/11] seccomp: add thread sync ability
Date: Wed, 16 Jul 2014 14:23:25 -0700
Message-ID: <CAGXu5jKMwiAxeCVZVPS72XWCd2KhiR-uc4VFKT0mvD9s-cTO_Q@mail.gmail.com>
References: <1405017631-27346-1-git-send-email-keescook@chromium.org>
	<20140711164931.GA18473@redhat.com>
	<CAGXu5jK-x0=Rr7kX2a=b4Z8ueA77uwmhNZZAayG8cwmNOKa8Ug@mail.gmail.com>
	<CALCETrVXgA9a2f7VwnCYW4_XB+JAPRSR8xsuH_ZYbA82=ZozRw@mail.gmail.com>
	<CAGXu5j+r-CpJiXipCT=j09+ZfJjF9jTc3kuZFAH3ZxgUEvktTA@mail.gmail.com>
	<CALCETrX48nuR6wqEV4Nu47BF4Z3XFvBpYer_fzwaqJdi0fpdKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALCETrX48nuR6wqEV4Nu47BF4Z3XFvBpYer_fzwaqJdi0fpdKw@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 16, 2014 at 12:45 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jul 16, 2014 at 10:54 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Jul 14, 2014 at 12:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Jul 11, 2014 at 10:55 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> On Fri, Jul 11, 2014 at 9:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>>>> On 07/10, Kees Cook wrote:
>>>>>>
>>>>>> This adds the ability for threads to request seccomp filter
>>>>>> synchronization across their thread group (at filter attach time).
>>>>>> For example, for Chrome to make sure graphic driver threads are fully
>>>>>> confined after seccomp filters have been attached.
>>>>>>
>>>>>> To support this, locking on seccomp changes via thread-group-shared
>>>>>> sighand lock is introduced, along with refactoring of no_new_privs. Races
>>>>>> with thread creation are handled via delayed duplication of the seccomp
>>>>>> task struct field and cred_guard_mutex.
>>>>>>
>>>>>> This includes a new syscall (instead of adding a new prctl option),
>>>>>> as suggested by Andy Lutomirski and Michael Kerrisk.
>>>>>
>>>>> I do not not see any problems in this version,
>>>>
>>>> Awesome! Thank you for all the reviews. :) If Andy and Michael are
>>>> happy with this too, I think this is in good shape. \o/
>>>
>>> I think I'm happy with it.  Is it in git somewhere for easy perusal?
>>> I have a cold, so my reviewing ability is a bit off, but I want to
>>> take a look at the final version, and git is a little easier than
>>> email for this.
>>
>> Hi Andy,
>>
>> Have you had a chance to look v10 over? I'd like to send a v11 with
>> Oleg's Reviewed-by added (at James Morris's request). Should I add one
>> from you as well?
>
> Trivial nits (take them or leave them):
>
> seccomp_check_mode confused me.  Maybe seccomp_may_assign_mode would
> be a better name.

Good idea; I was unhappy with this name too. Done for v11.

> In the writer locking changelog, should "(which is unique to the
> thread group)" be "(which is shared by all threads in the thread
> group)"?

Done.

> This bit:
>
>     /*
>      * Explicitly enable no_new_privs here in case it got set
>      * between the task_struct being duplicated and holding the
>      * sighand lock. The seccomp state and nnp must be in sync.
>      */
>     if (task_no_new_privs(current))
>         task_set_no_new_privs(p);
>
> should arguably move the very end of task duplication -- someone will
> want it for some other purpose some day.

That certainly seems plausible, but for the moment, I want to keep nnp
near seccomp, since that's where we have a race.

> This bit:
>
>     /* If we have a seccomp mode, enable the thread flag. */
>     if (p->seccomp.mode != SECCOMP_MODE_DISABLED)
>         set_tsk_thread_flag(p, TIF_SECCOMP);
>
> is not quite obvious to me -- it's not obvious why it's needed.  If
> it's to eliminate a race, can you explain the race in the comment?  If
> it's just paranoia, a WARN_ON or BUG_ON might be worthwhile.

I've expanded the comment; it's the same issue as nnp: seccomp could
have changed, so if we gained a mode, we need to set the flag too.

> SECCOMP_FILTER_FLAG_MASK seems backwards to me.  Maybe rename it to
> SECCOMP_FILTER_ALLOWED_FLAGS and invert it?

Excellent point. Other kernel users of the _MASK name aren't inverted. Fixed.

> is_ancestor: calling the first parameter "candidate" is just a tiny
> bit odd -- it's the child that's up for consideration.  (This is
> barely even worth the time it took me to type it.)

Switch argument and comment to "parent".

> Less trivial nits:
>
> Can you change:
>
> fp = kzalloc(fp_size, GFP_KERNEL|__GFP_NOWARN);
>
> to
>
> fp = kcalloc(fprog->len, sizeof(struct sock_filter), GFP_KERNEL|__GFP_NOWARN);
>
> somewhere in this series (w/ a changelog comment that it's not
> exploitable to avoid scaring people).

Done, though I used a BUG_ON since the compiler will optimize it out
(since it's an impossible state to be in).

> In seccomp_prepare_user_filter, would it make sense to return -EINVAL
> if !user_filter?  That will make it slightly more pleasant to
> implement TSYNC-without-change if anyone ever wants it.  (This isn't
> really necessary -- it's just slightly more polite.)

I can't do this since EFAULT is already used to detect seccomp
capabilities from userspace.

> Once James picks this up, I'll rebase my series on top of it.  I think
> they'll conflict slightly.

It's not bad. I tripped over sd -> sd_local and the related sd vs &sd
in the SK_RUN_FILTER call, but otherwise it was pretty trivial.

> Feel free to add my Reviewed-by to the whole series except the ARM and
> MIPS patches.

Thanks!

> And some thoughts:
>
> Your changelog comment for the seccomp syscall suggests that you're
> thinking about extending the tracer interface.  I'd suggest a rather
> different design: add a concept of a seccomp monitor associated with a
> particular filter and an action SECCOMP_RET_MONITOR.
> SECCOMP_RET_MONITOR will tell the monitor what syscall was attempted
> and will wait for further instructions.  The monitor can then ask for
> zero or more syscalls to be issued on behalf of the waiting process
> and then resume it.  Each of those additional syscalls will be further
> filtered through all seccomp filters outside of the one that returned
> SECCOMP_RET_MONITOR.
>
> This would avoid all of the nastiness inherent in using ptrace and
> would nest much more nicely.  And it could be far faster.
>
> If you decide to do something to ARM along the lines of what I'm doing
> to x86, you may want to fix this:
>
>     /*
>      * Make sure that any changes to mode from another thread have
>      * been seen after TIF_SECCOMP was seen.
>      */
>     rmb();
>
> It should have essentially no effect on x86, though.

Noted, thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
