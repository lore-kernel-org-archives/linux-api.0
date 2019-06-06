From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v7 04/27] x86/fpu/xstate: Introduce XSAVES system states
Date: Thu, 6 Jun 2019 15:08:23 -0700
Message-ID: <4effb749-0cdc-6a49-6352-7b2d4aa7d866@intel.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
 <20190606200646.3951-5-yu-cheng.yu@intel.com>
 <0a2f8b9b-b96b-06c8-bae0-b78b2ca3b727@intel.com>
 <5EE146A8-6C8C-4C5D-B7C0-AB8AD1012F1E@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5EE146A8-6C8C-4C5D-B7C0-AB8AD1012F1E@amacapital.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org



On 6/6/19 3:04 PM, Andy Lutomirski wrote:
>> But, that seems broken.  If we have supervisor state, we can't 
>> always defer the load until return to userspace, so we'll never?? 
>> have TIF_NEED_FPU_LOAD.  That would certainly be true for 
>> cet_kernel_state.
> 
> Ugh. I was sort of imagining that we would treat supervisor state
 completely separately from user state.  But can you maybe give
examples of exactly what you mean?
> 
>> It seems like we actually need three classes of XSAVE states: 1. 
>> User state
> 
> This is FPU, XMM, etc, right?

Yep.

>> 2. Supervisor state that affects user mode
> 
> User CET?

Yep.

>> 3. Supervisor state that affects kernel mode
> 
> Like supervisor CET?  If we start doing supervisor shadow stack, the 
> context switches will be real fun.  We may need to handle this in 
> asm.

Yeah, that's what I was thinking.

I have the feeling Yu-cheng's patches don't comprehend this since
Sebastian's patches went in after he started working on shadow stacks.

> Where does PKRU fit in?  Maybe we can treat it as #3?

I thought Sebastian added specific PKRU handling to make it always
eager.  It's actually user state that affect kernel mode. :)
