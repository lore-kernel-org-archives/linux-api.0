From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for 4.18 2/6] rseq: use get_user/put_user rather than __get_user/__put_user
Date: Mon, 9 Jul 2018 11:04:28 -0700
Message-ID: <CA+55aFzpjA3r9HdfCU5LrEhSt6S=+RfKuJ2GVc8Wv5Hz-_Me8Q@mail.gmail.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
 <20180708210330.27324-3-mathieu.desnoyers@efficios.com> <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 9, 2018 at 10:28 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> So, another twist to this story: ppc32 does not implement u64 get_user().

I was going to say that "that's not possible", since we actually have
64-bit arguments at least in the form of "loff_t __user *".

But when I started looking, it turns out that yeah, we do
"copy_from_user()" on them, and instead made the x86 copy_from_user()
have special cases for constant sizes.

So a 8-byte copy_from_user() is fine. It ends up being a "get_user()"
on x86 anyway.

                Linus
