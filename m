From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] [RFC] making uapi/linux/elfcore.h useful again
Date: Sat, 15 Sep 2018 13:37:33 +0200
Message-ID: <20180915113733.GA35411@gmail.com>
References: <20180914113929.953895-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180914113929.953895-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Joseph =?iso-8859-1?Q?Myers=A0?= <joseph@codesourcery.com>, David Howells <dhowells@redhat.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> diff --git a/arch/x86/include/uapi/asm/elf.h b/arch/x86/include/uapi/asm/elf.h
> new file mode 100644
> index 000000000000..a640e1224939
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/elf.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_ASM_X86_ELF_H
> +#define _UAPI_ASM_X86_ELF_H
> +
> +#ifdef __i386__
> +
> +/*
> + * These are used to set parameters in the core dumps.
> + */
> +#define ELF_CLASS	ELFCLASS32
> +#define ELF_DATA	ELFDATA2LSB
> +#define ELF_ARCH	EM_386
> +#define ELF_NGREG	17
> +
> +#else
> +
> +/*
> + * These are used to set parameters in the core dumps.
> + */
> +#define ELF_CLASS	ELFCLASS64
> +#define ELF_DATA	ELFDATA2LSB
> +#define ELF_ARCH	EM_X86_64
> +#define ELF_NGREG	27
> +
> +#endif /* __i386__ */
> +
> +typedef unsigned long elf_greg_t;
> +typedef elf_greg_t elf_gregset_t[ELF_NGREG];
> +
> +#endif

On a second thought, maybe deduplicate the comments? Something like:

/*
 * These are used to set parameters in core dumps:
 */
#ifdef __i386__
# define ELF_CLASS	ELFCLASS32
# define ELF_DATA	ELFDATA2LSB
# define ELF_ARCH	EM_386
# define ELF_NGREG	17
#else
# define ELF_CLASS	ELFCLASS64
# define ELF_DATA	ELFDATA2LSB
# define ELF_ARCH	EM_X86_64
# define ELF_NGREG	27
#endif

Note:

 - I fixed a typo in the comment.
 - Aligned the blocks vertically for better visibility.
 - The closing #endif comment became unnecessary as well, due to the much more obvious 
   structure when written this way.

The type changes/cleanups look good otherwise: it's quite probable that it was never directly 
included in any user-space library in any sane fashion before, so it's not really an UAPI that 
was relied on, as long as it doesn't break the build anywhere.

Thanks,

	Ingo
