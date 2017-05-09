From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] selftests/vm: Fix test for virtual address range mapping for arm64
Date: Tue,  9 May 2017 21:00:47 +0200
Message-ID: <20170509190047.9271-1-msuchanek@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, Michal Suchanek <msuchanek@suse.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Arm64 has 256TB address space so fix the test to pass on Arm as well.

Also remove unneeded numaif include.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 tools/testing/selftests/vm/virtual_address_range.c | 36 ++++++++++++++++------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/vm/virtual_address_range.c b/tools/testing/selftests/vm/virtual_address_range.c
index 3b02aa6..ff6628f 100644
--- a/tools/testing/selftests/vm/virtual_address_range.c
+++ b/tools/testing/selftests/vm/virtual_address_range.c
@@ -10,7 +10,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <errno.h>
-#include <numaif.h>
 #include <sys/mman.h>
 #include <sys/time.h>
 
@@ -32,15 +31,34 @@
  * different areas one below 128TB and one above 128TB
  * till it reaches 512TB. One with size 128TB and the
  * other being 384TB.
+ *
+ * On Arm64 the address space is 256TB and no high mappings
+ * are supported so far. Presumably support can be added in
+ * the future.
  */
+
 #define NR_CHUNKS_128TB   8192UL /* Number of 16GB chunks for 128TB */
-#define NR_CHUNKS_384TB  24576UL /* Number of 16GB chunks for 384TB */
+#define NR_CHUNKS_256TB   (NR_CHUNKS_128TB * 2UL)
+#define NR_CHUNKS_384TB   (NR_CHUNKS_128TB * 3UL)
 
 #define ADDR_MARK_128TB  (1UL << 47) /* First address beyond 128TB */
+#define ADDR_MARK_256TB  (1UL << 48) /* First address beyond 256TB */
+
+#ifdef __aarch64__
+#define HIGH_ADDR_MARK  ADDR_MARK_256TB
+#define HIGH_ADDR_SHIFT 49
+#define NR_CHUNKS_LOW   NR_CHUNKS_256TB
+#define NR_CHUNKS_HIGH  NR_CHUNKS_256TB
+#else
+#define HIGH_ADDR_MARK  ADDR_MARK_128TB
+#define HIGH_ADDR_SHIFT 48
+#define NR_CHUNKS_LOW   NR_CHUNKS_128TB
+#define NR_CHUNKS_HIGH  NR_CHUNKS_384TB
+#endif
 
 static char *hind_addr(void)
 {
-	int bits = 48 + rand() % 15;
+	int bits = HIGH_ADDR_SHIFT + rand() % 15;
 
 	return (char *) (1UL << bits);
 }
@@ -50,14 +68,14 @@ static int validate_addr(char *ptr, int high_addr)
 	unsigned long addr = (unsigned long) ptr;
 
 	if (high_addr) {
-		if (addr < ADDR_MARK_128TB) {
+		if (addr < HIGH_ADDR_MARK) {
 			printf("Bad address %lx\n", addr);
 			return 1;
 		}
 		return 0;
 	}
 
-	if (addr > ADDR_MARK_128TB) {
+	if (addr > HIGH_ADDR_MARK) {
 		printf("Bad address %lx\n", addr);
 		return 1;
 	}
@@ -79,12 +97,12 @@ static int validate_lower_address_hint(void)
 
 int main(int argc, char *argv[])
 {
-	char *ptr[NR_CHUNKS_128TB];
-	char *hptr[NR_CHUNKS_384TB];
+	char *ptr[NR_CHUNKS_LOW];
+	char *hptr[NR_CHUNKS_HIGH];
 	char *hint;
 	unsigned long i, lchunks, hchunks;
 
-	for (i = 0; i < NR_CHUNKS_128TB; i++) {
+	for (i = 0; i < NR_CHUNKS_LOW; i++) {
 		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
 					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
@@ -99,7 +117,7 @@ int main(int argc, char *argv[])
 	}
 	lchunks = i;
 
-	for (i = 0; i < NR_CHUNKS_384TB; i++) {
+	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
 		hint = hind_addr();
 		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
 					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-- 
2.10.2
