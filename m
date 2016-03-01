From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Tue, 1 Mar 2016 10:25:44 -0800
Message-ID: <56D5DEA8.3040908@zytor.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1150363257.9781.1456533630895.JavaMail.zimbra@efficios.com>
 <56D14132.5050100@zytor.com>
 <2053850250.10158.1456582501604.JavaMail.zimbra@efficios.com>
 <20160227145809.GD6356@twins.programming.kicks-ass.net>
 <CA+55aFysWipEagSdgeXbLx+Au4vomvyttdNFJtM+HffmBECQiA@mail.gmail.com>
 <1401667361.10273.1456617236327.JavaMail.zimbra@efficios.com>
 <CA+55aFwcgwRxvVBz5kk_3O8dESXAGJ4KHBkf=pSXjiS7Xh4NwA@mail.gmail.com>
 <1082926946.10326.1456619994590.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1082926946.10326.1456619994590.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/27/16 16:39, Mathieu Desnoyers wrote:
> 
> Very good points! Would the following interfaces be acceptable ?
> 
> /* This structure needs to be aligned cache line size. */
> struct thread_local_abi {
>         int32_t cpu_id;                               /* Aligned on
> 32-bit. */
>         uint32_t rseq_seqnum;                 /* Aligned on 32-bit. */
>         uint64_t rseq_post_commit_ip;   /* Aligned on 64-bit. */
>         /* Add new fields at the end. */
> } __attribute__((packed));
> 

First of all, DO NOT use __attribute__((packed)).  First of all, it
buggers up the alignment of the *entire structure* (the alignment of a
packed structure defaults to 1, and gcc will assume the whole structure
is misaligned, generating unaligned access instructions on architectures
which need them.)

Sadly gcc doesn't currently have an __attribute__ to express "error out
on padding" which is what you actually want here.

You may, however, want to add an explicit alignment attribute to make
sure it is cache line aligned.

Second, as far as the 32/64 bit issue is concerned, you have to order
the fields so you always access the LSB.  This is probably the best way
to do it:

#ifdef __LP64__
# define __FIELD_32_64(field,n)	uint64_t field;
#elif __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
# define __FIELD_32_64(field,n) uint32_t field, _unused ## n;
#else
# define __FIELD_32_64(field,n) uint32_t _unused ## n, field;
#endif

All these macros are intrinsic to gcc (and hopefully to gcc-compatible
compilers) so there are no header file dependencies.

	-hpa
