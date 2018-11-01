From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.21 00/16] rseq updates, new cpu_opv system call (v2)
Date: Thu, 1 Nov 2018 08:33:35 -0700
Message-ID: <CAHk-=wjk-2c4XvWjdzc-bs9Hbgvy-p7ASSnKKphggr5qDoXRDQ@mail.gmail.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, tglx@linutronix.de, luto@amacapital.net, davejwatson@fb.com, pjt@google.com, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, andi@firstfloor.org, Christoph Lameter <cl@linux.com>, bmaurer@fb.com, rostedt@goodmis.org, josh@joshtriplett.org, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, mtk.manpages@gmail.com, joelaf@google.com
List-Id: linux-api@vger.kernel.org

On Thu, Nov 1, 2018 at 2:59 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Here is an updated patchset submitted as RFC for 4.21 (next merge
> window).

So I'm not willing to take the cpu_opv system call until I see the the
regular rseq code getting more real-life use.

Maybe people are using it. Maybe they aren't. I want to hold off and
wait until we _know_ it's getting used, and not just in test
libraries.

                   Linus
