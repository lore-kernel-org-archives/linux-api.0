From: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCHv5, REBASED 9/9] x86/mm: Allow to have userspace mappings
 above 47-bits
Date: Mon, 15 May 2017 22:48:00 +0300
Message-ID: <20170515194759.di5pojt46e2lxo2p@black.fi.intel.com>
References: <20170515121218.27610-10-kirill.shutemov@linux.intel.com>
 <201705152204.F4FmHH4W%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201705152204.F4FmHH4W%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, May 15, 2017 at 10:49:43PM +0800, kbuild test robot wrote:
> Hi Kirill,
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.12-rc1 next-20170515]
> [cannot apply to tip/x86/core xen-tip/linux-next]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Kirill-A-Shutemov/x86-5-level-paging-enabling-for-v4-12-Part-4/20170515-202736
> config: i386-defconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/cache.h:4:0,
>                     from include/linux/printk.h:8,
>                     from include/linux/kernel.h:13,
>                     from mm/mmap.c:11:
>    mm/mmap.c: In function 'arch_get_unmapped_area_topdown':
>    arch/x86/include/asm/processor.h:878:50: error: 'TASK_SIZE_LOW' undeclared (first use in this function)
>     #define TASK_UNMAPPED_BASE  __TASK_UNMAPPED_BASE(TASK_SIZE_LOW)

Thanks. Fixup is below.

Let me know if I need to send the full patch:

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index aaed58b03ddb..65663de9287b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -794,6 +794,7 @@ static inline void spin_lock_prefetch(const void *x)
  */
 #define IA32_PAGE_OFFSET	PAGE_OFFSET
 #define TASK_SIZE		PAGE_OFFSET
+#define TASK_SIZE_LOW		TASK_SIZE
 #define TASK_SIZE_MAX		TASK_SIZE
 #define DEFAULT_MAP_WINDOW	TASK_SIZE
 #define STACK_TOP		TASK_SIZE
-- 
 Kirill A. Shutemov
