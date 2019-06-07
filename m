From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from an
 ELF file
Date: Fri, 07 Jun 2019 09:17:06 -0700
Message-ID: <1b5778f8f1336ad7a63f4621f189b7f04a56a9ed.camel@intel.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
         <20190606200646.3951-23-yu-cheng.yu@intel.com>
         <20190607075822.GR3419@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190607075822.GR3419@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, 2019-06-07 at 09:58 +0200, Peter Zijlstra wrote:
> On Thu, Jun 06, 2019 at 01:06:41PM -0700, Yu-cheng Yu wrote:
> > An ELF file's .note.gnu.property indicates features the executable file
> > can support.  For example, the property GNU_PROPERTY_X86_FEATURE_1_AND
> > indicates the file supports GNU_PROPERTY_X86_FEATURE_1_IBT and/or
> > GNU_PROPERTY_X86_FEATURE_1_SHSTK.
> > 
> > With this patch, if an arch needs to setup features from ELF properties,
> > it needs CONFIG_ARCH_USE_GNU_PROPERTY to be set, and a specific
> > arch_setup_property().
> > 
> > For example, for X86_64:
> > 
> > int arch_setup_property(void *ehdr, void *phdr, struct file *f, bool inter)
> > {
> > 	int r;
> > 	uint32_t property;
> > 
> > 	r = get_gnu_property(ehdr, phdr, f, GNU_PROPERTY_X86_FEATURE_1_AND,
> > 			     &property);
> > 	...
> > }
> > 
> > Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> > Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>
> 
> Did HJ write this patch as suggested by that SoB chain? If so, you lost
> a From: line on top, if not, the SoB thing is invalid.

I will fix that.

Yu-cheng
