From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v4 01/27] x86/cpufeatures: Add CPUIDs for
 Control-flow Enforcement Technology (CET)
Date: Tue, 25 Sep 2018 09:29:51 -0700
Message-ID: <309a30584a56babbd4d25199f71b786442300c1e.camel@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
         <20180921150351.20898-2-yu-cheng.yu@intel.com>
         <20180925162705.GB30146@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925162705.GB30146@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>, Randy
List-Id: linux-api@vger.kernel.org

On Tue, 2018-09-25 at 18:27 +0200, Peter Zijlstra wrote:
> On Fri, Sep 21, 2018 at 08:03:25AM -0700, Yu-cheng Yu wrote:
> 
> > diff --git a/arch/x86/kernel/cpu/scattered.c
> > b/arch/x86/kernel/cpu/scattered.c
> > index 772c219b6889..63cbb4d9938e 100644
> > --- a/arch/x86/kernel/cpu/scattered.c
> > +++ b/arch/x86/kernel/cpu/scattered.c
> > @@ -21,6 +21,7 @@ struct cpuid_bit {
> >  static const struct cpuid_bit cpuid_bits[] = {
> >  	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
> >  	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
> > +	{ X86_FEATURE_IBT,		CPUID_EDX, 20, 0x00000007, 0},
> 
>                                                                    ^^
> missing white space at the end there.

I will fix it.  Thanks!
