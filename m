From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 03/17] mm: gup: use get_user_pages_unlocked within get_user_pages_fast
Date: Fri,  3 Oct 2014 19:07:53 +0200
Message-ID: <1412356087-16115-4-git-send-email-aarcange@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Android Kernel Team <kernel-team@android.com>, Robert Love <rlove@google.com>, Dmitry Adamushko <dmitry.adamushko@gmail.com>, Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>, Jan Kara <jac>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/mips/mm/gup.c       | 8 +++-----
 arch/powerpc/mm/gup.c    | 6 ++----
 arch/s390/kvm/kvm-s390.c | 4 +---
 arch/s390/mm/gup.c       | 6 ++----
 arch/sh/mm/gup.c         | 6 ++----
 arch/sparc/mm/gup.c      | 6 ++----
 arch/x86/mm/gup.c        | 7 +++----
 7 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index 06ce17c..20884f5 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -301,11 +301,9 @@ slow_irqon:
 	start += nr << PAGE_SHIFT;
 	pages += nr;
 
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start,
-				(end - start) >> PAGE_SHIFT,
-				write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
+	ret = get_user_pages_unlocked(current, mm, start,
+				      (end - start) >> PAGE_SHIFT,
+				      write, 0, pages);
 
 	/* Have to be a bit careful with return values */
 	if (nr > 0) {
diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index d874668..b70c34a 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -215,10 +215,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-				     nr_pages - nr, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+					      nr_pages - nr, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 81b0e11..37ca29a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1092,9 +1092,7 @@ long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable)
 	hva = gmap_fault(gpa, vcpu->arch.gmap);
 	if (IS_ERR_VALUE(hva))
 		return (long)hva;
-	down_read(&mm->mmap_sem);
-	rc = get_user_pages(current, mm, hva, 1, writable, 0, NULL, NULL);
-	up_read(&mm->mmap_sem);
+	rc = get_user_pages_unlocked(current, mm, hva, 1, writable, 0, NULL);
 
 	return rc < 0 ? rc : 0;
 }
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 639fce46..5c586c7 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -235,10 +235,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	/* Try to get the remaining pages with get_user_pages */
 	start += nr << PAGE_SHIFT;
 	pages += nr;
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start,
-			     nr_pages - nr, write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
+	ret = get_user_pages_unlocked(current, mm, start,
+			     nr_pages - nr, write, 0, pages);
 	/* Have to be a bit careful with return values */
 	if (nr > 0)
 		ret = (ret < 0) ? nr : ret + nr;
diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
index 37458f3..e15f52a 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -257,10 +257,8 @@ slow_irqon:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+			(end - start) >> PAGE_SHIFT, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index 1aed043..fa7de7d 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -219,10 +219,8 @@ slow:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+			(end - start) >> PAGE_SHIFT, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 207d9aef..2ab183b 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -388,10 +388,9 @@ slow_irqon:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+					      (end - start) >> PAGE_SHIFT,
+					      write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
