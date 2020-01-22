From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v1] pin_on_cpu: Introduce thread CPU pinning system
 call
Date: Wed, 22 Jan 2020 12:16:32 -0500 (EST)
Message-ID: <1813399266.597377.1579713392568.JavaMail.zimbra@efficios.com>
References: <CAODFU0rTLmb-Ph_n1EHaZmdOAjsa6Jmx=3zkuT8LH3No=sOk5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAODFU0rTLmb-Ph_n1EHaZmdOAjsa6Jmx=3zkuT8LH3No=sOk5w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Ziak <0xe2.0x9a.0x9b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Joel Fernandes <joelaf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kselftest <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

(replying again as plain text for mailing lists)

----- On Jan 22, 2020, at 10:44 AM, Jan Ziak 0xe2.0x9a.0x9b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> Hello

> I would like to note that this does not help userspace to express dynamic
> scheduling relationships among processes/threads such as "do not run processes
> A and B on the same core" or "run processes A and B on cores sharing the same
> L2 cache".

Indeed, this is not what this system call is trying to solve. Does the name "pin_on_cpu" lead 
to confusion here ? 

I thought that cgroups was already the mechanism taking care of this kind of requirement. 

Thanks, 

Mathieu 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
