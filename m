From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 09/14] Provide cpu_opv system call
Date: Sat, 14 Oct 2017 13:35:28 +0000 (UTC)
Message-ID: <1866208529.41181.1507988128067.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-10-mathieu.desnoyers@efficios.com> <20171014025029.GL2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171014025029.GL2482-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Michael
List-Id: linux-api@vger.kernel.org

----- On Oct 13, 2017, at 10:50 PM, Andi Kleen andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org wrote:

>> +	pagefault_disable();
>> +	switch (len) {
>> +	case 1:
>> +		if (__get_user(tmp._u8, (uint8_t __user *)p))
>> +			goto end;
>> +		tmp._u8 += (uint8_t)count;
>> +		if (__put_user(tmp._u8, (uint8_t __user *)p))
>> +			goto end;
>> +		break;
> 
> It seems the code size could be dramatically shrunk by using a function
> pointer callback for the actual operation, and then avoiding all the
> copies. Since this is only a fallback this shouldn't be a problem
> (and modern branch predictors are fairly good in such situations anyways)
> 
> If you really want to keep the code it would be better if you used
> some macros -- i bet there's a typo in here somewhere in this
> forest.

Good point!

I'll add this in the next round. Meanwhile, here is the resulting
commit: https://github.com/compudj/linux-percpu-dev/commit/864b444f64f4c227ddc587d12631ff0d3440796c

Thanks,

Mathieu


> 
> -Andi

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
