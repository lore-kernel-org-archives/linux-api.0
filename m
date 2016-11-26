From: Paul Turner <pjt@kernel.org>
Subject: Re: [RFC PATCH v8 1/9] Restartable sequences system call
Date: Sat, 26 Nov 2016 15:43:06 -0800
Message-ID: <CAPM31RJENYEjctuQ89u8Yv2vvW-3e2CccYk-NAqkdq85smHxUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Sat, Aug 27, 2016 at 5:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
>> Expose a new system call allowing each thread to register one userspace
>> memory area to be used as an ABI between kernel and user-space for two
>> purposes: user-space restartable sequences and quick access to read the
>> current CPU number value from user-space.
>>
>> * Restartable sequences (per-cpu atomics)
>>
>> Restartables sequences allow user-space to perform update operations on
>> per-cpu data without requiring heavy-weight atomic operations.
>>
>> The restartable critical sections (percpu atomics) work has been started
>> by Paul Turner and Andrew Hunter. It lets the kernel handle restart of
>> critical sections. [1] [2] The re-implementation proposed here brings a
>> few simplifications to the ABI which facilitates porting to other
>> architectures and speeds up the user-space fast path. A locking-based
>> fall-back, purely implemented in user-space, is proposed here to deal
>> with debugger single-stepping. This fallback interacts with rseq_start()
>> and rseq_finish(), which force retries in response to concurrent
>> lock-based activity.
>
> Hmm. Purely software fallback needed for singlestepping... Looks like this is malware
> writer's dream come true...
>
> Also if you ever get bug in the restartable code, debugger will be useless to debug it...
> unless new abilities are added to debuggers to manually schedule threads on CPUs.
>
> Is this good idea?

We've had some off-list discussion.

I have a revised version which incoprorates some of Mattheiu's
improvements, but avoids this requirement nearly ready for posting.

- Paul
