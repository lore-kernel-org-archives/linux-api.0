From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v5 04/27] x86/fpu/xstate: Add XSAVES system states for
 shadow stack
Date: Thu, 08 Nov 2018 12:40:02 -0800
Message-ID: <bb049aa9578bae7cfc6bd7c05b540f033f6685cc.camel@intel.com>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
         <20181011151523.27101-5-yu-cheng.yu@intel.com>
         <20181108184038.GJ7543@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181108184038.GJ7543@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Thu, 2018-11-08 at 19:40 +0100, Borislav Petkov wrote:
> On Thu, Oct 11, 2018 at 08:15:00AM -0700, Yu-cheng Yu wrote:
> > [...] 
> > +/*
> > + * State component 11 is Control flow Enforcement user states
> 
> Why the Camel-cased naming?
> 
> "Control" then "flow" then capitalized again "Enforcement".
> 
> Fix all occurrences pls, especially the user-visible strings.

I will change it to "Control-flow Enforcement" everywhere.

> > + */
> > +struct cet_user_state {
> > +	u64 u_cet;	/* user control flow settings */
> > +	u64 user_ssp;	/* user shadow stack pointer */
> 
> Prefix both with "usr_" instead.

Ok.

> [...]
> 
> Just write "privilege level" everywhere - not "ring".
> 
> Btw, do you see how the type and the name of all those other fields in
> that file are tabulated? Except yours...

I will fix it.

[...] 
> > 
> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index 605ec6decf3e..ad36ea28bfd1 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -35,6 +35,9 @@ static const char *xfeature_names[] =
> >  	"Processor Trace (unused)"	,
> >  	"Protection Keys User registers",
> >  	"unknown xstate feature"	,
> > +	"Control flow User registers"	,
> > +	"Control flow Kernel registers"	,
> > +	"unknown xstate feature"	,
> 
> So there are two "unknown xstate feature" array elems now...
> 
> >  static short xsave_cpuid_features[] __initdata = {
> > @@ -48,6 +51,9 @@ static short xsave_cpuid_features[] __initdata = {
> >  	X86_FEATURE_AVX512F,
> >  	X86_FEATURE_INTEL_PT,
> >  	X86_FEATURE_PKU,
> > +	0,		   /* Unused */
> 
> What's that for?

In fpu_init_system_xstate(), we test and clear features that are not enabled.
There we depend on the order of these elements.  This is the tenth "unknown
xstate feature".

Yu-cheng
