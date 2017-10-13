From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 14:50:13 +0200
Message-ID: <19edaac0-98d7-e7a0-aceb-b861a2befce4@redhat.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/13/2017 01:03 AM, Mathieu Desnoyers wrote:
> Expose a new system call allowing each thread to register one userspace
> memory area to be used as an ABI between kernel and user-space for two
> purposes: user-space restartable sequences and quick access to read the
> current CPU number value from user-space.
> 
> * Restartable sequences (per-cpu atomics)
> 
> Restartables sequences allow user-space to perform update operations on
> per-cpu data without requiring heavy-weight atomic operations.
> 
> The restartable critical sections (percpu atomics) work has been started
> by Paul Turner and Andrew Hunter. It lets the kernel handle restart of
> critical sections. [1] [2] The re-implementation proposed here brings a
> few simplifications to the ABI which facilitates porting to other
> architectures and speeds up the user-space fast path. A locking-based
> fall-back, purely implemented in user-space, is proposed here to deal
> with debugger single-stepping. This fallback interacts with rseq_start()
> and rseq_finish(), which force retries in response to concurrent
> lock-based activity.

This functionality essentially relies on writable function pointers (or 
pointers to data containing function pointers), right?  Is there a way 
to make this a less attractive target for exploit writers?

Thanks,
Florian
