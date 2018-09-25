From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH v4 03/27] x86/fpu/xstate: Enable XSAVES system states
Date: Tue, 25 Sep 2018 19:03:55 +0200
Message-ID: <20180925170355.GD30146@hirez.programming.kicks-ass.net>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
 <20180921150351.20898-4-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180921150351.20898-4-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Randy
List-Id: linux-api@vger.kernel.org

On Fri, Sep 21, 2018 at 08:03:27AM -0700, Yu-cheng Yu wrote:
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 4bd56079048f..9f51b0e1da25 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -365,8 +365,13 @@ void fpu__drop(struct fpu *fpu)
>   */
>  static inline void copy_init_user_fpstate_to_fpregs(void)
>  {
> +	/*
> +	 * Only XSAVES user states are copied.
> +	 * System states are preserved.
> +	 */
>  	if (use_xsave())
> -		copy_kernel_to_xregs(&init_fpstate.xsave, -1);
> +		copy_kernel_to_xregs(&init_fpstate.xsave,
> +				     xfeatures_mask_user);

By my counting, that doesn't qualify for a line-break, it hits 80.

If you were to do this line-break, coding style would have you liberally
sprinkle {} around.

>  	else if (static_cpu_has(X86_FEATURE_FXSR))
>  		copy_kernel_to_fxregs(&init_fpstate.fxsave);
>  	else
