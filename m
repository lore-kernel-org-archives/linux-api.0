From: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH v2] next: openrisc: Fix build
Date: Fri, 26 Sep 2014 19:51:49 +0200
Message-ID: <5425A7B5.10209@southpole.se>
References: <1411747539-28308-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bounces@lists.openrisc.net>
In-Reply-To: <1411747539-28308-1-git-send-email-linux@roeck-us.net>
List-Unsubscribe: <http://lists.openrisc.net/options/linux>,
	<mailto:linux-request@lists.openrisc.net?subject=unsubscribe>
List-Archive: <http://lists.openrisc.net/pipermail/linux>
List-Post: <mailto:linux@lists.openrisc.net>
List-Help: <mailto:linux-request@lists.openrisc.net?subject=help>
List-Subscribe: <http://lists.openrisc.net/listinfo/linux>,
	<mailto:linux-request@lists.openrisc.net?subject=subscribe>
Sender: linux-bounces@lists.openrisc.net
Errors-To: linux-bounces@lists.openrisc.net
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>, linux-next@vger.kernel.org, linux@lists.openrisc.net
List-Id: linux-api@vger.kernel.org

On 09/26/2014 06:05 PM, Guenter Roeck wrote:
> openrisc:defconfig fails to build in next-20140926 with the following error.
>
> In file included from arch/openrisc/kernel/signal.c:31:0:
> ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
> ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
>
> Fix by moving EM_OPENRISC to include/uapi/linux/elf-em.h.
>
> Fixes: ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Only move EM_OPENRISC.
>
> Another possible solution for the problem would be to include asm/elf.h
> in arch/openrisc/kernel/signal.c. I had actually submitted a patch with
> that fix back in August (maybe that is where I remembered the problem from).
> Wonder what happened with that patch.
>
> Would it make sense to drop EM_OR32 and replace it with EM_OPENRISC where
> it is used ? binutils seems to suggest that EM_OPENRISC is the "official"
> definition.

Do we even use EM_OR32?  Will the kernel build with the old toolchain if
we drop it?  If yes, drop it altogether... I don't recall the details as
to why we kept that define around at all.  And really, why bother
supporting the old toolchain at all... it's been at least two or three
years since EM_OPENRISC was added, hopefully people have moved on.  If
users want to upgrade their kernel, they can update the toolchain, too,
at this point.

/Jonas

>
>  arch/openrisc/include/uapi/asm/elf.h | 3 +--
>  include/uapi/linux/elf-em.h          | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/openrisc/include/uapi/asm/elf.h b/arch/openrisc/include/uapi/asm/elf.h
> index f02ea58..8884276 100644
> --- a/arch/openrisc/include/uapi/asm/elf.h
> +++ b/arch/openrisc/include/uapi/asm/elf.h
> @@ -55,9 +55,8 @@ typedef elf_greg_t elf_gregset_t[ELF_NGREG];
>  /* A placeholder; OR32 does not have fp support yes, so no fp regs for now.  */
>  typedef unsigned long elf_fpregset_t;
>  
> -/* This should be moved to include/linux/elf.h */
> +/* EM_OPENRISC is defined in linux/elf-em.h */
>  #define EM_OR32         0x8472
> -#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
>  
>  /*
>   * These are used to set parameters in the core dumps.
> diff --git a/include/uapi/linux/elf-em.h b/include/uapi/linux/elf-em.h
> index 01529bd..aa90bc9 100644
> --- a/include/uapi/linux/elf-em.h
> +++ b/include/uapi/linux/elf-em.h
> @@ -32,6 +32,7 @@
>  #define EM_V850		87	/* NEC v850 */
>  #define EM_M32R		88	/* Renesas M32R */
>  #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
> +#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
>  #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
>  #define EM_TI_C6000	140	/* TI C6X DSPs */
>  #define EM_AARCH64	183	/* ARM 64 bit */
