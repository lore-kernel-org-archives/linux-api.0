Received: from list.codeweavrs.com (list.codeweavers.com [4.36.192.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D93D3E3C53;
	Thu, 23 Jul 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.36.192.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837602; cv=none; b=fU3y6ZCLX0TKlif+Pp24hZaBpnd++rT8dCslWUlfoUDbEzvdFgu6EV9etpuJ42EW98yS36W4qonF0Sp0Fipx0Qo/kxtTwpVzeMYkb2QQ3NvXeHMVDYKYCpIib/HbYi0Rjz5Oe3wdg52bkKyxUbecgZJlNo1aC8UitkD3+4N7oOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837602; c=relaxed/simple;
	bh=rE5HbVqtofkngexVaaky72bibZgS/dEumsKq+/P38/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQ9JBVoEthIW2ZWMqpXv0MgjNNkWFyDATtQ8jspJkVZNi47V7z8pTlKNKOB2oj99s7H4YC/TlXBEopYQpojBdH6qZFmICrJoIP1q/Uk6OCmDxTtL/rm9Mb7lRxHRtopppMLKUCtk8VmLtyrOWdNUR/+3stYG8sOtKvZO7bk8BNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com; spf=pass smtp.mailfrom=codeweavers.com; dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b=d/wc8GVv; arc=none smtp.client-ip=4.36.192.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeweavers.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=list.codeweavers.com header.i=@list.codeweavers.com header.b="d/wc8GVv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=list.codeweavers.com; s=list; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wd4ttW1UD6XVjsWmzADxCG/cukZBLY0mcKBMFwzC5Zw=; b=d/wc8GVvGfeh3ZVob9KfPCkIy+
	Q/tbb0T5G94td60ZmY9KFjXT8sa5Zx+asvazYs0crQ1/S6JjYZdazykquJP5PrFGhXvNcoJG68K4d
	R+l+RIWQVp4jBj0EFa2fTgRuHB0IqkMNydjKWkvmamj0cLdIeITTjx2E3g46k7UpzwwhwTDXFfvRF
	UvtGspbj0QqS6Sse/32Kp24Jw3o/j6uHRlconh+LLcjx3b0Vwyah+AePKyVOSw41efBlL7NIycD92
	DTIjFXH0SQ43ele188C5/tfgSHG7UaF8gw5jBrCmK2i+J51gczwcjBkRyKbtC6c25i/gK9YR4hQAF
	aSV5TbCA==;
Received: from cw137ip160.mn.codeweavers.com ([10.69.137.160] helo=camazotz.mn.codeweavers.com)
	by list.codeweavrs.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <zfigura@codeweavers.com>)
	id 1wmzn6-00AV4U-1h;
	Thu, 23 Jul 2026 15:13:12 -0500
From: Elizabeth Figura <zfigura@codeweavers.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	wine-devel@list.winehq.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH v2 5/5] selftests: ntsync: test absolute MONOTONIC waits under time namespaces
Date: Thu, 23 Jul 2026 15:13:01 -0500
Message-ID: <20260723201301.11826-6-zfigura@codeweavers.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723201301.11826-1-zfigura@codeweavers.com>
References: <20260723201301.11826-1-zfigura@codeweavers.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

Cover the timens conversion in ntsync_schedule(): with a negative
CLOCK_MONOTONIC offset, a 100 ms absolute wait must not return
immediately against the host clock.

Suggested-by: Maoyi Xie <maoyixie.tju@gmail.com>
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Signed-off-by: Elizabeth Figura <zfigura@codeweavers.com>
---
 .../testing/selftests/drivers/ntsync/ntsync.c | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/testing/selftests/drivers/ntsync/ntsync.c b/tools/testing/selftests/drivers/ntsync/ntsync.c
index c9fe4d5987ec..1f0dc43bb4c0 100644
--- a/tools/testing/selftests/drivers/ntsync/ntsync.c
+++ b/tools/testing/selftests/drivers/ntsync/ntsync.c
@@ -8,12 +8,18 @@
 #define _GNU_SOURCE
 #include <sys/ioctl.h>
 #include <sys/stat.h>
+#include <sys/wait.h>
 #include <fcntl.h>
+#include <sched.h>
 #include <time.h>
 #include <pthread.h>
 #include <linux/ntsync.h>
 #include "kselftest_harness.h"
 
+#ifndef CLONE_NEWTIME
+#define CLONE_NEWTIME 0x00000080
+#endif
+
 static int read_sem_state(int sem, __u32 *count, __u32 *max)
 {
 	struct ntsync_sem_args args;
@@ -1384,4 +1390,85 @@ TEST(wait_args_validation)
 	close(fd);
 }
 
+/*
+ * Absolute MONOTONIC timeouts must honour the caller's time namespace.
+ * With a negative monotonic offset, a 100 ms wait must still take ~100 ms
+ * of namespace time (not return immediately against the host clock).
+ */
+TEST(wait_any_monotonic_timens)
+{
+	struct ntsync_sem_args sem_args = {0};
+	struct ntsync_wait_args wait_args = {0};
+	struct timespec start, end;
+	char buf[64];
+	__u64 elapsed_ns;
+	int fd, offset_fd, sem, ret, status, len;
+	pid_t pid;
+
+	if (access("/proc/self/ns/time", F_OK))
+		SKIP(return, "Time namespaces are not supported");
+
+	fd = open("/dev/ntsync", O_CLOEXEC | O_RDONLY);
+	if (fd < 0)
+		SKIP(return, "/dev/ntsync is not available");
+
+	ret = unshare(CLONE_NEWTIME);
+	if (ret) {
+		close(fd);
+		if (errno == EPERM)
+			SKIP(return, "need CAP_SYS_ADMIN for CLONE_NEWTIME");
+		ASSERT_EQ(0, ret);
+	}
+
+	len = snprintf(buf, sizeof(buf), "%d %d 0", CLOCK_MONOTONIC, -10);
+	offset_fd = open("/proc/self/timens_offsets", O_WRONLY);
+	ASSERT_LE(0, offset_fd);
+	ASSERT_EQ(len, write(offset_fd, buf, len));
+	close(offset_fd);
+
+	pid = fork();
+	ASSERT_LE(0, pid);
+	if (!pid) {
+		int obj;
+
+		sem_args.count = 0;
+		sem_args.max = 1;
+		sem = ioctl(fd, NTSYNC_IOC_CREATE_SEM, &sem_args);
+		if (sem < 0)
+			_exit(1);
+
+		obj = sem;
+		wait_args.timeout = get_abs_timeout(100);
+		wait_args.objs = (uintptr_t)&obj;
+		wait_args.count = 1;
+		wait_args.owner = 123;
+		wait_args.index = 0xdeadbeef;
+
+		if (clock_gettime(CLOCK_MONOTONIC, &start))
+			_exit(2);
+		ret = ioctl(fd, NTSYNC_IOC_WAIT_ANY, &wait_args);
+		if (clock_gettime(CLOCK_MONOTONIC, &end))
+			_exit(2);
+
+		if (ret != -1 || errno != ETIMEDOUT)
+			_exit(3);
+
+		elapsed_ns = (end.tv_sec - start.tv_sec) * 1000000000ULL +
+			     (end.tv_nsec - start.tv_nsec);
+		/* Without timens conversion this returns in ~0 ms. */
+		if (elapsed_ns < 50 * 1000000ULL)
+			_exit(4);
+		if (elapsed_ns > 1000 * 1000000ULL)
+			_exit(5);
+
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	EXPECT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	close(fd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.53.0

