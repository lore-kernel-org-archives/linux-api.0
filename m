From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH 1/5] elf: add livepatch-specific elf constants
Date: Wed, 11 Nov 2015 14:58:24 +0100
Message-ID: <20151111135824.GF4431@pathway.suse.cz>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-2-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447130755-17383-2-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-11-09 23:45:51, Jessica Yu wrote:
> Add livepatch elf reloc section flag, livepatch symbol bind
> and section index

Please, add here more detailed description from the initial mail.
It would be helpful to have it in the git history.

> Signed-off-by: Jessica Yu <jeyu@redhat.com>
> ---
>  include/uapi/linux/elf.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index 71e1d0e..967ce1b 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -118,6 +118,7 @@ typedef __s64	Elf64_Sxword;
>  #define STB_LOCAL  0
>  #define STB_GLOBAL 1
>  #define STB_WEAK   2
> +#define STB_LIVEPATCH_EXT 11
>  
>  #define STT_NOTYPE  0
>  #define STT_OBJECT  1
> @@ -286,6 +287,7 @@ typedef struct elf64_phdr {
>  #define SHF_ALLOC	0x2
>  #define SHF_EXECINSTR	0x4
>  #define SHF_MASKPROC	0xf0000000
> +#define SHF_RELA_LIVEPATCH  0x4000000

I would make the names ordered by the numeric values.

>  /* special section indexes */
>  #define SHN_UNDEF	0
> @@ -295,6 +297,7 @@ typedef struct elf64_phdr {
>  #define SHN_ABS		0xfff1
>  #define SHN_COMMON	0xfff2
>  #define SHN_HIRESERVE	0xffff
> +#define SHN_LIVEPATCH 0xff21

Same here.

Best Regards,
Petr

>  typedef struct elf32_shdr {
>    Elf32_Word	sh_name;
> -- 
> 2.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
