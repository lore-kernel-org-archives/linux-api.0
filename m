From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v8 22/27] binfmt_elf: Extract .note.gnu.property from an
 ELF file
Date: Tue, 20 Aug 2019 11:02:10 +0100
Message-ID: <20190820100208.GO10425@arm.com>
References: <20190813205225.12032-1-yu-cheng.yu@intel.com>
 <20190813205225.12032-23-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190813205225.12032-23-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Borislav Petkov <bp@alien8.de>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 13, 2019 at 01:52:20PM -0700, Yu-cheng Yu wrote:
> An ELF file's .note.gnu.property indicates features the executable file
> can support.  For example, the property GNU_PROPERTY_X86_FEATURE_1_AND
> indicates the file supports GNU_PROPERTY_X86_FEATURE_1_IBT and/or
> GNU_PROPERTY_X86_FEATURE_1_SHSTK.
> 
> With this patch, if an arch needs to setup features from ELF properties,
> it needs CONFIG_ARCH_USE_GNU_PROPERTY to be set, and specific
> arch_parse_property() and arch_setup_property().
> 
> For example, for X86_64:
> 
> int arch_setup_property(void *ehdr, void *phdr, struct file *f, bool inter)
> {
> 	int r;
> 	uint32_t property;
> 
> 	r = get_gnu_property(ehdr, phdr, f, GNU_PROPERTY_X86_FEATURE_1_AND,
> 			     &property);
> 	...
> }
> 
> This patch is derived from code provided by H.J. Lu <hjl.tools@gmail.com>.
> 
> Signed-off-by: Yu-cheng Yu <yu-cheng.yu@intel.com>

[...]

For the hell of it, I tried implementing an alternate version [1] that
tries to integrate into the existing ELF loader more directly.

This may or may not be a better approach, but tries to solve some
issues such as not repeatedly reading and parsing the properties.

Cheers
---Dave


[1] [RFC PATCH 0/2] ELF: Alternate program property parser
https://lore.kernel.org/lkml/1566295063-7387-1-git-send-email-Dave.Martin@arm.com/
