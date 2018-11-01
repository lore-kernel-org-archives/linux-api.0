From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 04/16] mm: Introduce vm_map_user_ram, vm_unmap_user_ram (v2)
Date: Thu,  1 Nov 2018 10:58:32 +0100
Message-ID: <20181101095844.24462-5-mathieu.desnoyers@efficios.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

Create and destroy mappings aliased to a user-space mapping with the same
cache coloring as the userspace mapping. Allow the kernel to load from
and store to pages shared with user-space through its own mapping in
kernel virtual addresses while ensuring cache conherency between kernel
and userspace mappings for virtually aliased architectures.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Boqun Feng <boqun.feng@gmail.com>
---
Changes since v1:
- Use WARN_ON() rather than BUG_ON().
---
 include/linux/vmalloc.h |  4 +++
 mm/vmalloc.c            | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 398e9c95cd61..899657b3d469 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -59,6 +59,10 @@ struct vmap_area {
 extern void vm_unmap_ram(const void *mem, unsigned int count);
 extern void *vm_map_ram(struct page **pages, unsigned int count,
 				int node, pgprot_t prot);
+extern void vm_unmap_user_ram(const void *mem, unsigned int count);
+extern void *vm_map_user_ram(struct page **pages, unsigned int count,
+				unsigned long uaddr, int node, pgprot_t prot);
+
 extern void vm_unmap_aliases(void);
 
 #ifdef CONFIG_MMU
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a236bac872f0..8df3c572036c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1188,6 +1188,72 @@ void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t pro
 }
 EXPORT_SYMBOL(vm_map_ram);
 
+/**
+ * vm_unmap_user_ram - unmap linear kernel address space set up by vm_map_user_ram
+ * @mem: the pointer returned by vm_map_user_ram
+ * @count: the count passed to that vm_map_user_ram call (cannot unmap partial)
+ */
+void vm_unmap_user_ram(const void *mem, unsigned int count)
+{
+	unsigned long size = (unsigned long)count << PAGE_SHIFT;
+	unsigned long addr = (unsigned long)mem;
+	struct vmap_area *va;
+
+	might_sleep();
+	if (WARN_ON(!addr) ||
+	    WARN_ON(addr < VMALLOC_START) ||
+	    WARN_ON(addr > VMALLOC_END) ||
+	    WARN_ON(!PAGE_ALIGNED(addr)))
+		return;
+
+	debug_check_no_locks_freed(mem, size);
+	va = find_vmap_area(addr);
+	if (WARN_ON(!va))
+		return;
+	free_unmap_vmap_area(va);
+}
+EXPORT_SYMBOL(vm_unmap_user_ram);
+
+/**
+ * vm_map_user_ram - map user space pages linearly into kernel virtual address
+ * @pages: an array of pointers to the virtually contiguous pages to be mapped
+ * @count: number of pages
+ * @uaddr: address within the first page in the userspace mapping
+ * @node: prefer to allocate data structures on this node
+ * @prot: memory protection to use. PAGE_KERNEL for regular RAM
+ *
+ * Create a mapping aliased to a user-space mapping with the same cache
+ * coloring as the userspace mapping. Allow the kernel to load from and
+ * store to pages shared with user-space through its own mapping in kernel
+ * virtual addresses while ensuring cache conherency between kernel and
+ * userspace mappings for virtually aliased architectures.
+ *
+ * Returns: a pointer to the address that has been mapped, or %NULL on failure
+ */
+void *vm_map_user_ram(struct page **pages, unsigned int count,
+		unsigned long uaddr, int node, pgprot_t prot)
+{
+	unsigned long size = (unsigned long)count << PAGE_SHIFT;
+	unsigned long va_offset = ALIGN_DOWN(uaddr, PAGE_SIZE) & (SHMLBA - 1);
+	unsigned long alloc_size = ALIGN(va_offset + size, SHMLBA);
+	struct vmap_area *va;
+	unsigned long addr;
+	void *mem;
+
+	va = alloc_vmap_area(alloc_size, SHMLBA, VMALLOC_START, VMALLOC_END,
+			node, GFP_KERNEL);
+	if (IS_ERR(va))
+		return NULL;
+	addr = va->va_start + va_offset;
+	mem = (void *)addr;
+	if (vmap_page_range(addr, addr + size, prot, pages) < 0) {
+		vm_unmap_user_ram(mem, count);
+		return NULL;
+	}
+	return mem;
+}
+EXPORT_SYMBOL(vm_map_user_ram);
+
 static struct vm_struct *vmlist __initdata;
 /**
  * vm_area_add_early - add vmap area early during boot
-- 
2.11.0
