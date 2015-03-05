From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 06/21] userfaultfd: add VM_UFFD_MISSING and
	VM_UFFD_WP
Date: Thu,  5 Mar 2015 18:17:49 +0100
Message-ID: <1425575884-2574-7-git-send-email-aarcange@redhat.com>
References: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Android Kernel Team <kernel-team@android.com>
Cc: Robert Love <rlove@google.com>, Dave Hansen <dave@sr71.net>, Jan Kara <jack@suse.cz>, Neil Brown <neilb@suse.de>, Stefan Hajnoczi <stefanha@gmail.com>, Andrew Jones <drjones@redhat.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Michel Lespinasse <walken@google.com>, Taras Glek <tglek@mozilla.com>, zhang.zhanghailiang@huawei.com, Pavel Emelyanov <xemul@parallels.com>, Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, Andres Lagar-Cavilla <andreslc@google.com>, Christopher Covington <cov@codeaurora.org>, Anthony Liguori <anthony@codemonkey.ws>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Keith Packard <keithp@keithp.com>, Wenchao
List-Id: linux-api@vger.kernel.org

These two flags gets set in vma->vm_flags to tell the VM common code
if the userfaultfd is armed and in which mode (only tracking missing
faults, only tracking wrprotect faults or both). If neither flags is
set it means the userfaultfd is not armed on the vma.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/mm.h | 2 ++
 kernel/fork.c      | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 47a9392..762ef9d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -123,8 +123,10 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_MAYSHARE	0x00000080
 
 #define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
+#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
diff --git a/kernel/fork.c b/kernel/fork.c
index cb215c0..cfab6e9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -423,7 +423,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		tmp->vm_mm = mm;
 		if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~VM_LOCKED;
+		tmp->vm_flags &= ~(VM_LOCKED|VM_UFFD_MISSING|VM_UFFD_WP);
 		tmp->vm_next = tmp->vm_prev = NULL;
 		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 		file = tmp->vm_file;
