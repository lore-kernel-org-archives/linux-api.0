From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 3/5] rseq: uapi: declare rseq_cs field as
 union, update includes
Date: Fri, 6 Jul 2018 15:38:51 -0400 (EDT)
Message-ID: <131696830.1369.1530905931822.JavaMail.zimbra@efficios.com>
References: <20180705180601.18423-1-mathieu.desnoyers@efficios.com> <20180705180601.18423-4-mathieu.desnoyers@efficios.com> <1846432971.1245.1530892973439.JavaMail.zimbra@efficios.com> <436937568.1359.1530905019620.JavaMail.zimbra@efficios.com> <CA+55aFzz1CC6son0T2nD-Yqhy0_yC5nBer2XSH9kqe5x3N26Ug@mail.gmail.com> <1913049637.1366.1530905741745.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1913049637.1366.1530905741745.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 6, 2018, at 3:35 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Jul 6, 2018, at 3:31 PM, Linus Torvalds torvalds@linux-foundation.org
> wrote:
> 
>> On Fri, Jul 6, 2018 at 12:23 PM Mathieu Desnoyers
>> <mathieu.desnoyers@efficios.com> wrote:
>>>
>>> For -rc, I would favor the following simpler approach. Or I could even
>>> just use get_user() instead. Thoughts ?
>> 
>> Please just use "get_user()".
>> 
>> In fact, we should be thinking seriosly about just removing
>> __get_user() entirely. It's wrong. It optimizes the wrong thing
>> entirely. It _used_ to be that the range check was noticeable, and it
>> really isn't any more. These days the expensive parts are the SMAP
>> costs, and both get_user() and __get_user() have those, except
>> get_user() is safer and doesn't waste I$ on inlining the code to
>> disable and re-enable SMAP.
> 
> Will do, thanks!

Should I change all 4 bytes __get_user()/__put_user() in kernel/rseq.c
for get_user()/put_user() to ensure consistency ?

Thanks,

Mathieu

> 
> Mathieu
> 
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
