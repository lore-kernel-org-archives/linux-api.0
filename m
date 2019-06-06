From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 04/27] x86/fpu/xstate: Introduce XSAVES system states
Date: Thu, 6 Jun 2019 14:18:29 -0700
Message-ID: <0a2f8b9b-b96b-06c8-bae0-b78b2ca3b727@intel.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
 <20190606200646.3951-5-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606200646.3951-5-yu-cheng.yu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

> +/*
> + * Helpers for changing XSAVES system states.
> + */
> +static inline void modify_fpu_regs_begin(void)
> +{
> +	fpregs_lock();
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +		__fpregs_load_activate();
> +}
> +
> +static inline void modify_fpu_regs_end(void)
> +{
> +	fpregs_unlock();
> +}

These are massively under-commented and under-changelogged.  This looks
like it's intended to ensure that we have supervisor FPU state for this
task loaded before we go and run the MSRs that might be modifying it.

But, that seems broken.  If we have supervisor state, we can't always
defer the load until return to userspace, so we'll never?? have
TIF_NEED_FPU_LOAD.  That would certainly be true for cet_kernel_state.

It seems like we actually need three classes of XSAVE states:
1. User state
2. Supervisor state that affects user mode
3. Supervisor state that affects kernel mode

We can delay the load of 1 and 2, but not 3.

But I don't see any infrastructure for this.
