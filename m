From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 04/27] x86/fpu/xstate: Add XSAVES system states for
 shadow stack
Date: Fri, 9 Nov 2018 09:17:40 -0800
Message-ID: <20181109171740.GT3074@bombadil.infradead.org>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
 <20181011151523.27101-5-yu-cheng.yu@intel.com>
 <CALCETrVAe8R=crVHoD5QmbN-gAW+V-Rwkwe4kQP7V7zQm9TM=Q@mail.gmail.com>
 <4295b8f786c10c469870a6d9725749ce75dcdaa2.camel@intel.com>
 <CALCETrUKzXYzRrWRdi8Z7AdAF0uZW5Gs7J4s=55dszoyzc29rw@mail.gmail.com>
 <043a17ef-dc9f-56d2-5fba-1a58b7b0fd4d@intel.com>
 <20181108220054.GP3074@bombadil.infradead.org>
 <ead230ab-a904-50d6-c4cf-46d5804f6151@intel.com>
 <20181109003225.GQ3074@bombadil.infradead.org>
 <6cd2ae51-2d2a-9c68-df7c-45b49e0a813f@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6cd2ae51-2d2a-9c68-df7c-45b49e0a813f@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Yu-cheng Yu <yu-cheng.yu@intel.com>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 09, 2018 at 09:13:32AM -0800, Dave Hansen wrote:
> On 11/8/18 4:32 PM, Matthew Wilcox wrote:
> >> Now, looking at Yu-cheng's specific example, it doesn't matter.  We've
> >> got 64-bit types and natural 64-bit alignment.  Without __packed, we
> >> need to look out for natural alignment screwing us up.  With __packed,
> >> it just does what it *looks* like it does.
> > The question is whether Yu-cheng's struct is ever embedded in another
> > struct.  And if so, what does the hardware do?
> 
> It's not really.
> 
> +struct cet_user_state {
> +	u64 u_cet;	/* user control flow settings */
> +	u64 user_ssp;	/* user shadow stack pointer */
> +} __packed;
> 
> This ends up embedded in 'struct fpu'.  The hardware tells us what the
> sum of all the sizes of all the state components are, and also tells us
> the offsets inside the larger buffer.
> 
> We double-check that the structure sizes exactly match the sizes that
> the hardware tells us that the buffer pieces are via XCHECK_SZ().
> 
> But, later versions of the hardware have instructions that don't have
> static offsets for the state components (when the XSAVES/XSAVEC
> instructions are used).  So, for those, the structure embedding isn't
> used at *all* since some state might not be present.

But *when present*, this structure is always aligned on an 8-byte
boundary, right?
