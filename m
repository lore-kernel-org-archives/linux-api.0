From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v7 05/27] x86/fpu/xstate: Add XSAVES system states for
 shadow stack
Date: Fri, 07 Jun 2019 09:14:50 -0700
Message-ID: <388e702bfa4ed38f460327ae09ebc9b18b582bb5.camel@intel.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
         <20190606200646.3951-6-yu-cheng.yu@intel.com>
         <20190607070725.GN3419@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190607070725.GN3419@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, 2019-06-07 at 09:07 +0200, Peter Zijlstra wrote:
> On Thu, Jun 06, 2019 at 01:06:24PM -0700, Yu-cheng Yu wrote:
> > Intel Control-flow Enforcement Technology (CET) introduces the
> > following MSRs.
> > 
> >     MSR_IA32_U_CET (user-mode CET settings),
> >     MSR_IA32_PL3_SSP (user-mode shadow stack),
> >     MSR_IA32_PL0_SSP (kernel-mode shadow stack),
> >     MSR_IA32_PL1_SSP (Privilege Level 1 shadow stack),
> >     MSR_IA32_PL2_SSP (Privilege Level 2 shadow stack).
> > 
> > Introduce them into XSAVES system states.
> > 
> > Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> > ---
> >  arch/x86/include/asm/fpu/types.h            | 22 +++++++++++++++++++++
> >  arch/x86/include/asm/fpu/xstate.h           |  4 +++-
> >  arch/x86/include/uapi/asm/processor-flags.h |  2 ++
> >  arch/x86/kernel/fpu/xstate.c                | 10 ++++++++++
> >  4 files changed, 37 insertions(+), 1 deletion(-)
> 
> And yet, no changes to msr-index.h !?

You are right.  I will move msr-index.h changes to here.

Yu-cheng
