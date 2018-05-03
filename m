From: Daniel Colascione <dancol@google.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Thu, 03 May 2018 16:22:00 +0000
Message-ID: <CAKOZuetW5NEvbROjuquQ_AxrW7BqR5Qfp6BYfy+zUrnPkZDaTw@mail.gmail.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
 <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
 <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com> <1718748931.10084.1525363941807.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1718748931.10084.1525363941807.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, rostedt@goodmis.org, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, May 3, 2018 at 9:12 AM Mathieu Desnoyers <
mathieu.desnoyers@efficios.com> wrote:
> By the way, if we eventually find a way to enhance user-space mutexes in
the
> fashion you describe here, it would belong to another TLS area, and would
> be registered by another system call than rseq. I proposed a more generic
> "TLS area registration" system call a few years ago, but Linus told me he
> wanted a system call that was specific to rseq. If we need to implement
> other use-cases in a TLS area shared between kernel and user-space in a
> similar fashion, the plan is to do it in a distinct system call.

If we proliferate TLS areas; we'd have to register each one upon thread
creation, adding to the overall thread creation path. There's already a
provision for versioning the TLS area. What's the benefit of splitting the
registration over multiple system calls?
