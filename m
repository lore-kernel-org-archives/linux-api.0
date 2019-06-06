From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v7 12/14] x86/vsyscall/64: Fixup shadow stack and branch
 tracking for vsyscall
Date: Thu, 6 Jun 2019 13:27:43 -0700
Message-ID: <CALCETrXfBCFKB2SwhEngABPCkAfgmb+YkRL3Xx3-=haN9H+V_g@mail.gmail.com>
References: <20190606200926.4029-1-yu-cheng.yu@intel.com> <20190606200926.4029-13-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200926.4029-13-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@or>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 6, 2019 at 1:17 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>
> When emulating a RET, also unwind the task's shadow stack and cancel
> the current branch tracking status.
>
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> ---
>  arch/x86/entry/vsyscall/vsyscall_64.c | 28 +++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
> index d9d81ad7a400..6869ef9d1e8b 100644
> --- a/arch/x86/entry/vsyscall/vsyscall_64.c
> +++ b/arch/x86/entry/vsyscall/vsyscall_64.c
> @@ -38,6 +38,8 @@
>  #include <asm/fixmap.h>
>  #include <asm/traps.h>
>  #include <asm/paravirt.h>
> +#include <asm/fpu/xstate.h>
> +#include <asm/fpu/types.h>
>
>  #define CREATE_TRACE_POINTS
>  #include "vsyscall_trace.h"
> @@ -92,6 +94,30 @@ static int addr_to_vsyscall_nr(unsigned long addr)
>         return nr;
>  }
>
> +void fixup_shstk(void)
> +{
> +#ifdef CONFIG_X86_INTEL_SHADOW_STACK_USER
> +       u64 r;
> +
> +       if (current->thread.cet.shstk_enabled) {
> +               rdmsrl(MSR_IA32_PL3_SSP, r);
> +               wrmsrl(MSR_IA32_PL3_SSP, r + 8);
> +       }
> +#endif
> +}
> +
> +void fixup_ibt(void)
> +{
> +#ifdef CONFIG_X86_INTEL_BRANCH_TRACKING_USER
> +       u64 r;
> +
> +       if (current->thread.cet.ibt_enabled) {
> +               rdmsrl(MSR_IA32_U_CET, r);
> +               wrmsrl(MSR_IA32_U_CET, r & ~MSR_IA32_CET_WAIT_ENDBR);
> +       }
> +#endif
> +}

These should be static.

But please just inline them directly in their one call site.  The code
will be a lot easier to understand.

--Andy
