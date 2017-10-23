From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Mon, 23 Oct 2017 20:44:01 +0000 (UTC)
Message-ID: <439398759.47028.1508791441765.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <CY4PR15MB1688286D6B1283A1C234BAE6CF4E0@CY4PR15MB1688.namprd15.prod.outlook.com> <515879378.43966.1508350299712.JavaMail.zimbra@efficios.com> <CY4PR15MB16888F91F41A4A1D322C102CCF460@CY4PR15MB1688.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR15MB16888F91F41A4A1D322C102CCF460-ZVJ2su15u+xeX4ZvlgGe+Yd3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Michael
List-Id: linux-api@vger.kernel.org

----- On Oct 23, 2017, at 7:30 PM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote:

>> if (!((long)ip - (long)start_ip <= (long)post_commit_offset))
>>   return 1;
> 
>> This introduces an issue here: if "ip" is lower than "start_ip", we
>> can incorrectly think we are in a critical section, when we are in
>> fact not.
> 
> This shouldn't be an issue if we used unsigned numbers. Eg if start_ip is X and
> post_commit_offset is L, then (ip - X <= L) means that if ip is less than X ip
> - X will be signed, which will become a large unsigned value.
> 
>> or to the kernel to set it back to NULL if it finds out that it is
>> preempting/delivering a signal over an instruction pointer outside
>> of the current rseq_cs start_ip/post_commit_ip range (lazy clear).
> 
> I see, lazy clear makes sense. Still, if during most execution periods the user
> code enters some rseq section (likely if rseq is used for something like
> malloc) on every context switch this code will have to be run.
> 
>> Moreover, this modification would add a subtraction on the common case
>> (ip - start_ip), and makes the ABI slightly uglier.
> 
> We could benchmark it but the subtraction should be similar in cost to the extra
> comparison but reducing the number of branches seems like it will help as well.
> FWIW GCC attempts to translate this kind of sequence to a subtract and compare:
> https://godbolt.org/g/5DGLvo.
> 
> I agree the ABI is uglier, but since we're mucking with every context switch I
> thought I'd point it out.

Thanks for following up on this. I did not initially realize the importance
of doing the unsigned comparison. I've pushed a commit in my private dev branch
implementing your suggestion.

https://github.com/compudj/linux-percpu-dev/commit/4cf8e9104636b51741c0118f2c88519e3acab7aa

Thanks!

Mathieu

> 
>> If I understand well, you are proposing to speed up .so load time by
>> means of removing relocations of pointers within rseq_cs, done by
>> making those relative to the rseq_cs address.
> 
> Yeah, I think this may be overkill as optimization.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
