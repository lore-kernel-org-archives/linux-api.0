From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 12/23] cpu_opv: Provide cpu_opv system call
 (v7)
Date: Mon, 16 Apr 2018 15:21:19 -0400 (EDT)
Message-ID: <435471300.11403.1523906479091.JavaMail.zimbra@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com> <20180412192800.15708-13-mathieu.desnoyers@efficios.com> <CA+55aFxcJ2V_1BoW0Cct=Kkp7REkgiU_BTimGdmoFmWHaWaZ-g@mail.gmail.com> <CALCETrVvaMWUJKx+bxXdEm3oVBzn2r5RuJ4JcXNzOPSgJAC5PA@mail.gmail.com> <542721578.11358.1523903708510.JavaMail.zimbra@efficios.com> <CA+55aFzZtY5ELKc+TGf9BA6px300BNzedadm_yNXzODTKN=HgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzZtY5ELKc+TGf9BA6px300BNzedadm_yNXzODTKN=HgQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

----- On Apr 16, 2018, at 2:39 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Apr 16, 2018 at 11:35 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>> Specifically for single-stepping, the __rseq_table section introduced
>> at user-level will allow newer debuggers and tools which do line and
>> instruction-level single-stepping to skip over rseq critical sections.
>> However, this breaks existing debuggers and tools.
> 
> I really don't think single-stepping is a valid argument.
> 
> Even if the cpu_opv() allows you to "single step", you're not actually
> single stepping the same thing that you're using. So you are literally
> debugging something else than the real code.
> 
> At that point, you don't need "cpu_opv()", you need to just load
> /dev/urandom in a buffer, and single-step that. Ta-daa! No new kernel
> functionality needed.
> 
> So if the main argument for cpu_opv is single-stepping, then just rip
> it out. It's not useful.

No, single-stepping is not the only use-case. Accessing remote cpu
data is another use-case fulfilled by cpu_opv, which I think is more
compelling.

> 
> Anybody who cares deeply about single-stepping shouldn't be using
> optimistic algorithms, and they shouldn't be doing multi-threaded
> stuff either. They won't be able to use things like transactional
> memory either.
> 
> You can't single-step into the kernel to see what the kernel does
> either when you're debugging something.
> 
> News at 11: "single stepping isn't always viable".

I don't mind if people cannot stop the program with a debugger and
observe the state of registers manually at each step though a rseq
critical section.

I do mind breaking existing tools that rely on single-stepping
approaches to automatically analyze program behavior [1,2].
Introducing a rseq critical section into a library (e.g. glibc
memory allocator) would cause existing programs being analyzed
with existing tools to hang.

And I try very hard to avoid being told I'm the one breaking
user-space. ;-)

Thanks,

Mathieu

[1] http://rr-project.org/
[2] https://www.gnu.org/software/gdb/news/reversible.html

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
