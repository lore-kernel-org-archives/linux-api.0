From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user mappings
Date: Mon, 28 Oct 2019 11:02:44 -0700
Message-ID: <CALCETrWW2AEhO0TY8Xr7Fe5u9c7WB7zg4d2TPp3G6b9X1pO8BA@mail.gmail.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org> <1572171452-7958-2-git-send-email-rppt@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1572171452-7958-2-git-send-email-rppt@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, James Bottomley <jejb@linux.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux API <linux-api@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, X86 ML <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 27, 2019 at 3:17 AM Mike Rapoport <rppt@kernel.org> wrote:
>
> From: Mike Rapoport <rppt@linux.ibm.com>
>
> The mappings created with MAP_EXCLUSIVE are visible only in the context of
> the owning process and can be used by applications to store secret
> information that will not be visible not only to other processes but to the
> kernel as well.
>
> The pages in these mappings are removed from the kernel direct map and
> marked with PG_user_exclusive flag. When the exclusive area is unmapped,
> the pages are mapped back into the direct map.
>
> The MAP_EXCLUSIVE flag implies MAP_POPULATE and MAP_LOCKED.
>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> ---
>  arch/x86/mm/fault.c                    | 14 ++++++++++
>  fs/proc/task_mmu.c                     |  1 +
>  include/linux/mm.h                     |  9 +++++++
>  include/linux/page-flags.h             |  7 +++++
>  include/linux/page_excl.h              | 49 ++++++++++++++++++++++++++++++++++
>  include/trace/events/mmflags.h         |  9 ++++++-
>  include/uapi/asm-generic/mman-common.h |  1 +
>  kernel/fork.c                          |  3 ++-
>  mm/Kconfig                             |  3 +++
>  mm/gup.c                               |  8 ++++++
>  mm/memory.c                            |  3 +++
>  mm/mmap.c                              | 16 +++++++++++
>  mm/page_alloc.c                        |  5 ++++
>  13 files changed, 126 insertions(+), 2 deletions(-)
>  create mode 100644 include/linux/page_excl.h
>
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9ceacd1..8f73a75 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -17,6 +17,7 @@
>  #include <linux/context_tracking.h>    /* exception_enter(), ...       */
>  #include <linux/uaccess.h>             /* faulthandler_disabled()      */
>  #include <linux/efi.h>                 /* efi_recover_from_page_fault()*/
> +#include <linux/page_excl.h>           /* page_is_user_exclusive()     */
>  #include <linux/mm_types.h>
>
>  #include <asm/cpufeature.h>            /* boot_cpu_has, ...            */
> @@ -1218,6 +1219,13 @@ static int fault_in_kernel_space(unsigned long address)
>         return address >= TASK_SIZE_MAX;
>  }
>
> +static bool fault_in_user_exclusive_page(unsigned long address)
> +{
> +       struct page *page = virt_to_page(address);
> +
> +       return page_is_user_exclusive(page);
> +}
> +
>  /*
>   * Called for all faults where 'address' is part of the kernel address
>   * space.  Might get called for faults that originate from *code* that
> @@ -1261,6 +1269,12 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
>         if (spurious_kernel_fault(hw_error_code, address))
>                 return;
>
> +       /* FIXME: warn and handle gracefully */
> +       if (unlikely(fault_in_user_exclusive_page(address))) {
> +               pr_err("page fault in user exclusive page at %lx", address);
> +               force_sig_fault(SIGSEGV, SEGV_MAPERR, (void __user *)address);
> +       }

Sending a signal here is not a reasonable thing to do in response to
an unexpected kernel fault.  You need to OOPS.  Printing a nice
message would be nice.

--Andy
