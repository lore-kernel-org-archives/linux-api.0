From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCHv3 33/33] mm, x86: introduce PR_SET_MAX_VADDR and
 PR_GET_MAX_VADDR
Date: Mon, 20 Feb 2017 16:15:16 +0300
Message-ID: <20170220131515.GA9502@node.shutemov.name>
References: <20170217141328.164563-1-kirill.shutemov@linux.intel.com>
 <20170217141328.164563-34-kirill.shutemov@linux.intel.com>
 <CA+55aFwgbHxV-Ha2n1H=Z7P6bgcQ3D8aW=fr8ZrQ5OnvZ1vOYg@mail.gmail.com>
 <20170218092133.GA17471@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170218092133.GA17471-sVvlyX1904swdBt8bTSxpkEMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 18, 2017 at 12:21:33PM +0300, Kirill A. Shutemov wrote:
> On Fri, Feb 17, 2017 at 12:02:13PM -0800, Linus Torvalds wrote:
> > I also get he feeling that the whole thing is unnecessary. I'm
> > wondering if we should just instead say that the whole 47 vs 56-bit
> > virtual address is _purely_ about "get_unmapped_area()", and nothing
> > else.
> > 
> > IOW, I'm wondering if we can't just say that
> > 
> >  - if the processor and kernel support 56-bit user address space, then
> > you can *always* use the whole space
> > 
> >  - but by default, get_unmapped_area() will only return mappings that
> > fit in the 47 bit address space.
> > 
> > So if you use MAP_FIXED and give an address in the high range, it will
> > just always work, and the MM will always consider the task size to be
> > the full address space.
> > 
> > But for the common case where a process does no use MAP_FIXED, the
> > kernel will never give a high address by default, and you have to do
> > the process control thing to say "I want those high addresses".
> > 
> > Hmm?
> > 
> > In other words, I'd like to at least start out trying to keep the
> > differences between the 47-bit and 56-bit models as simple and minimal
> > as possible. Not make such a big deal out of it.
> > 
> > We already have "arch_get_unmapped_area()" that controls the whole
> > "what will non-MAP_FIXED mmap allocations return", so I'd hope that
> > the above kind of semantics could be done without *any* actual
> > TASK_SIZE changes _anywhere_ in the VM code.
> > 
> > Comments?
> 
> Okay, below is my try on implementing this.
> 
> I've chosen to respect hint address even without MAP_FIXED, but only if
> it doesn't collide with other mappings. Otherwise, fallback to look for
> unmapped area within 47-bit window.
> 
> Interaction with MPX would requires more work. I'm not yet sure what is the
> right way to address it.

I *think* this should do the trick for MPX too.

Dave, could you check if it looks reasonable for you?

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index e7f155c3045e..9c6315d9aa34 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -250,7 +250,7 @@ extern int force_personality32;
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+#define ELF_ET_DYN_BASE		(DEFAULT_MAP_WINDOW / 3 * 2)
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports.  This could be done in user space,
diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
index 0b416d4cf73b..b722499f6aba 100644
--- a/arch/x86/include/asm/mpx.h
+++ b/arch/x86/include/asm/mpx.h
@@ -71,6 +71,9 @@ static inline void mpx_mm_init(struct mm_struct *mm)
 }
 void mpx_notify_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long start, unsigned long end);
+
+unsigned long mpx_unmapped_area_check(unsigned long addr, unsigned long len,
+		unsigned long flags);
 #else
 static inline siginfo_t *mpx_generate_siginfo(struct pt_regs *regs)
 {
@@ -92,6 +95,12 @@ static inline void mpx_notify_unmap(struct mm_struct *mm,
 				    unsigned long start, unsigned long end)
 {
 }
+
+static inline unsigned long mpx_unmapped_area_check(unsigned long addr,
+		unsigned long len, unsigned long flags)
+{
+	return addr;
+}
 #endif /* CONFIG_X86_INTEL_MPX */
 
 #endif /* _ASM_X86_MPX_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e6cfe7ba2d65..492548c87cb1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -789,6 +789,7 @@ static inline void spin_lock_prefetch(const void *x)
  */
 #define TASK_SIZE		PAGE_OFFSET
 #define TASK_SIZE_MAX		TASK_SIZE
+#define DEFAULT_MAP_WINDOW	TASK_SIZE
 #define STACK_TOP		TASK_SIZE
 #define STACK_TOP_MAX		STACK_TOP
 
@@ -828,7 +829,9 @@ static inline void spin_lock_prefetch(const void *x)
  * particular problem by preventing anything from being mapped
  * at the maximum canonical address.
  */
-#define TASK_SIZE_MAX	((1UL << 47) - PAGE_SIZE)
+#define TASK_SIZE_MAX	((1UL << __VIRTUAL_MASK_SHIFT) - PAGE_SIZE)
+
+#define DEFAULT_MAP_WINDOW	((1UL << 47) - PAGE_SIZE)
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
@@ -841,7 +844,7 @@ static inline void spin_lock_prefetch(const void *x)
 #define TASK_SIZE_OF(child)	((test_tsk_thread_flag(child, TIF_ADDR32)) ? \
 					IA32_PAGE_OFFSET : TASK_SIZE_MAX)
 
