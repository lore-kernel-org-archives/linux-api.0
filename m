From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] binfmt_elf: Extract .note.gnu.property from an ELF file
Date: Thu, 2 May 2019 15:29:52 +0100
Message-ID: <20190502142951.GP3567@e103592.cambridge.arm.com>
References: <20190501211217.5039-1-yu-cheng.yu@intel.com>
 <20190502111003.GO3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190502111003.GO3567@e103592.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Thu, May 02, 2019 at 12:10:04PM +0100, Dave Martin wrote:
> On Wed, May 01, 2019 at 02:12:17PM -0700, Yu-cheng Yu wrote:
> > An ELF file's .note.gnu.property indicates features the executable file
> > can support.  For example, the property GNU_PROPERTY_X86_FEATURE_1_AND
> > indicates the file supports GNU_PROPERTY_X86_FEATURE_1_IBT and/or
> > GNU_PROPERTY_X86_FEATURE_1_SHSTK.
> > 
> > This patch was part of the Control-flow Enforcement series; the original
> > patch is here: https://lkml.org/lkml/2018/11/20/205.  Dave Martin responded
> > that ARM recently introduced new features to NT_GNU_PROPERTY_TYPE_0 with
> > properties closely modelled on GNU_PROPERTY_X86_FEATURE_1_AND, and it is
> > logical to split out the generic part.  Here it is.
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

[...]

> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c > > index 7d09d125f148..40aa4a4fd64d 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -1076,6 +1076,19 @@ static int load_elf_binary(struct linux_binprm *bprm)
> >  		goto out_free_dentry;
> >  	}
> >  
> > +	if (interpreter) {
> > +		retval = arch_setup_property(&loc->interp_elf_ex,
> > +					     interp_elf_phdata,
> > +					     interpreter, true);
> > +	} else {
> > +		retval = arch_setup_property(&loc->elf_ex,
> > +					     elf_phdata,
> > +					     bprm->file, false);
> > +	}

This will be too late for arm64, since we need to twiddle the mmap prot
flags for the executable's pages based on the detected properties.

Can we instead move this much earlier, letting the arch code stash
something in arch_state that can be consumed later on?

This also has the advantage that we can report errors to the execve()
caller before passing the point of no return (i.e., flush_old_exec()).

[...]

> > diff --git a/fs/gnu_property.c b/fs/gnu_property.c

[...]

> > +int get_gnu_property(void *ehdr_p, void *phdr_p, struct file *f,
> > +		     u32 pr_type, u32 *property)
> > +{
> > +	struct elf64_hdr *ehdr64 = ehdr_p;
> > +	int err = 0;
> > +
> > +	*property = 0;
> > +
> > +	if (ehdr64->e_ident[EI_CLASS] == ELFCLASS64) {
> > +		struct elf64_phdr *phdr64 = phdr_p;
> > +
> > +		err = scan_segments_64(f, phdr64, ehdr64->e_phnum,
> > +				       pr_type, property);
> > +		if (err < 0)
> > +			goto out;
> > +	} else {
> > +#ifdef CONFIG_COMPAT
> > +		struct elf32_hdr *ehdr32 = ehdr_p;
> > +
> > +		if (ehdr32->e_ident[EI_CLASS] == ELFCLASS32) {
> > +			struct elf32_phdr *phdr32 = phdr_p;
> > +
> > +			err = scan_segments_32(f, phdr32, ehdr32->e_phnum,
> > +					       pr_type, property);
> > +			if (err < 0)
> > +				goto out;
> > +		}
> > +#else
> > +	WARN_ONCE(1, "Exec of 32-bit app, but CONFIG_COMPAT is not enabled.\n");
> > +	return -ENOTSUPP;
> > +#endif
> > +	}

We have already made a ton of assumptions about the ELF class by this
point, and we don't seem to check it explicitly elsewhere, so it is a
bit weird to police it specifically here.

Can we simply pass the assumed ELF class as a parameter instead?

[...]

Cheers
---DavE
