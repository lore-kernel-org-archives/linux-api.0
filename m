From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] thread_local_abi: wire up ARM system call
Date: Thu, 10 Dec 2015 16:59:58 +0000 (UTC)
Message-ID: <1090286680.231411.1449766798422.JavaMail.zimbra@efficios.com>
References: <1449761990-23525-1-git-send-email-mathieu.desnoyers@efficios.com> <1449761990-23525-2-git-send-email-mathieu.desnoyers@efficios.com> <20151210162723.GN8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151210162723.GN8644-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 10, 2015, at 11:27 AM, Russell King - ARM Linux linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org wrote:

> On Thu, Dec 10, 2015 at 10:39:50AM -0500, Mathieu Desnoyers wrote:
>> Wire up the thread local ABI on ARM32. Call the
>> getcpu_cache_handle_notify_resume() function on return to userspace if
>> TIF_NOTIFY_RESUME thread flag is set.
>> 
>> This provides a way to implement a sched_getcpu() on ARM without
>> requiring to perform a system call on the fast path.
>> 
>> [ Untested. ]
> 
> Why are you sending this _to_ Thomas?  Shouldn't you be sending it to me
> as the arch maintainer?

Thomas showed interest in trying it out on ARM, which is why I'm
sending this RFC patch "To" him. Of course, I plan to send it
to you if it goes beyond RFC stage.

> 
>> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
>> index 7b84657..ef55382 100644
>> --- a/arch/arm/include/asm/unistd.h
>> +++ b/arch/arm/include/asm/unistd.h
>> @@ -19,7 +19,7 @@
>>   * This may need to be greater than __NR_last_syscall+1 in order to
>>   * account for the padding in the syscall table
>>   */
>> -#define __NR_syscalls  (392)
>> +#define __NR_syscalls  (393)
> 
> That will cause a build error.  Please leave this alone until we get to
> syscall 392, where upon it will need to be incremented by four.

Oops, right. Will do.

> 
> Also, I tend to wait until after -rc1 before adding any syscalls, when
> all the new syscalls are obvious and known - this avoids ending up with
> two different trees having allocated the same syscall number (which is
> why arch maintainers should be the only people who are responsible for
> merging updates to their arch's syscall numbering.)

Sounds good. Anyway please wait until I send a non-RFC patch before
doing so.

Thanks!

Mathieu

> 
> Sure, if multiple different people end up merging patches via different
> routes, the conflicts can be resolved when those different routes come
> together, but what happens if someone adds the syscall number that they
> thought they had to (eg) glibc, and then have to change it later because
> come -rc1 it ends up being different...
> 
> I'd much rather that all patches to unistd.h are only mergable via the
> respective arch maintainers to keep the numbering sane.
> 
> (I personally want to follow x86's syscall numbering order as much as
> possible.)
> 
> --
> RMK's Patch system: http://www.arm.linux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
