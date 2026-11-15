Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794758475;
	b=FYYFSJj8nFlDQLf89Jsl6zclNyv98ipuhHvHwVaxPv9rlUlfHbkLn6+h5vbYx9fAQHwI
	 qm4L14sN4jjbnDlWPycU4hGAInFdSbzRiyNv+qD/7Hk4+dR72FM56cLJz8rxuxAXNFTbx
	 B9uhk5ZgsIo3rqpF3tstEVxiLP9d6DLSNP80m0WH5CMKs6sm/b1FnP9+w7EzOvofMF7IB
	 Nwf0RIJwCaz+CFWR4ZHCrUs9eZCdl+k2LoQSKEjE+lXfHFuU5C5Z3xTtrQrBCvZhXw+n/
	 SaP2ylBEMoQ6xeoKdU9bEbiUBxo1CjDOE0faO29LGmGuNMaTaxvKZadnYqba3FQGgaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794758475;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Kj5cOFjcYI4tFTJJsY4Uv8uB18SZbYD+rdOQRKLJNMQ=;
	b=oOhd825xVam/3Q2SIvqcBLnPJCniX+74Xkm05aDbT1FzJTd5oj8Gc5Hi/yvvA4fU137v
	 bur4VoVpPl7UKFmX1to/u5oJn3U4FeBo2+YKn73SoB/TtvYHlBLwW7SXqnWg8jNmsJsjZ
	 eJpe0ERsc4TwdNBn0QLV6RBt6b1ECgKiQ2YNqm8HTkd5hLa3Xcl/VtViQPqC5j/wd3+D5
	 LSAHj70gCLACrr/yXoY06Q2WBWKBQBIu9+Aqq8+5V9BiPE5UbwNdmZ61sk97Hksk+CMrN
	 9NoYn2XsSFsNumhX7IXFTI5RdmT6wVhmmkDKJ14wdarpWB1QCqdQYxLjaoGWOU0ryoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YzTqVchL;
	arc=none smtp.remote-ip=209.85.214.200
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64978606A897
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 16:01:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64978606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YzTqVchL
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ee04c49451so37836995ad.2
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 08:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794758473; x=1795363273; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kj5cOFjcYI4tFTJJsY4Uv8uB18SZbYD+rdOQRKLJNMQ=;
        b=YzTqVchL00k/nJJZnFd0GNfE8D7Qak1nrPGuUVL0zbxU5/0zZdpMHsbWImHtjxZJpc
         +emGvhQJWSR1RxMB4YJF8wyAyCTBBIxenEWMY8iq7llj/K8FZtnfIg58z2Ui7vm/QeCv
         exsXqkp3XVlq6Hytbb03C5rvq3CyIcsiuQGHkwbWdinrd/j6jFo2G2lhpgKuEqPMjCNE
         cndzH8T0lexMxVcLK56sLnInW119vWsA4wrQL5+yfVJIM2QfDFpT2D4cTc4gjni9OsOY
         3MN6Eb3ZINNLEFxJPH5YSzSznQx/4ExvN7y4rONxuRtev0kJafOABE8W8WsrEY3YmZk4
         cEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794758473; x=1795363273;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kj5cOFjcYI4tFTJJsY4Uv8uB18SZbYD+rdOQRKLJNMQ=;
        b=XLkfHUgyM+49B6uTyVqOgillSZcLq/ycsprALqXCESOzUN5Z3H2sB4utK0Szfrb+em
         Eso6vyLupOBFDdnDLxGzq3y6Ygo4MHXhnt6nZzp1Hhk1VNYOo62MB812Xz5KsV0TUWEF
         RpyKmLN4H8MLLegKo3OEyMEdA2Kdt/tDHrB+jfYjLNDqz9hiz+Mk5HYdSQCdYnTI1ijT
         FgeLohlFFujg5lj1kamFSUO5mK5Fhu8jebSa/TNE4R2r3YI2iG8mdrEovyy9fppKD3ow
         qUOMRRw9P/TUeazBIQrBw/r0twpQfNQ5+0nrOH6OZo76mX9+uPFdDtny8yAvc7k4OJZx
         zbSg==
X-Forwarded-Encrypted: i=1; AL+hErHXgxapjsW71ojy2miIWBJpojraMJWTAw4BpxJ/C4fsbXhPJX3UpOXJCIH93m4kgAw22MXAg0eFgRs=@vger.kernel.org
X-Gm-Message-State: APuU4Z90Lnl7l6LsgHzZcA8l0e+I85pPlMh3iQZ66xeDErnE4pkQQjbj
	ycq0jx1Q1IYG2Bs3nPBZ1KZ3drJXKkrZh/hzIXWfjCBeWtAwEti88NgKUJy8zRjIVvQvqB052s9
	DciYJgcOtZ9RO7A==
