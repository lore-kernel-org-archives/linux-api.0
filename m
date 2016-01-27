From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] getcpu_cache system call: cache CPU number
 of running thread
Date: Wed, 27 Jan 2016 22:47:37 +0000 (UTC)
Message-ID: <75735238.6347.1453934857246.JavaMail.zimbra@efficios.com>
References: <1453913683-28915-1-git-send-email-mathieu.desnoyers@efficios.com> <1453913683-28915-2-git-send-email-mathieu.desnoyers@efficios.com> <alpine.DEB.2.11.1601271813290.3886@nanos> <671969438.6129.1453915918933.JavaMail.zimbra@efficios.com> <alpine.DEB.2.11.1601271832330.3886@nanos> <alpine.DEB.2.11.1601271836510.3886@nanos> <974364259.6329.1453930475174.JavaMail.zimbra@efficios.com> <20160127221142.GA8935@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160127221142.GA8935@cloud>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 27, 2016, at 5:11 PM, Josh Triplett josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:

> On Wed, Jan 27, 2016 at 09:34:35PM +0000, Mathieu Desnoyers wrote:
>> ----- On Jan 27, 2016, at 12:37 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
>> 
>> > On Wed, 27 Jan 2016, Thomas Gleixner wrote:
>> > 
>> >> On Wed, 27 Jan 2016, Mathieu Desnoyers wrote:
>> >> > ----- On Jan 27, 2016, at 12:22 PM, Thomas Gleixner tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org wrote:
>> >> > Sounds fair. What is the recommended typing for "ptr" then ?
>> >> > uint32_t ** or uint32_t * ?
>> >> > 
>> >> > It would be expected to pass a "uint32_t *" for the set
>> >> > operation, but the "get" operation requires a "uint32_t **".
>> >> 
>> >> Well, you can't change the types depending on the opcode, so you need to stick
>> >> with **.
>> > 
>> > Alternatively you make it:
>> > 
>> >  (opcode, *newptr, **oldptr, flags);
>> 
>> I'm tempted to stick to (opcode, **ptr, flags), because
>> other syscalls that have "*newptr", "**oldptr"
>> typically have them because they save the current state
>> into oldptr, and set the new state, which is really
>> not the case here. To eliminate any risk of confusion,
>> I am tempted to keep a single "**ptr".
>> 
>> Unless someone has a better idea...
> 
> Either that or you could define it as "void *" and interpret it based on
> flags, but that seems unfortunate; let's not imitate ioctl-style
> typeless parameters.  I'd stick with the double pointer and the current
> behavior.

Allright, will do! Thanks for the feedback :)

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
