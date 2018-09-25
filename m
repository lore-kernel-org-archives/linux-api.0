From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rseq/selftests: fix parametrized test with -fpie
Date: Tue, 25 Sep 2018 13:39:36 -0400 (EDT)
Message-ID: <1367962117.10271.1537897176578.JavaMail.zimbra@efficios.com>
References: <20180918135328.32034-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180918135328.32034-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuahkh@osg.samsung.com>, linux-kselftest <linux-kselftest@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Sep 18, 2018, at 9:53 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> On x86-64, the parametrized selftest code for rseq crashes with a
> segmentation fault when compiled with -fpie. This happens when the
> param_test binary is loaded at an address beyond 32-bit on x86-64.
> 
> The issue is caused by use of a 32-bit register to hold the address
> of the loop counter variable.
> 
> Fix this by using a 64-bit register to calculate the address of the
> loop counter variables as an offset from rip.

Should this fix go through tip or the selftests tree ?

Thanks,

Mathieu

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: <stable@vger.kernel.org> # v4.18
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Joel Fernandes <joelaf@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Dave Watson <davejwatson@fb.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: linux-kselftest@vger.kernel.org
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Chris Lameter <cl@linux.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Maurer <bmaurer@fb.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> tools/testing/selftests/rseq/param_test.c | 19 ++++++++++---------
> 1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/rseq/param_test.c
> b/tools/testing/selftests/rseq/param_test.c
> index 615252331813..4bc071525bf7 100644
> --- a/tools/testing/selftests/rseq/param_test.c
> +++ b/tools/testing/selftests/rseq/param_test.c
> @@ -56,15 +56,13 @@ unsigned int yield_mod_cnt, nr_abort;
> 			printf(fmt, ## __VA_ARGS__);	\
> 	} while (0)
> 
> -#if defined(__x86_64__) || defined(__i386__)
> +#ifdef __i386__
> 
> #define INJECT_ASM_REG	"eax"
> 
> #define RSEQ_INJECT_CLOBBER \
> 	, INJECT_ASM_REG
> 
> -#ifdef __i386__
> -
> #define RSEQ_INJECT_ASM(n) \
> 	"mov asm_loop_cnt_" #n ", %%" INJECT_ASM_REG "\n\t" \
> 	"test %%" INJECT_ASM_REG ",%%" INJECT_ASM_REG "\n\t" \
> @@ -76,9 +74,16 @@ unsigned int yield_mod_cnt, nr_abort;
> 
> #elif defined(__x86_64__)
> 
> +#define INJECT_ASM_REG_P	"rax"
> +#define INJECT_ASM_REG		"eax"
> +
> +#define RSEQ_INJECT_CLOBBER \
> +	, INJECT_ASM_REG_P \
> +	, INJECT_ASM_REG
> +
> #define RSEQ_INJECT_ASM(n) \
> -	"lea asm_loop_cnt_" #n "(%%rip), %%" INJECT_ASM_REG "\n\t" \
> -	"mov (%%" INJECT_ASM_REG "), %%" INJECT_ASM_REG "\n\t" \
> +	"lea asm_loop_cnt_" #n "(%%rip), %%" INJECT_ASM_REG_P "\n\t" \
> +	"mov (%%" INJECT_ASM_REG_P "), %%" INJECT_ASM_REG "\n\t" \
> 	"test %%" INJECT_ASM_REG ",%%" INJECT_ASM_REG "\n\t" \
> 	"jz 333f\n\t" \
> 	"222:\n\t" \
> @@ -86,10 +91,6 @@ unsigned int yield_mod_cnt, nr_abort;
> 	"jnz 222b\n\t" \
> 	"333:\n\t"
> 
> -#else
> -#error "Unsupported architecture"
> -#endif
> -
> #elif defined(__ARMEL__)
> 
> #define RSEQ_INJECT_INPUT \
> --
> 2.11.0

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
