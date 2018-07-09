From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 4.18 2/6] rseq: use get_user/put_user rather than
 __get_user/__put_user
Date: Mon, 9 Jul 2018 14:19:19 -0400 (EDT)
Message-ID: <1519037424.2393.1531160359475.JavaMail.zimbra@efficios.com>
References: <20180708210330.27324-1-mathieu.desnoyers@efficios.com> <20180708210330.27324-3-mathieu.desnoyers@efficios.com> <854203778.2272.1531157327328.JavaMail.zimbra@efficios.com> <CA+55aFzpjA3r9HdfCU5LrEhSt6S=+RfKuJ2GVc8Wv5Hz-_Me8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzpjA3r9HdfCU5LrEhSt6S=+RfKuJ2GVc8Wv5Hz-_Me8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 9, 2018, at 2:04 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Jul 9, 2018 at 10:28 AM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> So, another twist to this story: ppc32 does not implement u64 get_user().
> 
> I was going to say that "that's not possible", since we actually have
> 64-bit arguments at least in the form of "loff_t __user *".
> 
> But when I started looking, it turns out that yeah, we do
> "copy_from_user()" on them, and instead made the x86 copy_from_user()
> have special cases for constant sizes.
> 
> So a 8-byte copy_from_user() is fine. It ends up being a "get_user()"
> on x86 anyway.

Given that this memory area has already been checked with access_ok()
on rseq registration, are you fine with leaving
__get_user/__put_user/__copy_{from,to}_user in place so we do the
minimal change at this stage of rc, or should I go ahead and replace
the lot with get_user/put_user/copy_{from,to}_user ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
