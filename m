From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for 4.18 0/6] Restartable Sequences updates
Date: Sun, 8 Jul 2018 14:12:27 -0700
Message-ID: <CA+55aFzgnTMzssSKEkoLy+Mh29aAa4sFXiV=ouXZ8ivVKEJomw@mail.gmail.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Sun, Jul 8, 2018 at 2:03 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Following the recent discussion thread [1] about rseq uapi, here is
> a set of updates submitted for integration into 4.18. Those change all
> rseq __get_user/__put_user for get_user/put_user as discussed.

LGTM, FWIW. I didn't test it, but the patches look sane.

         Linus
