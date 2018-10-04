From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v4 03/27] x86/fpu/xstate: Enable XSAVES system states
Date: Thu, 04 Oct 2018 08:47:35 -0700
Message-ID: <beb7872250b61e42c0069a4aab710b31f804d72c.camel@intel.com>
References: <20180921150351.20898-1-yu-cheng.yu@intel.com>
         <20180921150351.20898-4-yu-cheng.yu@intel.com>
         <20181002171554.GE29601@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002171554.GE29601@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Tue, 2018-10-02 at 19:15 +0200, Borislav Petkov wrote:
> On Fri, Sep 21, 2018 at 08:03:27AM -0700, Yu-cheng Yu wrote:
> > 
> > diff --git a/arch/x86/include/asm/fpu/xstate.h
> > b/arch/x86/include/asm/fpu/xstate.h
> > index 9b382e5157ed..a32dc5f8c963 100644
> > --- a/arch/x86/include/asm/fpu/xstate.h
> > +++ b/arch/x86/include/asm/fpu/xstate.h
> > @@ -19,10 +19,10 @@
> >  #define XSAVE_YMM_SIZE	    256
> >  #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET)
> >  
> > -/* System features */
> > -#define XFEATURE_MASK_SYSTEM (XFEATURE_MASK_PT)
> 
> Previous patch renames it, this patch deletes it. Why do we need all
> that unnecessary churn?
> 
> Also, this patch is trying to do a couple of things at once and
> reviewing it is not trivial. Please split the changes logically.

Yes, if we leave XFEATURE_MASK_SUPERVISOR unchanged in the previous patch, this
patch becomes much simpler.  Perhaps we don't even need to split this one.

> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index 19f8df54c72a..dd2c561c4544 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -51,13 +51,16 @@ static short xsave_cpuid_features[] __initdata = {
> >  };
> >  
> >  /*
> > - * Mask of xstate features supported by the CPU and the kernel:
> > + * Mask of xstate features supported by the CPU and the kernel.
> > + * This is the result from CPUID query, SUPPORTED_XFEATURES_MASK,
> > + * and boot_cpu_has().
> >   */
> 
> This needs to explain what both masks are - user and system. "CPU" and
> "kernel" is not "user" and "all".
> 
> >  u64 xfeatures_mask_user __read_mostly;
> > +u64 xfeatures_mask_all __read_mostly;

The first one is all supported "user" states; the latter is "system" and "user"
states combined.  I will put in comments.

Yu-cheng
