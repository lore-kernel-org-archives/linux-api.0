From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v6 22/26] x86/cet/shstk: ELF header parsing of Shadow
 Stack
Date: Thu, 25 Apr 2019 12:02:11 +0100
Message-ID: <20190425110211.GZ3567@e103592.cambridge.arm.com>
References: <20181119214809.6086-1-yu-cheng.yu@intel.com>
 <20181119214809.6086-23-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119214809.6086-23-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 01:48:05PM -0800, Yu-cheng Yu wrote:
> Look in .note.gnu.property of an ELF file and check if Shadow Stack needs
> to be enabled for the task.

What's the status of this series?  I don't see anything in linux-next
yet.

For describing ELF features, Arm has recently adopted
NT_GNU_PROPERTY_TYPE_0, with properties closely modelled on
GNU_PROPERTY_X86_FEATURE_1_AND etc. [1]

So, arm64 will be need something like this patch for supporting new
features (such as the Branch Target Identification feature of ARMv8.5-A
[2]).

If this series isn't likely to merge soon, can we split this patch into
generic and x86-specific parts and handle them separately?

It would be good to see the generic ELF note parsing move to common
code -- I'll take a look and comment in more detail.

[...]

> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index 69c0f892e310..557ed0ba71c7 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -381,4 +381,9 @@ struct va_alignment {
>  
>  extern struct va_alignment va_align;
>  extern unsigned long align_vdso_addr(unsigned long);
> +
> +#ifdef CONFIG_ARCH_HAS_PROGRAM_PROPERTIES
> +extern int arch_setup_features(void *ehdr, void *phdr, struct file *file,
> +			       bool interp);
> +#endif
>  #endif /* _ASM_X86_ELF_H */
> diff --git a/arch/x86/include/uapi/asm/elf_property.h b/arch/x86/include/uapi/asm/elf_property.h
> new file mode 100644
> index 000000000000..af361207718c
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/elf_property.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _UAPI_ASM_X86_ELF_PROPERTY_H
> +#define _UAPI_ASM_X86_ELF_PROPERTY_H
> +
> +/*
> + * pr_type
> + */
> +#define GNU_PROPERTY_X86_FEATURE_1_AND (0xc0000002)
> +
> +/*
> + * Bits for GNU_PROPERTY_X86_FEATURE_1_AND
> + */
> +#define GNU_PROPERTY_X86_FEATURE_1_SHSTK	(0x00000002)
> +

Generally we seem to collect all ELF definitions in <linux/uapi/elf.h>,
including arch-specific ones.

Is a new header really needed here?

[...]

> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 54207327f98f..007ff0fbae84 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1081,6 +1081,21 @@ static int load_elf_binary(struct linux_binprm *bprm)
>  		goto out_free_dentry;
>  	}
>  
> +#ifdef CONFIG_ARCH_HAS_PROGRAM_PROPERTIES
> +	if (interpreter) {
> +		retval = arch_setup_features(&loc->interp_elf_ex,
> +					     interp_elf_phdata,
> +					     interpreter, true);

Can we dummy no-op functions in the common headers to avoid this
ifdeffery?  Logically all arches will always do this step, even if it's
a no-op today.

> +	} else {
> +		retval = arch_setup_features(&loc->elf_ex,
> +					     elf_phdata,
> +					     bprm->file, false);
> +	}
> +
> +	if (retval < 0)
> +		goto out_free_dentry;
> +#endif
> +
>  	if (elf_interpreter) {
>  		unsigned long interp_map_addr = 0;
>  
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index c5358e0ae7c5..5ef25a565e88 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -372,6 +372,7 @@ typedef struct elf64_shdr {
>  #define NT_PRFPREG	2
>  #define NT_PRPSINFO	3
>  #define NT_TASKSTRUCT	4
> +#define NT_GNU_PROPERTY_TYPE_0 5

IIUC, note type codes are namespaced by the note name.  This section
currently only seems to have codes for name == "LINUX".

There are conflicts: for example NT_GNU_ABI_TAG == NT_PRSTATUS.

We should probably split out the codes for name == "GNU" into a separate
list, otherwise people are likely to get confused.

As noted above, can the GNU_PRPOERTY_<arch>_* definitions just go in
here instead of a separate header?

[...]

Cheers
---Dave

[1] https://developer.arm.com/docs/ihi0056/latest/elf-for-the-arm-64-bit-architecture-aarch64-abi-2019q1-documentation

[2] https://community.arm.com/developer/ip-products/processors/b/processors-ip-blog/posts/arm-a-profile-architecture-2018-developments-armv85a