X-Received: from plnx11.prod.google.com ([2002:a17:902:820b:b0:2e1:2a71:d15b])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:fc4e:b0:2e9:66f6:7894 with SMTP id d9443c01a7336-2ee0dc2e2b8mr82014535ad.40.1794758472395;
 Sun, 15 Nov 2026 08:01:12 -0800 (PST)
Date: Sun, 15 Nov 2026 16:01:04 +0000
In-Reply-To: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261115160105.2507650-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261115160105.2507650-3-jiaqiyan@google.com>
Subject: [PATCH v4 2/3] selftests/mm: test userspace MFR for HugeTLB hugepage
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, muchun.song@linux.dev
Cc: nao.horiguchi@gmail.com, william.roche@oracle.com, ljs@kernel.org, 
	vbabka@kernel.org, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, skhan@linuxfoundation.org, 
	corbet@lwn.net, david@kernel.org, dave.hansen@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Test the userspace memory failure recovery (MFR) policy for HugeTLB:

1. Create a memfd backed by HugeTLB and MFD_MF_KEEP_UE_MAPPED bit set.

2. Allocate and map 4 hugepages, and fill them with data.

3. Create sub-threads to inject memory errors at inner addresses of
   the 1st hugepage.

4. Check if each sub-thread gets correct SIGBUS for the poisoned raw page.

5. Check if all memory is still accessible and content still valid.

6. Optionally seal the memfd, before and after injecting errors.

7. Check if the poisoned hugepage is dissolved after the memfd is
   truncated or closed, and only its raw HWPoison pages are isolated.

8. Unpoison the raw HWPoison pages.

Configurables in the test:

- hugepage_size: size of the hugepage, 1G (default) or 2M.

- nr_hwp_pages: number of raw pages within the 1st hugepage to poison,
  1 to 8 (default 8).

- inject_method: how memory errors are injected.
  - corrupt-pfn (default): write the PFN to hwpoison_inject's
    corrupt-pfn, which calls memory_failure() without
    MF_COUNT_INCREASED, like a real action optional error. The
    injecting thread opts in to early kill and gets SIGBUS with
    BUS_MCEERR_AO.
  - madvise: MADV_HWPOISON, which calls memory_failure() with
    MF_ACTION_REQUIRED | MF_COUNT_INCREASED. The injecting thread gets
    SIGBUS with BUS_MCEERR_AR.

- release_method: how the HWPoison hugepage is released.
  - truncate (default): truncate the memfd to 0.
  - seal: model a sealed base image shared via MAP_PRIVATE. Before
    injecting errors, seal the memfd with F_SEAL_SHRINK | F_SEAL_GROW |
    F_SEAL_FUTURE_WRITE, and replace the writable shared mapping with a
    read-only private one, through which errors are injected. After
    injecting errors, seal the memfd with F_SEAL_WRITE | F_SEAL_EXEC |
    F_SEAL_SEAL, check that the seals are enforced and the memfd is
    still readable, then close it. Adding F_SEAL_WRITE needs the folio
    to have no refcount other than the page cache and page tables, so
    it checks that memory_failure() didn't leave one behind.

The test needs root, and the hwpoison_inject module for corrupt-pfn
and unpoisoning. It sets up the HugeTLB pages it needs, and restores
the original HugeTLB settings when it exits. run_vmtests.sh runs it
under the memory-failure category.

The test code is heavily re-written by an AI assistant based on the
original code I wrote from scratch [1]. I reviewed and tested AI's
new code.

[1] https://lore.kernel.org/linux-mm/20260203192352.2674184-3-jiaqiyan@google.com/

Assisted-by: Antigravity:claude-opus-5-5
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/hugetlb-mfr.c  | 704 ++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 3 files changed, 706 insertions(+)
 create mode 100644 tools/testing/selftests/mm/hugetlb-mfr.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 675ec57d47de..c25a4048fc1c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -62,6 +62,7 @@ TEST_GEN_FILES += gup
 TEST_GEN_FILES += gup_longterm
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
+TEST_GEN_FILES += hugetlb-mfr
 TEST_GEN_FILES += hugetlb-mmap
 TEST_GEN_FILES += hugetlb-mremap
 TEST_GEN_FILES += hugetlb-read-hwpoison
