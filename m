From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for 4.16 v7 02/11] powerpc: membarrier: Skip memory
 barrier in switch_mm()
Date: Mon, 5 Feb 2018 20:32:08 +0000 (UTC)
Message-ID: <1407075321.16343.1517862728006.JavaMail.zimbra@efficios.com>
References: <20180129202020.8515-1-mathieu.desnoyers@efficios.com> <20180129202020.8515-3-mathieu.desnoyers@efficios.com> <20180205202242.6ilyjh35byycf3ez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205202242.6ilyjh35byycf3ez-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

----- On Feb 5, 2018, at 3:22 PM, Ingo Molnar mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:

> * Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> 
>>  
>> +config ARCH_HAS_MEMBARRIER_HOOKS
>> +	bool
> 
> Yeah, so I have renamed this to ARCH_HAS_MEMBARRIER_CALLBACKS, and propagated it
> through the rest of the patches. "Callback" is the canonical name, and I also
> cringe every time I see 'hook'.
> 
> Please let me know if there are any big objections against this minor cleanup.

No objection at all,

Thanks!

Mathieu

> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
