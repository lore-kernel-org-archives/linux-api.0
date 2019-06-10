From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from an
 ELF file
Date: Mon, 10 Jun 2019 17:57:31 +0100
Message-ID: <20190610165730.GM28398@e103592.cambridge.arm.com>
References: <20190606200646.3951-1-yu-cheng.yu@intel.com>
 <20190606200646.3951-23-yu-cheng.yu@intel.com>
 <20190607180115.GJ28398@e103592.cambridge.arm.com>
 <94b9c55b3b874825fda485af40ab2a6bc3dad171.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94b9c55b3b874825fda485af40ab2a6bc3dad171.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 10, 2019 at 09:29:04AM -0700, Yu-cheng Yu wrote:
> On Fri, 2019-06-07 at 19:01 +0100, Dave Martin wrote:
> > On Thu, Jun 06, 2019 at 01:06:41PM -0700, Yu-cheng Yu wrote:
> > > An ELF file's .note.gnu.property indicates features the executable file
> > > can support.  For example, the property GNU_PROPERTY_X86_FEATURE_1_AND
> > > indicates the file supports GNU_PROPERTY_X86_FEATURE_1_IBT and/or
> > > GNU_PROPERTY_X86_FEATURE_1_SHSTK.
> > > 
> > > With this patch, if an arch needs to setup features from ELF properties,
> > > it needs CONFIG_ARCH_USE_GNU_PROPERTY to be set, and a specific
> > > arch_setup_property().
> > > 
> > > For example, for X86_64:
> > > 
> > > int arch_setup_property(void *ehdr, void *phdr, struct file *f, bool inter)
> > > {
> > > 	int r;
> > > 	uint32_t property;
> > > 
> > > 	r = get_gnu_property(ehdr, phdr, f, GNU_PROPERTY_X86_FEATURE_1_AND,
> > > 			     &property);
> > > 	...
> > > }
> > 
> > Although this code works for the simple case, I have some concerns about
> > some aspects of the implementation here.  There appear to be some bounds
> > checking / buffer overrun issues, and the code seems quite complex.
> > 
> > Maybe this patch tries too hard to be compatible with toolchains that do
> > silly things such as embedding huge notes in an executable, or mixing
> > NT_GNU_PROPERTY_TYPE_0 in a single PT_NOTE with a load of junk not
> > relevant to the loader.  I wonder whether Linux can dictate what
> > interpretation(s) of the ELF specs it is prepared to support, rather than
> > trying to support absolutely anything.
> 
> To me, looking at PT_GNU_PROPERTY and not trying to support anything is a
> logical choice.  And it breaks only a limited set of toolchains.
> 
> I will simplify the parser and leave this patch as-is for anyone who wants to
> back-port.  Are there any objections or concerns?

No objection from me ;)  But I'm biased.

Hopefully this change should allow substantial simplification.  For one
thing, PT_GNU_PROPERTY tells its file offset and size directly in its
phdrs entry.  That should save us a lot of effort on the kernel side.

Cheers
---Dave
