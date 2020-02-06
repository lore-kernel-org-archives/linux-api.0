From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH v9 01/27] Documentation/x86: Add CET description
Date: Wed, 5 Feb 2020 16:16:05 -0800
Message-ID: <af5ee976-3b57-4afe-6304-fcab8de45c77@infradead.org>
References: <20200205181935.3712-1-yu-cheng.yu@intel.com>
 <20200205181935.3712-2-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200205181935.3712-2-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

Hi,

I have a few comments and a question (please see inline below).


On 2/5/20 10:19 AM, Yu-cheng Yu wrote:
> Explain no_cet_shstk/no_cet_ibt kernel parameters, and introduce a new
> document on Control-flow Enforcement Technology (CET).
> 
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |   6 +
>  Documentation/x86/index.rst                   |   1 +
>  Documentation/x86/intel_cet.rst               | 294 ++++++++++++++++++
>  3 files changed, 301 insertions(+)
>  create mode 100644 Documentation/x86/intel_cet.rst
> 

> diff --git a/Documentation/x86/intel_cet.rst b/Documentation/x86/intel_cet.rst
> new file mode 100644
> index 000000000000..71e2462fea5c
> --- /dev/null
> +++ b/Documentation/x86/intel_cet.rst
> @@ -0,0 +1,294 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================================
> +Control-flow Enforcement Technology (CET)
> +=========================================
> +

...

> +
> +[5] CET system calls
> +====================
> +
> +The following arch_prctl() system calls are added for CET:
> +
> +arch_prctl(ARCH_X86_CET_STATUS, unsigned long *addr)
> +    Return CET feature status.
> +
> +    The parameter 'addr' is a pointer to a user buffer.
> +    On returning to the caller, the kernel fills the following
> +    information::
> +
> +        *addr       = SHSTK/IBT status
> +        *(addr + 1) = SHSTK base address
> +        *(addr + 2) = SHSTK size
> +
> +arch_prctl(ARCH_X86_CET_DISABLE, unsigned long features)
> +    Disable SHSTK and/or IBT specified in 'features'.  Return -EPERM
> +    if CET is locked.
> +
> +arch_prctl(ARCH_X86_CET_LOCK)
> +    Lock in CET feature.

which feature?

> +
> +arch_prctl(ARCH_X86_CET_ALLOC_SHSTK, unsigned long *addr)
> +    Allocate a new SHSTK and put a restore token at top.
> +
> +    The parameter 'addr' is a pointer to a user buffer and indicates
> +    the desired SHSTK size to allocate.  On returning to the caller,
> +    the kernel fills '*addr' with the base address of the new SHSTK.
> +
> +arch_prctl(ARCH_X86_CET_MARK_LEGACY_CODE, unsigned long *addr)
> +    Mark an address range as IBT legacy code.
> +
> +    The parameter 'addr' is a pointer to a user buffer that has the
> +    following information::
> +
> +        *addr       = starting linear address of the legacy code
> +        *(addr + 1) = size of the legacy code
> +        *(addr + 2) = set (1); clear (0)
> +
> +Note:
> +  There is no CET-enabling arch_prctl function.  By design, CET is
> +  enabled automatically if the binary and the system can support it.
> +
> +  The parameters passed are always unsigned 64-bit.  When an IA32
> +  application passing pointers, it should only use the lower 32 bits.
> +
> +[6] The implementation of the SHSTK
> +===================================
> +
> +SHSTK size
> +----------
> +
> +A task's SHSTK is allocated from memory to a fixed size of
> +RLIMIT_STACK.  A compat-mode thread's SHSTK size is 1/4 of
> +RLIMIT_STACK.  The smaller 32-bit thread SHSTK allows more threads to
> +share a 32-bit address space.
> +
> +Signal
> +------
> +
> +The main program and its signal handlers use the same SHSTK.  Because
> +the SHSTK stores only return addresses, a large SHSTK will cover the
> +condition that both the program stack and the sigaltstack run out.
> +
> +The kernel creates a restore token at the SHSTK restoring address and
> +verifies that token when restoring from the signal handler.
> +
> +IBT for signal delivering and sigreturn is the same as the main
> +program's setup; except for WAIT_ENDBR status, which can be read from

s/;/,/

> +MSR_IA32_U_CET.  In general, a task is in WAIT_ENDBR after an
> +indirect CALL/JMP and before the next instruction starts.
> +
> +A task's WAIT_ENDBR is reset for its signal handler, but preserved on
> +the task's stack; and then restored from sigreturn.

s/;/,/

> +
> +Fork
> +----
> +
> +The SHSTK's vma has VM_SHSTK flag set; its PTEs are required to be
> +read-only and dirty.  When a SHSTK PTE is not present, RO, and dirty,
> +a SHSTK access triggers a page fault with an additional SHSTK bit set
> +in the page fault error code.
> +
> +When a task forks a child, its SHSTK PTEs are copied and both the
> +parent's and the child's SHSTK PTEs are cleared of the dirty bit.
> +Upon the next SHSTK access, the resulting SHSTK page fault is handled
> +by page copy/re-use.
> +
> +When a pthread child is created, the kernel allocates a new SHSTK for
> +the new thread.
> +
> +Setjmp/Longjmp
> +--------------
> +
> +Longjmp unwinds SHSTK until it matches the program stack.
> +
> +Ucontext
> +--------
> +
> +In GLIBC, getcontext/setcontext is implemented in similar way as
> +setjmp/longjmp.
> +
> +When makecontext creates a new ucontext, a new SHSTK is allocated for
> +that context with ARCH_X86_CET_ALLOC_SHSTK syscall.  The kernel
> +creates a restore token at the top of the new SHSTK and the user-mode
> +code switches to the new SHSTK with the RSTORSSP instruction.
> +
> +[7] The management of read-only & dirty PTEs for SHSTK
> +======================================================
> +
> +A RO and dirty PTE exists in the following cases:
> +
> +(a) A page is modified and then shared with a fork()'ed child;
> +(b) A R/O page that has been COW'ed;
> +(c) A SHSTK page.
> +
> +The processor only checks the dirty bit for (c).  To prevent the use
> +of non-SHSTK memory as SHSTK, we use a spare bit of the 64-bit PTE as
> +DIRTY_SW for (a) and (b) above.  This results to the following PTE
> +settings::
> +
> +    Modified PTE:             (R/W + DIRTY_HW)
> +    Modified and shared PTE:  (R/O + DIRTY_SW)
> +    R/O PTE, COW'ed:          (R/O + DIRTY_SW)
> +    SHSTK PTE:                (R/O + DIRTY_HW)
> +    SHSTK PTE, COW'ed:        (R/O + DIRTY_HW)
> +    SHSTK PTE, shared:        (R/O + DIRTY_SW)
> +
> +Note that DIRTY_SW is only used in R/O PTEs but not R/W PTEs.
> +
> +[8] The implementation of IBT legacy bitmap
> +===========================================
> +
> +When IBT is active, a non-IBT-capable legacy library can be executed
> +if its address ranges are specified in the legacy code bitmap.  The
> +bitmap covers the whole user-space address, which is TASK_SIZE_MAX
> +for 64-bit and TASK_SIZE for IA32, and its each bit indicates a 4-KB

confusing:
                                          its each bit

> +legacy code page.  It is read-only from an application, and setup by
> +the kernel as a special mapping when the first time the application

                           drop:   when

> +calls arch_prctl(ARCH_X86_CET_MARK_LEGACY_CODE).  The application
> +manages the bitmap through the arch_prctl.

                      through the arch_prctl() interface.


cheers.
-- 
~Randy
