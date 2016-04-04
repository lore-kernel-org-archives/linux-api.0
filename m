From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Mon, 4 Apr 2016 19:46:28 +0000 (UTC)
Message-ID: <492303698.44994.1459799188052.JavaMail.zimbra@efficios.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com> <1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com> <5702A037.60200@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5702A037.60200@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Apr 4, 2016, at 1:11 PM, H. Peter Anvin hpa@zytor.com wrote:

> On 04/04/16 10:01, Mathieu Desnoyers wrote:
>> 
>> Changes since v5:
>> - Rename "getcpu_cache" to "thread_local_abi", allowing to extend
>>   this system call to cover future features such as restartable critical
>>   sections. Generalizing this system call ensures that we can add
>>   features similar to the cpu_id field within the same cache-line
>>   without having to track one pointer per feature within the task
>>   struct.
>> - Add a tlabi_nr parameter to the system call, thus allowing to extend
>>   the ABI beyond the initial 64-byte structure by registering structures
>>   with tlabi_nr greater than 0. The initial ABI structure is associated
>>   with tlabi_nr 0.
>> - Rebased on kernel v4.5.
>> 
> 
> This seems absolutely insanely complex, both for the kernel and for
> userspace.
> 
> A much saner way would be for userspace to query the kernel for the size
> of the structure; userspace then allocates the maximum of what it knows
> and what the kernel knows.  That way, the kernel doesn't need to
> conditionalize its accesses to user space, and libc doesn't need to
> conditionalize its accesses either.

If we go down the route of having user-space dynamically allocating
the structure, my understanding is that we need to associate the
user-space TLS symbol with a pointer to the structure, and test for
NULL each time, thus requiring user-space to touch one more cache-line
(read the pointer), and add one conditional per user-space fast-path,
compared to a statically-sized definition approach. Or perhaps you have
some clever trick in mind for "allocation by user-space" that I'm missing ?

Besides the NULL pointer check, another issue is feature detection.
As we extend the feature set, my proposal has a 32-bit features
mask at the beginning of the TLS structure, within the same
cache-line containing the structure fields, so user-space can quickly
check whether the required feature is enabled (adds one conditional
on the user-space fast path, but does not require to touch another
cache-line). This allows adding new features without requiring to
reserve the value "0" within each field of the structure to mean
"feature unavailable", which I find terminally unaesthetic.

I propose here a fixed-size 64 bytes layout for the first structure,
for which a 32-bit feature mask should be enough. If we ever fill
up these 64 bytes, we can then use the following tlabi_nr number (1),
which will define its own structure size and feature mask. This
seems like a good compromise between fast-path speed, feature detection
flexibility, optimal use of cache-lines, and extensibility.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
