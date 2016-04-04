From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Mon, 4 Apr 2016 20:48:23 +0000 (UTC)
Message-ID: <856357054.45028.1459802903401.JavaMail.zimbra@efficios.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com> <1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com> <5702A037.60200@zytor.com> <492303698.44994.1459799188052.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <492303698.44994.1459799188052.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 4, 2016, at 3:46 PM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> ----- On Apr 4, 2016, at 1:11 PM, H. Peter Anvin hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org wrote:
> 
>> On 04/04/16 10:01, Mathieu Desnoyers wrote:
>>> 
>>> Changes since v5:
>>> - Rename "getcpu_cache" to "thread_local_abi", allowing to extend
>>>   this system call to cover future features such as restartable critical
>>>   sections. Generalizing this system call ensures that we can add
>>>   features similar to the cpu_id field within the same cache-line
>>>   without having to track one pointer per feature within the task
>>>   struct.
>>> - Add a tlabi_nr parameter to the system call, thus allowing to extend
>>>   the ABI beyond the initial 64-byte structure by registering structures
>>>   with tlabi_nr greater than 0. The initial ABI structure is associated
>>>   with tlabi_nr 0.
>>> - Rebased on kernel v4.5.
>>> 
>> 
>> This seems absolutely insanely complex, both for the kernel and for
>> userspace.
>> 
>> A much saner way would be for userspace to query the kernel for the size
>> of the structure; userspace then allocates the maximum of what it knows
>> and what the kernel knows.  That way, the kernel doesn't need to
>> conditionalize its accesses to user space, and libc doesn't need to
>> conditionalize its accesses either.
> 
> If we go down the route of having user-space dynamically allocating
> the structure, my understanding is that we need to associate the
> user-space TLS symbol with a pointer to the structure, and test for
> NULL each time, thus requiring user-space to touch one more cache-line
> (read the pointer), and add one conditional per user-space fast-path,
> compared to a statically-sized definition approach. Or perhaps you have
> some clever trick in mind for "allocation by user-space" that I'm missing ?
> 
> Besides the NULL pointer check, another issue is feature detection.
> As we extend the feature set, my proposal has a 32-bit features
> mask at the beginning of the TLS structure, within the same
> cache-line containing the structure fields, so user-space can quickly
> check whether the required feature is enabled (adds one conditional
> on the user-space fast path, but does not require to touch another
> cache-line). This allows adding new features without requiring to
> reserve the value "0" within each field of the structure to mean
> "feature unavailable", which I find terminally unaesthetic.
> 
> I propose here a fixed-size 64 bytes layout for the first structure,
> for which a 32-bit feature mask should be enough. If we ever fill
> up these 64 bytes, we can then use the following tlabi_nr number (1),
> which will define its own structure size and feature mask. This
> seems like a good compromise between fast-path speed, feature detection
> flexibility, optimal use of cache-lines, and extensibility.

Moreover, the feature set that the application knows about, glibc
knows about, and the kernel knows about are three different things.
My intent here is to have glibc stay out of the way as much as possible,
since this is really an interface between various applications/libraries
and the kernel.

Even if glibc allocates a structure large enough for the union of
the features it knows about and the features the kernel implements,
the application could be built against kernel headers that expose
more features than glibc knows about, and would therefore need to
have a structure length check, for an added branch on the fast path
if we dynamically allocate the tlabi structure.

A statically-sized structure allows application and libraries to
skip pointer load, NULL checks, and structure length checks on
the user-space fast-path.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
