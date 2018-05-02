From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Wed, 2 May 2018 12:42:53 -0400
Message-ID: <20180502124253.145253cb@gandalf.local.home>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
        <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
        <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
        <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, boqun.feng@gmail.com, luto@amacapital.net, davejwatson@fb.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, Andrew Hunter <ahh@google.com>, andi@firstfloor.org, cl@linux.com, bmaurer@fb.com, josh@joshtriplett.org, torvalds@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, 02 May 2018 16:07:48 +0000
Daniel Colascione <dancol@google.com> wrote:

> Why couldn't we take a page fault just before schedule? The reason we can't
> take a page fault in atomic context is that doing so might call schedule.
> Here, we're about to call schedule _anyway_, so what harm does it do to
> call something that might call schedule? If we schedule via that call, we
> can skip the manual schedule we were going to perform.

Another issue is slowing down something that is considered a fast path.

-- Steve