-#define STACK_TOP		TASK_SIZE
+#define STACK_TOP		DEFAULT_MAP_WINDOW
 #define STACK_TOP_MAX		TASK_SIZE_MAX
 
 #define INIT_THREAD  {						\
@@ -863,7 +866,7 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
  * This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
  */
-#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
+#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(DEFAULT_MAP_WINDOW / 3))
 
 #define KSTK_EIP(task)		(task_pt_regs(task)->ip)
 
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index a55ed63b9f91..df7bfc635941 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -18,6 +18,7 @@
 
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
+#include <asm/mpx.h>
 
 /*
  * Align a virtual address to avoid aliasing in the I$ on AMD F15h.
@@ -128,6 +129,10 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	struct vm_unmapped_area_info info;
 	unsigned long begin, end;
 
+	addr = mpx_unmapped_area_check(addr, len, flags);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
 	if (flags & MAP_FIXED)
 		return addr;
 
@@ -147,7 +152,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = begin;
-	info.high_limit = end;
+	info.high_limit = min(end, DEFAULT_MAP_WINDOW);
 	info.align_mask = 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	if (filp) {
@@ -167,6 +172,10 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	unsigned long addr = addr0;
 	struct vm_unmapped_area_info info;
 
+	addr = mpx_unmapped_area_check(addr, len, flags);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
 		return -ENOMEM;
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 2ae8584b44c7..329d653f7238 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -15,6 +15,7 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
+#include <asm/mpx.h>
 
 #if 0	/* This is just for testing */
 struct page *
@@ -82,7 +83,7 @@ static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 	info.flags = 0;
 	info.length = len;
 	info.low_limit = current->mm->mmap_legacy_base;
-	info.high_limit = TASK_SIZE;
+	info.high_limit = DEFAULT_MAP_WINDOW;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
 	return vm_unmapped_area(&info);
@@ -114,7 +115,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 		VM_BUG_ON(addr != -ENOMEM);
 		info.flags = 0;
 		info.low_limit = TASK_UNMAPPED_BASE;
-		info.high_limit = TASK_SIZE;
+		info.high_limit = DEFAULT_MAP_WINDOW;
 		addr = vm_unmapped_area(&info);
 	}
 
@@ -131,6 +132,11 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 
 	if (len & ~huge_page_mask(h))
 		return -EINVAL;
+
+	addr = mpx_unmapped_area_check(addr, len, flags);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index d2dc0438d654..a29a830ad341 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -52,7 +52,7 @@ static unsigned long stack_maxrandom_size(void)
  * Leave an at least ~128 MB hole with possible stack randomization.
  */
 #define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
-#define MAX_GAP (TASK_SIZE/6*5)
+#define MAX_GAP (DEFAULT_MAP_WINDOW/6*5)
 
 static int mmap_is_legacy(void)
 {
@@ -90,7 +90,7 @@ static unsigned long mmap_base(unsigned long rnd)
 	else if (gap > MAX_GAP)
 		gap = MAX_GAP;
 
-	return PAGE_ALIGN(TASK_SIZE - gap - rnd);
+	return PAGE_ALIGN(DEFAULT_MAP_WINDOW - gap - rnd);
 }
 
 /*
diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index af59f808742f..794b26661711 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -354,10 +354,19 @@ int mpx_enable_management(void)
 	 */
 	bd_base = mpx_get_bounds_dir();
 	down_write(&mm->mmap_sem);
+
+	/* MPX doesn't support addresses above 47-bits yet. */
+	if (find_vma(mm, DEFAULT_MAP_WINDOW)) {
+		pr_warn_once("%s (%d): MPX cannot handle addresses "
+				"above 47-bits. Disabling.",
+				current->comm, current->pid);
+		ret = -ENXIO;
+		goto out;
+	}
 	mm->context.bd_addr = bd_base;
 	if (mm->context.bd_addr == MPX_INVALID_BOUNDS_DIR)
 		ret = -ENXIO;
-
+out:
 	up_write(&mm->mmap_sem);
 	return ret;
 }
@@ -1037,3 +1046,20 @@ void mpx_notify_unmap(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (ret)
 		force_sig(SIGSEGV, current);
 }
+
+/* MPX cannot handle addresses above 47-bits yet. */
+unsigned long mpx_unmapped_area_check(unsigned long addr, unsigned long len,
+		unsigned long flags)
+{
+	if (!kernel_managing_mpx_tables(current->mm))
+		return addr;
+	if (addr + len <= DEFAULT_MAP_WINDOW)
+		return addr;
+	if (flags & MAP_FIXED)
+		return -ENOMEM;
+	if (len > DEFAULT_MAP_WINDOW)
+		return -ENOMEM;
+
+	/* Look for unmap area within DEFAULT_MAP_WINDOW */
+	return 0;
+}
-- 
 Kirill A. Shutemov
