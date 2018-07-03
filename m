From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields, validate
 user inputs
Date: Mon, 2 Jul 2018 19:18:38 -0700
Message-ID: <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com>
 <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com>
 <415287289.10831.1530572418907.JavaMail.zimbra@efficios.com>
 <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com>
 <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com>
 <1959930320.10843.1530573742647.JavaMail.zimbra@efficios.com>
 <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net> <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
 <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 2, 2018 at 7:01 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> One thing to consider is how we will implement the load of that pointer
> on the kernel side.

Use "get_user()". It works for 64-bit objects too, and it will be
atomic in the 32-bit sub-parts on a 32-bit architecture.

Again: there is no point in trying to be atomic in the full 64 bits
(when you're running on 32-bit). The upper bits don't have to "match"
the lower bits. They just have to be zero. So doing it as two loads is
fine - the same way it's perfectly fine to do it as two stores (since
the store to the upper bits will always be zero).

            Linus