diff --git a/tools/testing/selftests/mm/hugetlb-mfr.c b/tools/testing/selftests/mm/hugetlb-mfr.c
new file mode 100644
index 000000000000..c591160f3b2a
--- /dev/null
+++ b/tools/testing/selftests/mm/hugetlb-mfr.c
@@ -0,0 +1,704 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Test the userspace memory failure recovery (MFR) policy for HugeTLB
+ * hugepage case:
+ * 1. Create a memfd backed by HugeTLB and MFD_MF_KEEP_UE_MAPPED bit set.
+ * 2. Allocate and map 4 hugepages, and fill them with data.
+ * 3. Create sub-threads to inject memory errors at inner addresses of
+ *    the 1st hugepage.
+ * 4. Check if each sub-thread gets correct SIGBUS for the poisoned raw page.
+ * 5. Check if all memory is still accessible and content still valid.
+ * 6. Optionally seal the memfd, before and after injecting errors.
+ * 7. Check if the poisoned hugepage is dissolved after the memfd is
+ *    truncated or closed, and only its raw HWPoison pages are isolated.
+ * 8. Unpoison the raw HWPoison pages.
+ *
+ * Usage: hugetlb-mfr [hugepage_size] [nr_hwp_pages] [inject_method]
+ *                    [release_method]
+ * - hugepage_size: size of the hugepage, 1G (default) or 2M.
+ * - nr_hwp_pages: number of raw pages within the 1st hugepage to poison,
+ *   1 to 8 (default 8).
+ * - inject_method: how memory errors are injected.
+ *   - corrupt-pfn (default): write the PFN to hwpoison_inject's
+ *     corrupt-pfn, which calls memory_failure() without
+ *     MF_COUNT_INCREASED, like a real action optional error. The
+ *     injecting thread opts in to early kill and gets SIGBUS with
+ *     BUS_MCEERR_AO.
+ *   - madvise: MADV_HWPOISON, which calls memory_failure() with
+ *     MF_ACTION_REQUIRED | MF_COUNT_INCREASED. The injecting thread gets
+ *     SIGBUS with BUS_MCEERR_AR.
+ * - release_method: how the HWPoison hugepage is released.
+ *   - truncate (default): truncate the memfd to 0.
+ *   - seal: model a sealed base image shared via MAP_PRIVATE. Before
+ *     injecting errors, seal the memfd with F_SEAL_SHRINK | F_SEAL_GROW |
+ *     F_SEAL_FUTURE_WRITE, and replace the writable shared mapping with a
+ *     read-only private one, through which errors are injected. After
+ *     injecting errors, seal the memfd with F_SEAL_WRITE | F_SEAL_EXEC |
+ *     F_SEAL_SEAL, check that the seals are enforced and the memfd is
+ *     still readable, then close it. Adding F_SEAL_WRITE needs the folio
+ *     to have no refcount other than the page cache and page tables, so
+ *     it also checks that memory_failure() didn't leave one behind.
+ *
+ * The test needs root, and the hwpoison_inject module for corrupt-pfn
+ * and for unpoisoning. HugeTLB pages are set up by the test, and the
+ * original HugeTLB settings are restored when the test exits.
+ */
+
+#define _GNU_SOURCE
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <linux/falloc.h>
+#include <linux/magic.h>
+#include <linux/memfd.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/statfs.h>
+#include <sys/types.h>
+
+#include "../kselftest.h"
+#include "vm_util.h"
+
+#define HUGEPAGE_SIZE_1G	(1UL << 30)
+#define HUGEPAGE_SIZE_2M	(1UL << 21)
+#define NR_HUGEPAGES		4
+#define HUGETLB_FILL		0xab
+
+#ifndef MFD_MF_KEEP_UE_MAPPED
+#define MFD_MF_KEEP_UE_MAPPED	0x0020U
+#endif
+
+#ifndef F_SEAL_FUTURE_WRITE
+#define F_SEAL_FUTURE_WRITE	0x0010
+#endif
+
+#ifndef F_SEAL_EXEC
+#define F_SEAL_EXEC		0x0020
+#endif
+
+/* Seals of a base image that is still being populated by its owner. */
+#define SEALS_BEFORE_ERRORS	(F_SEAL_SHRINK | F_SEAL_GROW | \
+				 F_SEAL_FUTURE_WRITE)
+/*
+ * F_SEAL_EXEC implies F_SEAL_WRITE if the memfd has exec bits, so it has
+ * to wait until after injecting errors too.
+ */
+#define SEALS_AFTER_ERRORS	(F_SEAL_WRITE | F_SEAL_EXEC | F_SEAL_SEAL)
+#define SEALS_ALL		(SEALS_BEFORE_ERRORS | SEALS_AFTER_ERRORS)
+
+#define INJECT_MADVISE_STR	"madvise"
+#define RELEASE_TRUNCATE_STR	"truncate"
+#define RELEASE_SEAL_STR	"seal"
+#define INJECT_CORRUPT_PFN_STR	"corrupt-pfn"
+#define CORRUPT_PFN_DEBUGFS	"/sys/kernel/debug/hwpoison/corrupt-pfn"
+#define UNPOISON_PFN_DEBUGFS	"/sys/kernel/debug/hwpoison/unpoison-pfn"
+
+enum inject_method {
+	INJECT_MADVISE,
+	INJECT_CORRUPT_PFN,
+};
+
+enum release_method {
+	RELEASE_TRUNCATE,
+	RELEASE_SEAL,
+};
+
+static const unsigned long offsets_1g[] = {
+	0x200000, 0x3ff000, 0x801000, 0x2000000,
+	0x3fff000, 0x4001000, 0x7fff000, 0x3ffff000
+};
+
+static const unsigned long offsets_2m[] = {
+	0x020000, 0x041000, 0x07f000, 0x120000,
+	0x13f000, 0x141000, 0x17f000, 0x1ff000
+};
+
+static_assert(ARRAY_SIZE(offsets_1g) == ARRAY_SIZE(offsets_2m),
+	      "offsets_1g and offsets_2m must have the same size");
+#define MAX_NR_HWP_PAGES	ARRAY_SIZE(offsets_1g)
+
+static unsigned long hugepage_size = HUGEPAGE_SIZE_1G;
+static size_t nr_hwp_pages = MAX_NR_HWP_PAGES;
+static enum inject_method inject_method = INJECT_CORRUPT_PFN;
+static enum release_method release_method = RELEASE_TRUNCATE;
+
+static int pagemap_fd = -1;
+static int kpageflags_fd = -1;
+static unsigned long hwp_pfns[MAX_NR_HWP_PAGES];
+
+static void *sigbus_addr;
+static int sigbus_addr_lsb;
+static int sigbus_code;
+static bool expecting_sigbus;
+static bool got_sigbus;
+
+struct hwp_target {
+	void *addr;
+	unsigned long pfn;
+	int ret;
+};
+
+static int create_hugetlbfs_file(void)
+{
+	struct statfs file_stat = { 0 };
+	int flags = MFD_HUGETLB | MFD_MF_KEEP_UE_MAPPED | MFD_ALLOW_SEALING;
+	int fd;
+
+	if (hugepage_size == HUGEPAGE_SIZE_2M)
+		flags |= MFD_HUGE_2MB;
+	else
+		flags |= MFD_HUGE_1GB;
+
+	fd = memfd_create("hugetlb_tmp", flags);
+	if (fd < 0)
+		ksft_exit_fail_perror("Failed to memfd_create");
+
+	if (fstatfs(fd, &file_stat))
+		ksft_exit_fail_perror("Failed to fstatfs");
+	if (file_stat.f_type != HUGETLBFS_MAGIC)
+		ksft_exit_fail_msg("Not hugetlbfs file\n");
+	if (file_stat.f_bsize != hugepage_size)
+		ksft_exit_fail_msg("Hugepage size is %#lx, not %#lx\n",
+				   file_stat.f_bsize, hugepage_size);
+
+	return fd;
+}
+
+/*
+ * SIGBUS handler for the "do_hwpoison" thread that injected the memory error.
+ */
+static void sigbus_handler(int signo, siginfo_t *info, void *context)
+{
+	if (!expecting_sigbus)
+		ksft_exit_fail_msg("Unexpected SIGBUS with addr=%p\n",
+				   info->si_addr);
+
+	got_sigbus = true;
+	sigbus_code = info->si_code;
+	sigbus_addr = info->si_addr;
+	sigbus_addr_lsb = info->si_addr_lsb;
+}
+
+static int inject_corrupt_pfn(unsigned long pfn)
+{
+	char buf[64];
+	int fd, len, ret = 0;
+
+	/*
+	 * hwpoison_inject calls memory_failure() without MF_ACTION_REQUIRED,
+	 * so SIGBUS(BUS_MCEERR_AO) is only sent to a thread that opted in to
+	 * early kill. Opt in this thread so the signal comes back to it.
+	 */
+	if (prctl(PR_MCE_KILL, PR_MCE_KILL_SET, PR_MCE_KILL_EARLY, 0, 0) < 0)
+		return -errno;
+
+	fd = open(CORRUPT_PFN_DEBUGFS, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+
+	len = snprintf(buf, sizeof(buf), "%#lx\n", pfn);
+	if (write(fd, buf, len) != len)
+		ret = -errno;
+
+	close(fd);
+	return ret;
+}
+
+static void *do_hwpoison(void *arg)
+{
+	struct hwp_target *target = arg;
+
+	/*
+	 * Invoke memory_failure() the way a real memory error would. We
+	 * expect memory_failure() to return 0, so report failure if
+	 * madvise() or write() fails.
+	 */
+	if (inject_method == INJECT_CORRUPT_PFN) {
+		ksft_print_msg("Injecting corrupt-pfn=%#lx for vaddr=%p\n",
+			       target->pfn, target->addr);
+		target->ret = inject_corrupt_pfn(target->pfn);
+	} else {
+		ksft_print_msg("MADV_HWPOISON vaddr=%p (pfn=%#lx)\n",
+			       target->addr, target->pfn);
+		if (madvise(target->addr, getpagesize(), MADV_HWPOISON) < 0)
+			target->ret = -errno;
+	}
+
+	return NULL;
+}
+
+/* Poison one raw page and check the SIGBUS it gets. */
+static bool hwpoison_raw_page(void *addr, unsigned long pfn)
+{
+	const int expected_code = inject_method == INJECT_CORRUPT_PFN ?
+				  BUS_MCEERR_AO : BUS_MCEERR_AR;
+	struct hwp_target target = { .addr = addr, .pfn = pfn };
+	pthread_t pthread;
+
+	sigbus_addr = (void *)0xBADBADBAD;
+	sigbus_addr_lsb = 0;
+	sigbus_code = 0;
+	got_sigbus = false;
+	expecting_sigbus = true;
+
+	if (pthread_create(&pthread, NULL, do_hwpoison, &target))
+		ksft_exit_fail_perror("Failed to create hwpoison thread");
+	pthread_join(pthread, NULL);
+
+	expecting_sigbus = false;
+
+	if (target.ret) {
+		ksft_print_msg("Failed to inject error: %s\n",
+			       strerror(-target.ret));
+		return false;
+	}
+	if (!got_sigbus) {
+		ksft_print_msg("Didn't get a SIGBUS\n");
+		return false;
+	}
+	if (sigbus_code != expected_code) {
+		ksft_print_msg("Incorrect si_code: got=%d, expected=%d\n",
+			       sigbus_code, expected_code);
+		return false;
+	}
+	if (sigbus_addr != addr) {
+		ksft_print_msg("Incorrect si_addr: got=%p, expected=%p\n",
+			       sigbus_addr, addr);
+		return false;
+	}
+	if (sigbus_addr_lsb != pshift()) {
+		ksft_print_msg("Incorrect si_addr_lsb: got=%d, expected=%d\n",
+			       sigbus_addr_lsb, pshift());
+		return false;
+	}
+
+	return true;
+}
+
+static bool raw_pages_hwpoison(bool expected)
+{
+	uint64_t flags;
+	size_t i;
+
+	for (i = 0; i < nr_hwp_pages; ++i) {
+		if (pageflags_get(hwp_pfns[i], kpageflags_fd, &flags))
+			ksft_exit_fail_msg("Failed to read kpageflags\n");
+		if (!!(flags & KPF_HWPOISON) != expected) {
+			ksft_print_msg("pfn=%#lx: HWPoison is %s, expected %s\n",
+				       hwp_pfns[i],
+				       expected ? "clear" : "set",
+				       expected ? "set" : "clear");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static bool hardware_corrupted_is(unsigned long expected_kb)
+{
+	unsigned long size_kb;
+
+	if (get_hardware_corrupted_size(&size_kb))
+		ksft_exit_fail_msg("Failed to read HardwareCorrupted\n");
+	if (size_kb != expected_kb) {
+		ksft_print_msg("HardwareCorrupted: got=%lukB, expected=%lukB\n",
+			       size_kb, expected_kb);
+		return false;
+	}
+
+	return true;
+}
+
+static bool memory_intact(const unsigned char *map, unsigned long len)
+{
+	const unsigned char *iter;
+
+	for (iter = map; iter < map + len; ++iter) {
+		if (*iter != HUGETLB_FILL) {
+			ksft_print_msg("At addr=%p: got=%#x, expected=%#x\n",
+				       iter, *iter, HUGETLB_FILL);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/*
+ * Seal the memfd like the owner of a base image does before sharing it,
+ * then replace the writable shared mapping with a read-only private one,
+ * like the one a user of the base image has. Return the new mapping.
+ */
+static unsigned char *seal_before_errors(int fd, unsigned char *map,
+					 unsigned long len)
+{
+	unsigned long offset;
+
+	if (fcntl(fd, F_ADD_SEALS, SEALS_BEFORE_ERRORS))
+		ksft_exit_fail_perror("Failed to seal memfd before injecting errors");
+
+	munmap(map, len);
+	map = mmap(NULL, len, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_perror("Failed to mmap sealed memfd");
+
+	/* Fault in every hugepage so that pagemap can find its PFN. */
+	for (offset = 0; offset < len; offset += hugepage_size)
+		FORCE_READ(map[offset]);
+
+	return map;
+}
+
+/*
+ * Add the remaining seals to the memfd having HWPoison hugepage, then
+ * check that all seals are enforced and the HWPoison hugepage is still
+ * readable.
+ */
+static bool seal_after_errors(int fd, unsigned long len)
+{
+	unsigned char *map;
+	bool pass;
+	int ret;
+
+	/*
+	 * Adding F_SEAL_WRITE fails with EBUSY if any folio has an
+	 * unexpected refcount, e.g. one left behind by memory_failure().
+	 */
+	if (fcntl(fd, F_ADD_SEALS, SEALS_AFTER_ERRORS)) {
+		ksft_print_msg("Failed to seal memfd after injecting errors: %s\n",
+			       strerror(errno));
+		return false;
+	}
+
+	ret = fcntl(fd, F_GET_SEALS);
+	if (ret < 0 || (ret & SEALS_ALL) != SEALS_ALL) {
+		ksft_print_msg("F_GET_SEALS: got=%#x, expected %#x set\n",
+			       ret, SEALS_ALL);
+		return false;
+	}
+
+	if (!fcntl(fd, F_ADD_SEALS, F_SEAL_SEAL) || errno != EPERM) {
+		ksft_print_msg("F_ADD_SEALS on sealed memfd didn't fail with EPERM\n");
+		return false;
+	}
+
+	if (!ftruncate(fd, 0) || errno != EPERM) {
+		ksft_print_msg("Shrinking sealed memfd didn't fail with EPERM\n");
+		return false;
+	}
+
+	if (!ftruncate(fd, len + hugepage_size) || errno != EPERM) {
+		ksft_print_msg("Growing sealed memfd didn't fail with EPERM\n");
+		return false;
+	}
+
+	if (!fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+		       0, hugepage_size) ||
+	    errno != EPERM) {
+		ksft_print_msg("Punching hole in sealed memfd didn't fail with EPERM\n");
+		return false;
+	}
+
+	map = mmap(NULL, hugepage_size, PROT_READ | PROT_WRITE, MAP_SHARED,
+		   fd, 0);
+	if (map != MAP_FAILED || errno != EPERM) {
+		ksft_print_msg("Writable shared mmap of sealed memfd didn't fail with EPERM\n");
+		if (map != MAP_FAILED)
+			munmap(map, hugepage_size);
+		return false;
+	}
+
+	/* All errors were injected into the 1st hugepage. */
+	map = mmap(NULL, hugepage_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (map == MAP_FAILED) {
+		ksft_print_msg("Failed to mmap sealed memfd: %s\n",
+			       strerror(errno));
+		return false;
+	}
+	pass = memory_intact(map, hugepage_size);
+	munmap(map, hugepage_size);
+
+	return pass;
+}
+
+/*
+ * Unpoison the pages previously injected with errors,
+ * then validate HardwareCorrupted is reduced to original amount.
+ */
+static void unpoison_raw_pages(unsigned long corrupted_kb)
+{
+	bool pass = true;
+	size_t i;
+	int ret;
+
+	if (access(UNPOISON_PFN_DEBUGFS, W_OK)) {
+		ksft_test_result_skip("Unpoison raw pages: %s not available\n",
+				      UNPOISON_PFN_DEBUGFS);
+		return;
+	}
+
+	for (i = 0; i < nr_hwp_pages; ++i) {
+		ret = unpoison_memory(hwp_pfns[i]);
+		if (ret == -EOPNOTSUPP) {
+			/* Unpoison is disabled after a real memory error. */
+			ksft_test_result_skip("Unpoison raw pages: not supported\n");
+			return;
+		}
+		if (ret) {
+			ksft_print_msg("Failed to unpoison pfn=%#lx: %s\n",
+				       hwp_pfns[i], strerror(-ret));
+			pass = false;
+		}
+	}
+
+	pass = pass && raw_pages_hwpoison(false);
+	pass = pass && hardware_corrupted_is(corrupted_kb);
+	ksft_test_result(pass, "Unpoison raw pages\n");
+}
+
+/*
+ * Main thread that drives the test. It reports nr_hwp_pages + 4 results,
+ * plus 1 more if release_method is seal.
+ */
+static void test_main(void)
+{
+	const unsigned long *offsets = hugepage_size == HUGEPAGE_SIZE_2M ?
+				       offsets_2m : offsets_1g;
+	const unsigned long len = hugepage_size * NR_HUGEPAGES;
+	unsigned long nr_hugepages_before, nr_hugepages_after;
+	unsigned long corrupted_kb;
+	unsigned char *map;
+	struct sigaction sa = { 0 };
+	bool pass;
+	size_t i;
+	int fd;
+
+	fd = create_hugetlbfs_file();
+	nr_hugepages_before = hugetlb_nr_pages(hugepage_size);
+
+	if (ftruncate(fd, len) < 0)
+		ksft_exit_fail_perror("Failed to ftruncate");
+
+	map = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_perror("Failed to mmap");
+	memset(map, HUGETLB_FILL, len);
+
+	sa.sa_sigaction = sigbus_handler;
+	sa.sa_flags = SA_SIGINFO;
+	if (sigaction(SIGBUS, &sa, NULL) < 0)
+		ksft_exit_fail_perror("Failed to set up SIGBUS handler");
+
+	if (get_hardware_corrupted_size(&corrupted_kb))
+		ksft_exit_fail_msg("Failed to read HardwareCorrupted\n");
+
+	if (release_method == RELEASE_SEAL)
+		map = seal_before_errors(fd, map, len);
+
+	for (i = 0; i < nr_hwp_pages; ++i) {
+		void *addr = map + offsets[i];
+
+		hwp_pfns[i] = pagemap_get_pfn(pagemap_fd, addr);
+		if (hwp_pfns[i] == -1UL || !hwp_pfns[i])
+			ksft_exit_fail_msg("Failed to get PFN for %p\n", addr);
+
+		ksft_test_result(hwpoison_raw_page(addr, hwp_pfns[i]),
+				 "SIGBUS for raw page %zu at offset %#lx\n",
+				 i, offsets[i]);
+	}
+
+	/*
+	 * Neither MADV_HWPOISON nor corrupt-pfn corrupts the memory in
+	 * hardware, and MFD_MF_KEEP_UE_MAPPED keeps the hugepage mapped,
+	 * so every byte should remain accessible and hold original data.
+	 */
+	ksft_test_result(memory_intact(map, len), "Memory content intact\n");
+
+	/* The HWPoison hugepage should still be in the HugeTLB pool. */
+	nr_hugepages_after = hugetlb_nr_pages(hugepage_size);
+	pass = nr_hugepages_after == nr_hugepages_before;
+	if (!pass)
+		ksft_print_msg("nr_hugepages: before=%lu, after=%lu\n",
+			       nr_hugepages_before, nr_hugepages_after);
+	pass = hardware_corrupted_is(corrupted_kb +
+				     nr_hwp_pages * getpagesize() / 1024) && pass;
+	ksft_test_result(pass, "HWPoison hugepage kept\n");
+
+	/* End of the lifetime of the HugeTLB memfd. */
+	if (release_method == RELEASE_SEAL) {
+		/* Seal while the read-only private mapping is still alive. */
+		ksft_test_result(seal_after_errors(fd, len),
+				 "Seal memfd having HWPoison hugepage\n");
+		munmap(map, len);
+		/* The last close evicts the inode and releases its folios. */
+		close(fd);
+	} else {
+		if (ftruncate(fd, 0) < 0)
+			ksft_exit_fail_perror("Failed to ftruncate to 0");
+		munmap(map, len);
+		close(fd);
+	}
+
+	/*
+	 * After truncation or closure, the HWPoison hugepage should be
+	 * dissolved and removed from the HugeTLB pool, with only its raw
+	 * HWPoison pages isolated.
+	 */
+	nr_hugepages_after = hugetlb_nr_pages(hugepage_size);
+	pass = nr_hugepages_after + 1 == nr_hugepages_before;
+	if (!pass)
+		ksft_print_msg("nr_hugepages: before=%lu, after closure=%lu\n",
+			       nr_hugepages_before, nr_hugepages_after);
+	pass = raw_pages_hwpoison(true) && pass;
+	ksft_test_result(pass, "HWPoison hugepage dissolved after %s\n",
+			 release_method == RELEASE_SEAL ? "close" : "truncation");
+
+	unpoison_raw_pages(corrupted_kb);
+}
+
+static unsigned long parse_hugepage_size(const char *arg)
+{
+	if (!strcasecmp(arg, "1G"))
+		return HUGEPAGE_SIZE_1G;
+	if (!strcasecmp(arg, "2M"))
+		return HUGEPAGE_SIZE_2M;
+
+	ksft_exit_fail_msg("Invalid hugepage_size '%s': must be 1G or 2M\n",
+			   arg);
+}
+
+static size_t parse_nr_hwp_pages(const char *arg)
+{
+	unsigned long val;
+	char *endptr;
+
+	errno = 0;
+	val = strtoul(arg, &endptr, 10);
+	if (errno || endptr == arg || *endptr != '\0' ||
+	    val < 1 || val > MAX_NR_HWP_PAGES)
+		ksft_exit_fail_msg("Invalid nr_hwp_pages '%s': must be 1 to %zu\n",
+				   arg, MAX_NR_HWP_PAGES);
+
+	return val;
+}
+
+static enum inject_method parse_inject_method(const char *arg)
+{
+	if (!strcmp(arg, INJECT_MADVISE_STR))
+		return INJECT_MADVISE;
+	if (!strcmp(arg, INJECT_CORRUPT_PFN_STR))
+		return INJECT_CORRUPT_PFN;
+
+	ksft_exit_fail_msg("Invalid inject_method '%s': must be %s or %s\n",
+			   arg, INJECT_MADVISE_STR, INJECT_CORRUPT_PFN_STR);
+}
+
+static enum release_method parse_release_method(const char *arg)
+{
+	if (!strcmp(arg, RELEASE_TRUNCATE_STR))
+		return RELEASE_TRUNCATE;
+	if (!strcmp(arg, RELEASE_SEAL_STR))
+		return RELEASE_SEAL;
+
+	ksft_exit_fail_msg("Invalid release_method '%s': must be %s or %s\n",
+			   arg, RELEASE_TRUNCATE_STR, RELEASE_SEAL_STR);
+}
+
+static bool hugepage_size_supported(unsigned long size)
+{
+	unsigned long sizes[10];
+	int i, nr_sizes;
+
+	nr_sizes = detect_hugetlb_page_sizes(sizes, ARRAY_SIZE(sizes));
+	for (i = 0; i < nr_sizes; ++i) {
+		if (sizes[i] == size)
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Make sure there are at least nr free HugeTLB pages of the given size.
+ * hugetlb_save_settings() restores the original settings at exit.
+ */
+static bool setup_hugetlb_pages(unsigned long size, unsigned long nr)
+{
+	unsigned long free;
+
+	hugetlb_save_settings();
+
+	free = hugetlb_free_pages(size);
+	if (free >= nr)
+		return true;
+
+	hugetlb_set_nr_pages(size, hugetlb_nr_pages(size) + nr - free);
+	return hugetlb_free_pages(size) >= nr;
+}
+
+int main(int argc, char **argv)
+{
+	if (argc > 5)
+		ksft_exit_fail_msg("Usage: %s [1G|2M] [nr_hwp_pages] [%s|%s] [%s|%s]\n",
+				   argv[0], INJECT_CORRUPT_PFN_STR,
+				   INJECT_MADVISE_STR, RELEASE_TRUNCATE_STR,
+				   RELEASE_SEAL_STR);
+	if (argc > 1)
+		hugepage_size = parse_hugepage_size(argv[1]);
+	if (argc > 2)
+		nr_hwp_pages = parse_nr_hwp_pages(argv[2]);
+	if (argc > 3)
+		inject_method = parse_inject_method(argv[3]);
+	if (argc > 4)
+		release_method = parse_release_method(argv[4]);
+
+	ksft_print_header();
+
+	if (geteuid())
+		ksft_exit_skip("Need root to inject and unpoison memory errors\n");
+	if (inject_method == INJECT_CORRUPT_PFN &&
+	    access(CORRUPT_PFN_DEBUGFS, W_OK))
+		ksft_exit_skip("%s not available, try 'modprobe hwpoison_inject'\n",
+			       CORRUPT_PFN_DEBUGFS);
+	if (!hugepage_size_supported(hugepage_size))
+		ksft_exit_skip("%lukB HugeTLB pages not supported\n",
+			       hugepage_size / 1024);
+	if (!setup_hugetlb_pages(hugepage_size, NR_HUGEPAGES))
+		ksft_exit_skip("Failed to set up %d %lukB HugeTLB pages\n",
+			       NR_HUGEPAGES, hugepage_size / 1024);
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("Failed to open /proc/self/pagemap");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_fail_perror("Failed to open /proc/kpageflags");
+
+	ksft_print_msg("hugepage_size=%lukB nr_hwp_pages=%zu inject_method=%s release_method=%s\n",
+		       hugepage_size / 1024, nr_hwp_pages,
+		       inject_method == INJECT_CORRUPT_PFN ?
+				INJECT_CORRUPT_PFN_STR : INJECT_MADVISE_STR,
+		       release_method == RELEASE_SEAL ?
+				RELEASE_SEAL_STR : RELEASE_TRUNCATE_STR);
+
+	/*
+	 * One result per raw HWPoison page, plus 4 for the hugepage, plus 1
+	 * for sealing.
+	 */
+	ksft_set_plan(nr_hwp_pages + 4 + (release_method == RELEASE_SEAL));
+	test_main();
+
+	close(kpageflags_fd);
+	close(pagemap_fd);
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 973cb715b326..4d5140b7dee7 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -467,6 +467,7 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 CATEGORY="rmap" run_test ./rmap
 
 CATEGORY="memory-failure" run_test ./memory-failure
+CATEGORY="memory-failure" run_test ./hugetlb-mfr
 
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
-- 
2.56.0.611.g1030f0b940-goog

