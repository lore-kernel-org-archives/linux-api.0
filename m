From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 2/4] x86/syscalls: Specific usage of
 verify_pre_usermode_state
Date: Tue, 4 Apr 2017 11:27:07 -0700
Message-ID: <05d9c4a7-8acb-5997-1dd6-d534398e6f54@zytor.com>
References: <20170404174727.35478-1-thgarnie@google.com>
 <20170404174727.35478-2-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170404174727.35478-2-thgarnie@google.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>
Cc: linux-s390@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

On 04/04/17 10:47, Thomas Garnier wrote:
> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 516593e66bd6..12fa851c7fa8 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -78,4 +78,15 @@ typedef struct { pteval_t pte; } pte_t;
>  
>  #define EARLY_DYNAMIC_PAGE_TABLES	64
>  
> +/*
> + * User space process size. 47bits minus one guard page.  The guard
> + * page is necessary on Intel CPUs: if a SYSCALL instruction is at
> + * the highest possible canonical userspace address, then that
> + * syscall will enter the kernel with a non-canonical return
> + * address, and SYSRET will explode dangerously.  We avoid this
> + * particular problem by preventing anything from being mapped
> + * at the maximum canonical address.
> + */
> +#define TASK_SIZE_MAX	((_AC(1, UL) << 47) - PAGE_SIZE)
> +
>  #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 3cada998a402..e80822582d3e 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -825,17 +825,6 @@ static inline void spin_lock_prefetch(const void *x)
>  #define KSTK_ESP(task)		(task_pt_regs(task)->sp)
>  
>  #else
> -/*
> - * User space process size. 47bits minus one guard page.  The guard
> - * page is necessary on Intel CPUs: if a SYSCALL instruction is at
> - * the highest possible canonical userspace address, then that
> - * syscall will enter the kernel with a non-canonical return
> - * address, and SYSRET will explode dangerously.  We avoid this
> - * particular problem by preventing anything from being mapped
> - * at the maximum canonical address.
> - */
> -#define TASK_SIZE_MAX	((1UL << 47) - PAGE_SIZE)
> -
>  /* This decides where the kernel will search for a free chunk of vm
>   * space during mmap's.
>   */
> 

This should be an entirely separate patch; if nothing else you need to
explain it in the comments.

Also, you say this is for "x86", but I still don't see any code for i386
whatsoever.  Have you verified *all* the i386 and i386-compat paths to
make sure they go via prepare_exit_to_usermode()?  [Cc: Andy]

Finally, I can't really believe I'm the only person for whom "Specific
usage of verity_pre_usermode_state" is completely opaque.

	-hpa
