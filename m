From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v8 03/27] x86/fpu/xstate: Change names to separate XSAVES
 system and user states
Date: Wed, 21 Aug 2019 16:45:37 +0200
Message-ID: <20190821144537.GE6752@zn.tnic>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
 <20190813205225.12032-4-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190813205225.12032-4-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Tue, Aug 13, 2019 at 01:52:01PM -0700, Yu-cheng Yu wrote:
> Control-flow Enforcement (CET) MSR contents are XSAVES system states.
> To support CET, introduce XSAVES system states first.
> 
> XSAVES is a "supervisor" instruction and, comparing to XSAVE, saves
> additional "supervisor" states that can be modified only from CPL 0.
> However, these states are per-task and not kernel's own.  Rename
> "supervisor" states to "system" states to clearly separate them from
> "user" states.
> 
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> ---
>  arch/x86/include/asm/fpu/internal.h |  4 +-
>  arch/x86/include/asm/fpu/xstate.h   | 20 +++----
>  arch/x86/kernel/fpu/init.c          |  2 +-
>  arch/x86/kernel/fpu/signal.c        | 10 ++--
>  arch/x86/kernel/fpu/xstate.c        | 86 ++++++++++++++---------------
>  5 files changed, 60 insertions(+), 62 deletions(-)

...

> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index e5cb67d67c03..d560e8861a3c 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -54,13 +54,16 @@ static short xsave_cpuid_features[] __initdata = {
>  };
>  
>  /*
> - * Mask of xstate features supported by the CPU and the kernel:
> + * XSAVES system states can only be modified from CPL 0 and saved by
> + * XSAVES.  The rest are user states.  The following is a mask of
> + * supported user state features derived from boot_cpu_has() and

...derived from detected CPUID feature flags and
SUPPORTED_XFEATURES_MASK.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
