From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v6 22/26] x86/cet/shstk: ELF header parsing of
 Shadow Stack
Date: Thu, 25 Apr 2019 08:14:52 -0700
Message-ID: <e7bbb51291434a9c8526d7b617929465d5784121.camel@intel.com>
References: <20181119214809.6086-1-yu-cheng.yu@intel.com>
         <20181119214809.6086-23-yu-cheng.yu@intel.com>
         <20190425110211.GZ3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425110211.GZ3567@e103592.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Thu, 2019-04-25 at 12:02 +0100, Dave Martin wrote:
> On Mon, Nov 19, 2018 at 01:48:05PM -0800, Yu-cheng Yu wrote:
> > Look in .note.gnu.property of an ELF file and check if Shadow Stack needs
> > to be enabled for the task.
> 
> What's the status of this series?  I don't see anything in linux-next
> yet.
> 
> For describing ELF features, Arm has recently adopted
> NT_GNU_PROPERTY_TYPE_0, with properties closely modelled on
> GNU_PROPERTY_X86_FEATURE_1_AND etc. [1]
> 
> So, arm64 will be need something like this patch for supporting new
> features (such as the Branch Target Identification feature of ARMv8.5-A
> [2]).
> 
> If this series isn't likely to merge soon, can we split this patch into
> generic and x86-specific parts and handle them separately?
> 
> It would be good to see the generic ELF note parsing move to common
> code -- I'll take a look and comment in more detail.

Yes, I will work on that.

> 
> [...]
> 
> > diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> > index 69c0f892e310..557ed0ba71c7 100644
> > --- a/arch/x86/include/asm/elf.h
> > +++ b/arch/x86/include/asm/elf.h
> > @@ -381,4 +381,9 @@ struct va_alignment {
> >  
> >  extern struct va_alignment va_align;
> >  extern unsigned long align_vdso_addr(unsigned long);
> > +
> > +#ifdef CONFIG_ARCH_HAS_PROGRAM_PROPERTIES
> > +extern int arch_setup_features(void *ehdr, void *phdr, struct file *file,
> > +			       bool interp);
> > +#endif
> >  #endif /* _ASM_X86_ELF_H */
> > diff --git a/arch/x86/include/uapi/asm/elf_property.h
> > b/arch/x86/include/uapi/asm/elf_property.h
> > new file mode 100644
> > index 000000000000..af361207718c
> > --- /dev/null
> > +++ b/arch/x86/include/uapi/asm/elf_property.h
> > @@ -0,0 +1,15 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _UAPI_ASM_X86_ELF_PROPERTY_H
> > +#define _UAPI_ASM_X86_ELF_PROPERTY_H
> > +
> > +/*
> > + * pr_type
> > + */
> > +#define GNU_PROPERTY_X86_FEATURE_1_AND (0xc0000002)
> > +
> > +/*
> > + * Bits for GNU_PROPERTY_X86_FEATURE_1_AND
> > + */
> > +#define GNU_PROPERTY_X86_FEATURE_1_SHSTK	(0x00000002)
> > +
> 
> Generally we seem to collect all ELF definitions in <linux/uapi/elf.h>,
> including arch-specific ones.

Agree.

> 
> Is a new header really needed here?
> 
> [...]
> 
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index 54207327f98f..007ff0fbae84 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -1081,6 +1081,21 @@ static int load_elf_binary(struct linux_binprm *bprm)
> >  		goto out_free_dentry;
> >  	}
> >  
> > +#ifdef CONFIG_ARCH_HAS_PROGRAM_PROPERTIES
> > +	if (interpreter) {
> > +		retval = arch_setup_features(&loc->interp_elf_ex,
> > +					     interp_elf_phdata,
> > +					     interpreter, true);
> 
> Can we dummy no-op functions in the common headers to avoid this
> ifdeffery?  Logically all arches will always do this step, even if it's
> a no-op today.

Sure.

Thanks,

Yu-cheng
