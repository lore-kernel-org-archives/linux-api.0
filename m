From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 05/23] userfaultfd: add vm_userfaultfd_ctx to the vm_area_struct
Date: Thu, 14 May 2015 19:31:02 +0200
Message-ID: <1431624680-20153-6-git-send-email-aarcange@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-api@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
List-Id: linux-api@vger.kernel.org

This adds the vm_userfaultfd_ctx to the vm_area_struct.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/mm_types.h | 11 +++++++++++
 kernel/fork.c            |  1 +
 2 files changed, 12 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 0038ac7..2836da7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -265,6 +265,16 @@ struct vm_region {
 						* this region */
 };
 
+#ifdef CONFIG_USERFAULTFD
+#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) { NULL, })
+struct vm_userfaultfd_ctx {
+	struct userfaultfd_ctx *ctx;
+};
+#else /* CONFIG_USERFAULTFD */
+#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) {})
+struct vm_userfaultfd_ctx {};
+#endif /* CONFIG_USERFAULTFD */
+
 /*
  * This struct defines a memory VMM memory area. There is one of these
  * per VM-area/task.  A VM area is any part of the process virtual memory
@@ -331,6 +341,7 @@ struct vm_area_struct {
 #ifdef CONFIG_NUMA
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
+	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
 };
 
 struct core_thread {
diff --git a/kernel/fork.c b/kernel/fork.c
index 1481cdd..430141b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -451,6 +451,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~VM_LOCKED;
 		tmp->vm_next = tmp->vm_prev = NULL;
+		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
 		if (file) {
 			struct inode *inode = file_inode(file);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
