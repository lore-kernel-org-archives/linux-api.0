From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v8 02/27] x86/cpufeatures: Add CET CPU feature flags for
 Control-flow Enforcement Technology (CET)
Date: Wed, 21 Aug 2019 07:46:32 -0700
Message-ID: <8d2e5bc4496075032393ff9ae81a26f7fbc711e6.camel@intel.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
         <20190813205225.12032-3-yu-cheng.yu@intel.com>
         <20190821102052.GD6752@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190821102052.GD6752@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Wed, 2019-08-21 at 12:20 +0200, Borislav Petkov wrote:
> On Tue, Aug 13, 2019 at 01:52:00PM -0700, Yu-cheng Yu wrote:
> > Add CPU feature flags for Control-flow Enforcement Technology (CET).
> > 
> > [...]
> > diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-
> > deps.c
> > index b5353244749b..9bf35f081080 100644
> > --- a/arch/x86/kernel/cpu/cpuid-deps.c
> > +++ b/arch/x86/kernel/cpu/cpuid-deps.c
> > @@ -68,6 +68,8 @@ static const struct cpuid_dep cpuid_deps[] = {
> >  	{ X86_FEATURE_CQM_MBM_TOTAL,	X86_FEATURE_CQM_LLC   },
> >  	{ X86_FEATURE_CQM_MBM_LOCAL,	X86_FEATURE_CQM_LLC   },
> >  	{ X86_FEATURE_AVX512_BF16,	X86_FEATURE_AVX512VL  },
> > +	{ X86_FEATURE_SHSTK,		X86_FEATURE_XSAVES    },
> > +	{ X86_FEATURE_IBT,		X86_FEATURE_XSAVES    },
> 
> This hunk needs re-tabbing after:
> 
> 1e0c08e3034d ("cpu/cpuid-deps: Add a tab to cpuid dependent features")

Thanks, I will fix it.

Yu-cheng
