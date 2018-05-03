From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Thu, 3 May 2018 14:04:24 -0400 (EDT)
Message-ID: <702933118.10410.1525370664578.JavaMail.zimbra@efficios.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com> <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com> <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com> <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com> <1718748931.10084.1525363941807.JavaMail.zimbra@efficios.com> <CAKOZuetW5NEvbROjuquQ_AxrW7BqR5Qfp6BYfy+zUrnPkZDaTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetW5NEvbROjuquQ_AxrW7BqR5Qfp6BYfy+zUrnPkZDaTw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On May 3, 2018, at 12:22 PM, Daniel Colascione dancol@google.com wrote:

> On Thu, May 3, 2018 at 9:12 AM Mathieu Desnoyers <
> mathieu.desnoyers@efficios.com> wrote:
>> By the way, if we eventually find a way to enhance user-space mutexes in
> the
>> fashion you describe here, it would belong to another TLS area, and would
>> be registered by another system call than rseq. I proposed a more generic
>> "TLS area registration" system call a few years ago, but Linus told me he
>> wanted a system call that was specific to rseq. If we need to implement
>> other use-cases in a TLS area shared between kernel and user-space in a
>> similar fashion, the plan is to do it in a distinct system call.
> 
> If we proliferate TLS areas; we'd have to register each one upon thread
> creation, adding to the overall thread creation path. There's already a
> provision for versioning the TLS area. What's the benefit of splitting the
> registration over multiple system calls?

See the original discussion thread at

https://lkml.org/lkml/2016/4/7/502

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
