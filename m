From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU number
 of running thread
Date: Mon, 4 Apr 2016 10:11:19 -0700
Message-ID: <5702A037.60200@zytor.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459789313-4917-2-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On 04/04/16 10:01, Mathieu Desnoyers wrote:
> 
> Changes since v5:
> - Rename "getcpu_cache" to "thread_local_abi", allowing to extend
>   this system call to cover future features such as restartable critical
>   sections. Generalizing this system call ensures that we can add
>   features similar to the cpu_id field within the same cache-line
>   without having to track one pointer per feature within the task
>   struct.
> - Add a tlabi_nr parameter to the system call, thus allowing to extend
>   the ABI beyond the initial 64-byte structure by registering structures
>   with tlabi_nr greater than 0. The initial ABI structure is associated
>   with tlabi_nr 0.
> - Rebased on kernel v4.5.
> 

This seems absolutely insanely complex, both for the kernel and for
userspace.

A much saner way would be for userspace to query the kernel for the size
of the structure; userspace then allocates the maximum of what it knows
and what the kernel knows.  That way, the kernel doesn't need to
conditionalize its accesses to user space, and libc doesn't need to
conditionalize its accesses either.

	-hpa
