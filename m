From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields, validate
 user inputs
Date: Mon, 2 Jul 2018 16:22:12 -0700
Message-ID: <CA+55aFyQwfXxMnx2WQadfZKAnEfkoT+zomrRRToZz8-uWzUccQ@mail.gmail.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com>
 <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com>
 <415287289.10831.1530572418907.JavaMail.zimbra@efficios.com>
 <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com> <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 4:17 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Are there any kind of guarantees that a __u64 update on a 32-bit architecture
> won't be torn into something daft like byte-per-byte stores when performed
> from C code ?

Guarantees? No. Not that there are any guarantees that the same won't
happen for a plain 32-bit value either.

Will compilers generate that kind of code? I guess some crazy compiler
could simply be really bad at handling 64-bit values, and just happen
to handle 32-bit values better. So in that sense a 64-bit entity is
certainly a bit riskier. But that would be a really bad compiler, I
have to say.

                Linus
