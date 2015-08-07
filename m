From: Thierry Reding <thierry.reding-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] selftests: vm: Fix mlock2-tests for 32-bit architectures
Date: Fri,  7 Aug 2015 15:44:12 +0200
Message-ID: <1438955055-587-1-git-send-email-thierry.reding@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

According to Documentation/vm/pagemap.txt, the /proc/pid/pagemap file
contains one 64-bit value for each virtual page. The test code relies
on the size of unsigned long being 64-bit, which breaks the test when
run on 32-bit architectures. Use a uint64_t to store values read from
the file instead, so that it works irrespective of the architecture's
word size.

Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/vm/mlock2-tests.c | 33 +++++++++++++------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/vm/mlock2-tests.c b/tools/testing/selftests/vm/mlock2-tests.c
index c49122bebf3c..11c38e96f336 100644
--- a/tools/testing/selftests/vm/mlock2-tests.c
+++ b/tools/testing/selftests/vm/mlock2-tests.c
@@ -1,4 +1,5 @@
 #include <sys/mman.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -82,10 +83,10 @@ out:
 	return ret;
 }
 
-static unsigned long get_pageflags(unsigned long addr)
+static uint64_t get_pageflags(unsigned long addr)
 {
 	FILE *file;
-	unsigned long pfn;
+	uint64_t pfn;
 	unsigned long offset;
 
 	file = fopen("/proc/self/pagemap", "r");
@@ -94,13 +95,14 @@ static unsigned long get_pageflags(unsigned long addr)
 		_exit(1);
 	}
 
-	offset = addr / getpagesize() * sizeof(unsigned long);
+	offset = addr / getpagesize() * sizeof(pfn);
+
 	if (fseek(file, offset, SEEK_SET)) {
 		perror("fseek pagemap");
 		_exit(1);
 	}
 
-	if (fread(&pfn, sizeof(unsigned long), 1, file) != 1) {
+	if (fread(&pfn, sizeof(pfn), 1, file) != 1) {
 		perror("fread pagemap");
 		_exit(1);
 	}
@@ -111,7 +113,7 @@ static unsigned long get_pageflags(unsigned long addr)
 
 static unsigned long get_kpageflags(unsigned long pfn)
 {
-	unsigned long flags;
+	uint64_t flags;
 	FILE *file;
 
 	file = fopen("/proc/kpageflags", "r");
@@ -120,12 +122,12 @@ static unsigned long get_kpageflags(unsigned long pfn)
 		_exit(1);
 	}
 
-	if (fseek(file, pfn * sizeof(unsigned long), SEEK_SET)) {
+	if (fseek(file, pfn * sizeof(flags), SEEK_SET)) {
 		perror("fseek kpageflags");
 		_exit(1);
 	}
 
-	if (fread(&flags, sizeof(unsigned long), 1, file) != 1) {
+	if (fread(&flags, sizeof(flags), 1, file) != 1) {
 		perror("fread kpageflags");
 		_exit(1);
 	}
@@ -211,9 +213,8 @@ out:
 
 static int lock_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
@@ -246,9 +247,8 @@ static int lock_check(char *map)
 
 static int unlock_lock_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
@@ -310,9 +310,8 @@ out:
 
 static int onfault_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page2_flags = get_pageflags((unsigned long)map + page_size);
@@ -355,9 +354,8 @@ static int onfault_check(char *map)
 
 static int unlock_onfault_check(char *map)
 {
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags;
 
 	page1_flags = get_pageflags((unsigned long)map);
 	page1_flags = get_kpageflags(page1_flags & PFN_MASK);
@@ -422,9 +420,8 @@ static int test_lock_onfault_of_present()
 {
 	char *map;
 	int ret = 1;
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
+	uint64_t page1_flags, page2_flags;
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
 		   MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
@@ -471,8 +468,6 @@ static int test_munlockall()
 {
 	char *map;
 	int ret = 1;
-	unsigned long page1_flags;
-	unsigned long page2_flags;
 	unsigned long page_size = getpagesize();
 
 	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
-- 
2.4.5
