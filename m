From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 09/14] Provide cpu_opv system call
Date: Sat, 14 Oct 2017 14:22:10 +0000 (UTC)
Message-ID: <112864193.41278.1507990930227.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-10-mathieu.desnoyers@efficios.com> <20171013145710.4430583f@alans-desktop> <854849583.40647.1507906233368.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <854849583.40647.1507906233368.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.>
List-Id: linux-api@vger.kernel.org

----- On Oct 13, 2017, at 10:50 AM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> ----- On Oct 13, 2017, at 9:57 AM, One Thousand Gnomes
> gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org wrote:
> 
>>> A maximum limit of 16 operations per cpu_opv syscall invocation is
>>> enforced, so user-space cannot generate a too long preempt-off critical
>>> section.
>> 
>> Except that all the operations could be going to mmapped I/O space and if
>> I pick the right targets could take quite a long time to complete.
> 
> We could check whether a struct page belongs to mmapped I/O space, and return
> EINVAL in that case.
> 
>> It's
>> still only 16 operations - But 160ms is a lot worse than 10ms. In fact
>> with compare_iter I could make it much much worse still as I get 2 x
>> TMP_BUFLEN x 16 x worst case latency in my attack. That's enough to screw
>> up plenty of things.
> 
> Would a check that ensures the page is not mmapped I/O space be sufficient
> to take care of this ? If happen to know which API I need to look for, it
> would be welcome.

I think is_zone_device_page() is what I was looking for.

Let me know if I missed something,

Thanks,

Mathieu

> Thanks,
> 
> Mathieu
> 
> 
>> 
>> Alan
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
