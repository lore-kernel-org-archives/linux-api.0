From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 04/27] x86/fpu/xstate: Add XSAVES system states for
 shadow stack
Date: Fri, 9 Nov 2018 00:52:44 +0100
Message-ID: <20181108235244.GK7543@zn.tnic>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
 <20181011151523.27101-5-yu-cheng.yu@intel.com>
 <20181108184038.GJ7543@zn.tnic>
 <bb049aa9578bae7cfc6bd7c05b540f033f6685cc.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb049aa9578bae7cfc6bd7c05b540f033f6685cc.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Thu, Nov 08, 2018 at 12:40:02PM -0800, Yu-cheng Yu wrote:
> In fpu_init_system_xstate(), we test and clear features that are not enabled.
> There we depend on the order of these elements.  This is the tenth "unknown
> xstate feature".

Aha, those are *reserved* bits - not unused, in XCR0.

Do an s/unused/reserved/g pls.

Now let's see, you have 0 for the 10th bit which happens to be

#define X86_FEATURE_FPU                 ( 0*32+ 0) /* Onboard FPU */

too. And if we look at the code:

        for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
                if (!boot_cpu_has(xsave_cpuid_features[i]))
                        xfeatures_mask_all &= ~BIT_ULL(i);

guess what happens if i == 10.

I know, the subsequent & SUPPORTED_XFEATURES_MASK saves you from the
#GP but that's still not good enough. The loop should not even call
boot_cpu_has() for reserved feature bits.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
