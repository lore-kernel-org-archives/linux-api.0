From: Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 16/22] rseq: selftests: arm: workaround gcc
 asm size guess
Date: Tue, 21 Nov 2017 08:39:00 -0700
Message-ID: <a5d7e50e-bce8-449e-8a2e-9a73c7d8b54b@kernel.org>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com>
 <20171121141900.18471-17-mathieu.desnoyers@efficios.com>
Reply-To: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121141900.18471-17-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/21/2017 07:18 AM, Mathieu Desnoyers wrote:
> Fixes assembler errors:
> /tmp/cceKwI9a.s: Assembler messages:
> /tmp/cceKwI9a.s:849: Error: co-processor offset out of range
> 
> with gcc prior to gcc-7. This can trigger if multiple rseq inline asm
> are used within the same function.
> 
> My best guess on the cause of this issue is that gcc has a hard
> time figuring out the actual size of the inline asm, and therefore
> does not compute the offsets at which literal values can be
> placed from the program counter accurately.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
> CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
> CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  tools/testing/selftests/rseq/rseq-arm.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/tools/testing/selftests/rseq/rseq-arm.h b/tools/testing/selftests/rseq/rseq-arm.h
> index 47953c0cef4f..6d3fda276f4d 100644
> --- a/tools/testing/selftests/rseq/rseq-arm.h
> +++ b/tools/testing/selftests/rseq/rseq-arm.h
> @@ -79,12 +79,15 @@ do {									\
>  		teardown						\
>  		"b %l[" __rseq_str(cmpfail_label) "]\n\t"
>  
> +#define rseq_workaround_gcc_asm_size_guess()	__asm__ __volatile__("")
> +
>  static inline __attribute__((always_inline))
>  int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
>  		int cpu)
>  {
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
> @@ -115,11 +118,14 @@ int rseq_cmpeqv_storev(intptr_t *v, intptr_t expect, intptr_t newv,
>  		  RSEQ_INJECT_CLOBBER
>  		: abort, cmpfail
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  cmpfail:
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 1;
>  }
>  
> @@ -129,6 +135,7 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
>  {
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
> @@ -164,11 +171,14 @@ int rseq_cmpnev_storeoffp_load(intptr_t *v, intptr_t expectnot,
>  		  RSEQ_INJECT_CLOBBER
>  		: abort, cmpfail
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  cmpfail:
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 1;
>  }
>  
> @@ -177,6 +187,7 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
>  {
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
> @@ -203,8 +214,10 @@ int rseq_addv(intptr_t *v, intptr_t count, int cpu)
>  		  RSEQ_INJECT_CLOBBER
>  		: abort
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  }
> @@ -216,6 +229,7 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
>  {
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
> @@ -253,11 +267,14 @@ int rseq_cmpeqv_trystorev_storev(intptr_t *v, intptr_t expect,
>  		  RSEQ_INJECT_CLOBBER
>  		: abort, cmpfail
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  cmpfail:
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 1;
>  }
>  
> @@ -268,6 +285,7 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
>  {
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
> @@ -306,11 +324,14 @@ int rseq_cmpeqv_trystorev_storev_release(intptr_t *v, intptr_t expect,
>  		  RSEQ_INJECT_CLOBBER
>  		: abort, cmpfail
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  cmpfail:
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 1;
>  }
>  
> @@ -321,6 +342,7 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
>  {
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		RSEQ_ASM_STORE_RSEQ_CS(1, 3f, rseq_cs)
> @@ -359,11 +381,14 @@ int rseq_cmpeqv_cmpeqv_storev(intptr_t *v, intptr_t expect,
>  		  RSEQ_INJECT_CLOBBER
>  		: abort, cmpfail
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  cmpfail:
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 1;
>  }
>  
> @@ -376,6 +401,7 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
>  
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		"str %[src], %[rseq_scratch0]\n\t"
> @@ -442,11 +468,14 @@ int rseq_cmpeqv_trymemcpy_storev(intptr_t *v, intptr_t expect,
>  		  RSEQ_INJECT_CLOBBER
>  		: abort, cmpfail
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  cmpfail:
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 1;
>  }
>  
> @@ -459,6 +488,7 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
>  
>  	RSEQ_INJECT_C(9)
>  
> +	rseq_workaround_gcc_asm_size_guess();
>  	__asm__ __volatile__ goto (
>  		RSEQ_ASM_DEFINE_TABLE(__rseq_table, 0x0, 0x0, 1f, 2f-1f, 4f)
>  		"str %[src], %[rseq_scratch0]\n\t"
> @@ -526,10 +556,13 @@ int rseq_cmpeqv_trymemcpy_storev_release(intptr_t *v, intptr_t expect,
>  		  RSEQ_INJECT_CLOBBER
>  		: abort, cmpfail
>  	);
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 0;
>  abort:
> +	rseq_workaround_gcc_asm_size_guess();
>  	RSEQ_INJECT_FAILED
>  	return -1;
>  cmpfail:
> +	rseq_workaround_gcc_asm_size_guess();
>  	return 1;
>  }
> 

Looks fine to me. For this patch.

Acked-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

I have comments on other patches in this series.

thanks,
-- Shuah
