From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields, validate user inputs
Date: Tue, 3 Jul 2018 10:06:40 -0700
Message-ID: <6C9EE370-1BE4-4556-8B79-39BDBBAED7F8@amacapital.net>
References: <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net> <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com> <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com> <CA+55aFxWMjwx-4TGBHt0H6bh6FXC3NKMsjp=eKGw5cgA4wMBUA@mail.gmail.com> <1776351430.10902.1530585009519.JavaMail.zimbra@efficios.com> <20180703081449.GT2494@hirez.programming.kicks-ass.net> <20180703082955.GH3704@osiris> <20180703084312.GU2494@hirez.programming.kicks-ass.net> <20180703085546.GJ3704@osiris> <20180703092113.GV2494@hirez.programming.kicks-ass.net> <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703164048.i2te5gjemcafqzwf@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.c>
List-Id: linux-api@vger.kernel.org


On Jul 3, 2018, at 9:40 AM, Andi Kleen <andi@firstfloor.org> wrote:

>>=20
>> So I think you're good... But yes, you raise an interresting point.
>=20
> So it sounds like architectures that don't have an instruction atomic u64
> *_user need to disable interrupts during the access, and somehow handle th=
at
> case when a page fault happens?

I think all this discussion of =E2=80=9Catomic=E2=80=9D is a huge distractio=
n. The properties we need are:

- User code can change rseq_cs from one valid user pointer to another with a=
 single instruction (or equivalent) such that we can=E2=80=99t end up in the=
 kernel with the write only partially done as seen in that thread.

- The kernel needs to be able to read the value consistently with the above r=
equirement.

I don=E2=80=99t think it=E2=80=99s possible to have a valid implementation o=
f get_user() on any architecture that=E2=80=99s so weak that this doesn=E2=80=
=99t work.

If user code writes rseq_cs from the wrong thread, I think the user code is b=
uggy and we simply don=E2=80=99t care what happens.  The kernel should be al=
lowed to use an arbitrarily weak read with respect to other threads.
