From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Wed, 2 Mar 2016 11:44:46 +0100
Message-ID: <CAMuHMdVFFCjoEWbWxCQ3OVCyY0-tr9NGm15UYJ9+GP_OtWcWMg@mail.gmail.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1082926946.10326.1456619994590.JavaMail.zimbra@efficios.com>
	<20160229103221.GI6356@twins.programming.kicks-ass.net>
	<3364335.Bqf8sAzlTS@wuerfel>
	<1811549980.11849.1456749709589.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1811549980.11849.1456749709589.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 29, 2016 at 1:41 PM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> ----- On Feb 29, 2016, at 5:39 AM, Arnd Bergmann arnd-r2nGTMty4D4@public.gmane.org wrote:
>
>> On Monday 29 February 2016 11:32:21 Peter Zijlstra wrote:
>>> On Sun, Feb 28, 2016 at 12:39:54AM +0000, Mathieu Desnoyers wrote:
>>>
>>> > /* This structure needs to be aligned cache line size. */
>>> > struct thread_local_abi {
>>> >   int32_t  cpu_id;
>>> >   uint32_t rseq_seqnum;
>>> >   uint64_t rseq_post_commit_ip;
>>> >   /* Add new fields at the end. */
>>> > } __attribute__((packed));
>>>
>>> I would really not use packed; that can lead to horrible layout.
>>>
>>> Suppose someone would add:
>>>
>>>      uint32_t foo;
>>>      uint64_t bar;
>>>
>>> With packed, you get an unaligned uint64_t in there, which is horrible.
>>> Without packed, you get a hole, which you can later fill.
>>
>
> Actually, Peter is wrong about the hole there. On some 32-bit architectures,
> 64-bit integers are aligned on 32-bit, not 64-bit. So there may or may not

... or even on 16-bit.

> be a hole there, and that would lead to a mess.

indeed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
