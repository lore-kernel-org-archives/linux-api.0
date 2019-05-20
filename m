From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v2 4/7] mm: Export round_hint_to_min()
Date: Mon, 20 May 2019 17:00:23 +0300
Message-ID: <155836082337.2441.15115541609966690918.stgit@localhost.localdomain>
References: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155836064844.2441.10911127801797083064.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, ktkhai@virtuozzo.com, mhocko@suse.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, alexander.h.duyck@linux.intel.com, ira.weiny@intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, jannh@google.com, kilobyte@angband.pl, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 include/linux/mman.h |   14 ++++++++++++++
 mm/mmap.c            |   13 -------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/mman.h b/include/linux/mman.h
index 4b08e9c9c538..69feb3144c12 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -4,6 +4,7 @@
 
 #include <linux/mm.h>
 #include <linux/percpu_counter.h>
+#include <linux/security.h>
 
 #include <linux/atomic.h>
 #include <uapi/linux/mman.h>
@@ -73,6 +74,19 @@ static inline void vm_unacct_memory(long pages)
 	vm_acct_memory(-pages);
 }
 
+/*
+ * If a hint addr is less than mmap_min_addr change hint to be as
+ * low as possible but still greater than mmap_min_addr
+ */
+static inline unsigned long round_hint_to_min(unsigned long hint)
+{
+	hint &= PAGE_MASK;
+	if (((void *)hint != NULL) &&
+	    (hint < mmap_min_addr))
+		return PAGE_ALIGN(mmap_min_addr);
+	return hint;
+}
+
 /*
  * Allow architectures to handle additional protection bits
  */
diff --git a/mm/mmap.c b/mm/mmap.c
index 99778e724ad1..e4ced5366643 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1318,19 +1318,6 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 	return NULL;
 }
 
-/*
- * If a hint addr is less than mmap_min_addr change hint to be as
- * low as possible but still greater than mmap_min_addr
- */
-static inline unsigned long round_hint_to_min(unsigned long hint)
-{
-	hint &= PAGE_MASK;
-	if (((void *)hint != NULL) &&
-	    (hint < mmap_min_addr))
-		return PAGE_ALIGN(mmap_min_addr);
-	return hint;
-}
-
 static inline int mlock_future_check(struct mm_struct *mm,
 				     unsigned long flags,
 				     unsigned long len)
