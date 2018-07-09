From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for 4.18 2/6] rseq: use get_user/put_user rather than __get_user/__put_user
Date: Mon, 9 Jul 2018 12:04:44 -0700
Message-ID: <CA+55aFzC8P=yNc9eNkU+09dUvXJ+MMUXMCCe9kNx6R9MEJ3rjg@mail.gmail.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com>
 <20180708210330.27324-3-mathieu.desnoyers@efficios.com> <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com>
 <CA+55aFzpjA3r9HdfCU5LrEhSt6S=+RfKuJ2GVc8Wv5Hz-_Me8Q@mail.gmail.com> <1519037424.2393.1531160359475.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519037424.2393.1531160359475.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 9, 2018 at 11:19 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Given that this memory area has already been checked with access_ok()
> on rseq registration, are you fine with leaving
> __get_user/__put_user/__copy_{from,to}_user in place so we do the
> minimal change at this stage of rc, or should I go ahead and replace
> the lot with get_user/put_user/copy_{from,to}_user ?

Do the full replacement, and let's get this over and done with.

              Linus
