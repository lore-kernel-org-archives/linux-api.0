From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 10/23] mm: Introduce vm_map_user_ram, vm_unmap_user_ram
Date: Thu, 12 Apr 2018 15:27:47 -0400
Message-ID: <20180412192800.15708-11-mathieu.desnoyers@efficios.com>
References: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412192800.15708-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
CC: Andrew Hunter <ahh@google.com>
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
 include/linux/vmalloc.h |  4 +++
 mm/vmalloc.c            | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 1e5d8c392f15..d5e5c11ba947 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -58,6 +58,10 @@ struct vmap_area {
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
index ebff729cc956..ae033b825e45 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1199,6 +1199,72 @@ void *vm_map_ram(struct page **pages, unsigned int count, int node, pgprot_t pro
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
+	BUG_ON(!addr);
+	BUG_ON(addr < VMALLOC_START);
+	BUG_ON(addr > VMALLOC_END);
+	BUG_ON(!PAGE_ALIGNED(addr));
+
+	debug_check_no_locks_freed(mem, size);
+	vmap_debug_free_range(addr, addr+size);
+
+	va = find_vmap_area(addr);
+	BUG_ON(!va);
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
