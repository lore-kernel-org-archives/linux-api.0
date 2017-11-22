From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op vector
Date: Wed, 22 Nov 2017 07:28:22 -0800
Message-ID: <CALCETrX84s-WEa5osP0t6CKh8C4Wj7-ARNMpaSp8Eop1_2ycLA@mail.gmail.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
 <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

On Tue, Nov 21, 2017 at 2:05 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Nov 21, 2017, at 12:21 PM, Andi Kleen andi@firstfloor.org wrote:
>
>> On Tue, Nov 21, 2017 at 09:18:38AM -0500, Mathieu Desnoyers wrote:
>>> Hi,
>>>
>>> Following changes based on a thorough coding style and patch changelog
>>> review from Thomas Gleixner and Peter Zijlstra, I'm respinning this
>>> series for another RFC.
>>>
>> My suggestion would be that you also split out the opv system call.
>> That seems to be main contention point currently, and the restartable
>> sequences should be useful without it.
>
> I consider rseq to be incomplete and a pain to use in various scenarios
> without cpu_opv.
>
> About the contention point you refer to:
>
> Using vDSO as an example of how things should be done is just wrong: the
> vDSO interaction with debugger instruction single-stepping is broken,
> as I detailed in my previous email.
>

If anyone ever reports that as a problem, I'll gladly fix it in the
kernel.  That's doable without an ABI change.  If rseq-like things
started breaking single-stepping, we can't just fix it in the kernel.

Also, there is one and only one vclock_gettime.  Debuggers can easily
special-case it.  For all I know, they already do.
