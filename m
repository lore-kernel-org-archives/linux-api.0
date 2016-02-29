From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Mon, 29 Feb 2016 11:32:21 +0100
Message-ID: <20160229103221.GI6356@twins.programming.kicks-ass.net>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1082926946.10326.1456619994590.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Feb 28, 2016 at 12:39:54AM +0000, Mathieu Desnoyers wrote:

> /* This structure needs to be aligned cache line size. */
> struct thread_local_abi {
>   int32_t  cpu_id;
>   uint32_t rseq_seqnum;
>   uint64_t rseq_post_commit_ip;
>   /* Add new fields at the end. */ 
> } __attribute__((packed));

I would really not use packed; that can lead to horrible layout.

Suppose someone would add:

	uint32_t foo;
	uint64_t bar;

With packed, you get an unaligned uint64_t in there, which is horrible.
Without packed, you get a hole, which you can later fill.

> /* Thread local ABI system calls. */ 
> 
> int thread_local_abi_len(size_t *features_mask_len, size_t *tlabi_len); 

See below; maybe we can fudge the register call to return the size when
called 'right', maybe that'll end up too ugly, dunno. But I don't think
we need the feature mask bits.

Maybe: TLA_FLAG_GETSIZE ?

> int thread_local_abi_features(uint8_t *mask); 

Not sure you need this; see below. Either you know about a
TLA_ENABLE_feat flag and you can attempt enabling it (failing if the
kernel doesn't support it), or you don't, in which case you won't
attempt use.

> int thread_local_abi_register(struct thread_local_abi *tlabi); 

This has the problem that the moment you register for this, we must have
all features enabled. And esp. the rseq stuff has non-trivial overhead.

I would much rather have something where we only enable the features
actually used by the program at hand.


Also, every syscall should have a flags argument, so maybe we can do
something like:

	#define TLA_ENABLE_CPU		0x01
	#define TLA_ENABLE_RSEQ		0x03 /* RSEQ must imply CPU */

	int thread_local_abi_register(struct tla *tla, unsigned int enable, unsigned int flags);

Where (g)libc would unconditionally set up the structure with
.enabled=0, .flags=0, and anybody actually wanting to make use of the
thing do:

	thread_local_abi_register(NULL, TLA_ENABLE_CPU, 0);

Obviously calling register with !NULL address twice will error (you
already registered), calling with NULL before !NULL will also error.


And if you really worry about running out of feature bits, we could of
course pass it in a mask, but I'm not sure I can see 30 other features
we would want to cram into this (yes, yes, famous last words etc.. 640kb
anyone?).
