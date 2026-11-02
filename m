Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793605469;
	b=LTO8HR6A5QEZHO2+KPBHOXmeeQLGx5Mpk+WjEVb1NtnncSFcG1fAdJRX3dpCy7EDDt/3
	 vwv+JEjUPHTt69iVAE6KeCsdTyKNyt2Zw9OcwVEfMkV9bGGPCjzKktnIwXPeQLvWkSF6s
	 SbIksFgvZ9UwW0aPpB3AikBOo4zWu229UmwJl5UzQzP/b4dmhUZIOrhWrn+/Ni2MxiYiR
	 jN/jnjfLb5N3BL6vrtUNRK0+9XHaXrqUghVp761FVUeDwqAAgkVjP+ESIbITJoyUMV7A2
	 OhSvtmkmutuHjb4cFHDSd66eTGh1IRSxn7GrJzWVm0FmEqS4vs7kyAZ8nFoepDGEk0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793605469;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbEqoEmiOLpfQLZXaMwfuY090SS6ZvbC9oI0iDoMLRc=;
	b=Y1Ia9aQC8vOEq7ma2DxxPilt0diyLlHgnI9i5/CRv7HoNng3uQoh+thFvnFbmBd12qhl
	 xRK4+K+VgWTLAbgRqtAoVOVGUKqu52HhkQSSDWMYoXOG1kdad8m6M3GuxSWDSScDHo/Wf
	 VT4iStO/HB17Cqtmxgk2t63ik/L5idFeGlBjfen8nJmvNzCy8sCD3GQb4ylCr920DHNSP
	 IKAZkrX3F81Jr950rzJPnmykDqacAFTaMxqtQCfCPMPYPYT60WcWke9iKbJQoeuOKlg12
	 tm0mkMLuf31fCyoHIDxM2EVMgCiFluZnDyFjQrK27p92S6NYmP3KjVyAalDxsdNGXMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="g55Rr/XF";
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7593160A260D
	for <linux-api@vger.kernel.org>; Mon,  2 Nov 2026 07:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7593160A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g55Rr/XF
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48df4f540ebso1138775f8f.3
        for <linux-api@vger.kernel.org>; Sun, 01 Nov 2026 23:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793605468; x=1794210268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tbEqoEmiOLpfQLZXaMwfuY090SS6ZvbC9oI0iDoMLRc=;
        b=g55Rr/XF1d28kJml+NF7JZU9snuT/I/3wcn0NtnKDeNWwtw7hTBHwrsCYjseESZ0QE
         YM4ixaPDJgSNxQsI4tDs2fx39Q8FPog73TciZ4rZca30FgtmhbQKuj0ZkMtOR6mYbAhd
         4DRGhYUwE6DXaZn0eeNHegtQfxPLErwLsX/K3k1ipwu7azBa9wes+CbI1I4u8w0d+pmP
         I/wV0EtTUkoe1F/5zqpjwSGDFq2RrDxzoEIOE/reeMNzQj6Q3ZBJKwn4Z/SG+WdA+Rso
         8FfbCZb2G8nMirGo0AyX1tL4VFZd0jcomNDfKzxlNbC6buF7B3j4b0fSrRtmAn1paL4P
         +6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605468; x=1794210268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tbEqoEmiOLpfQLZXaMwfuY090SS6ZvbC9oI0iDoMLRc=;
        b=hXwjLmIkkbQ25zbOTEzd/xWj5THYiFDcuZjR7dfQW6fse/ILJ/pnjAZdjA2972YfFB
         3I2C61tSIb64YZDYeV7TOhI3CrXk005tR9VPOrX0BW7yA19k7YGi5Y3RJpHUBIOS9Vti
         2KOAZfdVkIhAJ/+iFXYkTU/NkruoYbHBysYunaG4Wffz9nyfQRSAEZV34JXnaYB7dlAH
         BDdFD95hi4HvLq/eI9R/Ou+V9fk3uMRW+Z+/SQutJODpP8TY/+GwCsdJg9MlzhQ6zxco
         5p195+RGtvXchK/0pDPi06hsVgR5rBqdfyiKl/TJYSeYsa3Rx+SPguWheD/dh7M+dnPF
         a4VQ==
X-Forwarded-Encrypted: i=1; AKwUvBzjnO3W4KgREMZ+atd10J8Kxt/zDqnxoC7Mw973Ya89e5A99ZvFRVL0SlsQy4ExLmpOHUshaqt9zpE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/BvtJtvqjpySWnCpfZVC9MnB21gFeDqdYyJ1nzhzAtTW+ITHG4
	SdOgBPIgFT9yjfc657ka2VIyWPmTkwxsR8kcJiY1hOpzxNWmPWauZ/96
X-Gm-Gg: AYBFou10ekoKM4vOxZGTskAH1JtlTa0KqaW27WGXSa7IWPVw4gYKHnn3UGEH+vU/JZ1
	N9hAsMxnobzVGLJDQLLFjpdnw7SRZJsIRZ5ckLOgMxL/yLm+fPt+4lBetwl+wuHr/tNrxwslQ9b
	gmppPis6ri1uCrBoRGJHeeFvzGR8kbe9Jkmc4TUiGYvZBlY+V4SHAv4wNFJssNanTXC70Hi/L/e
	VNQpXnWxmgNJLvhUo8vxiiwO/GPlkPiqyNOo74EDPAY+Df3N0Hy2dTzqbMD9b7/TU1xCqhXZLY5
	MHOAYH9yQC489QYf4TsV1Vsc2+7kmv6vLRC51wk/0jueY6ri2LJusfkSEyCKDyddFpVcJIUjG7/
	fj3hN119YXUhWQAhKvWYqz/uCpG0S4Y+8oCgqbglWtoOsxnGKaq2UMkEeBMXlw4+8+CpReecdDs
	2l7X5TrWgsQuvVA2CR8We94t5L9whHNftP1a7MbQglbs48A7p71mGXEAcMhinFyLiMnpzlxmI5n
	HDBToSLgNOTUjJpxJTBb4vkqI6b2ttY6UQRXdsqKWNdqEN8sbqXRCTDYph6qWDKja994Y2ASoMQ
	AMSsULXBbsB9DXZMQf1Gqc4hFnJ3/pR6S7s=
X-Received: by 2002:a05:6000:144f:b0:48d:de0f:b79 with SMTP id ffacd0b85a97d-48e6e264067mr23884219f8f.0.1793605467644;
        Sun, 01 Nov 2026 23:44:27 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b81c74sm18050374f8f.36.2026.11.01.23.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 23:44:27 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	ts930@dgu.ac.kr,
	alx@kernel.org,
	linux-api@vger.kernel.org,
	linux-man@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH RESEND 3/3] selftests/mm: test mlock() and munlock() range normalisation
Date: Mon,  2 Nov 2026 08:44:01 +0100
Message-ID: <20261102074412.189554-4-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102074412.189554-1-azpijr@gmail.com>
References: <20261102074412.189554-1-azpijr@gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add mlock2-tests cases for a zero length at aligned and unaligned
addresses, for a length that wraps when rounded to pages, and for an
overflowing start + len, checking the return value and VmLck.  The
overflow cases expect -EINVAL with and without CAP_IPC_LOCK, so running
the test unprivileged also covers the errno that used to depend on it.

The wrapping cases assume the test is built for the kernel's word size: a
32-bit binary on a 64-bit kernel cannot pass a range that wraps.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 tools/testing/selftests/mm/mlock2-tests.c | 191 +++++++++++++++++++++-
 1 file changed, 190 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index 144b550813a6..3dca349c4738 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -2,6 +2,7 @@
 #define _GNU_SOURCE
 #include <sys/mman.h>
 #include <linux/mman.h>
+#include <limits.h>
 #include <stdint.h>
 #include <unistd.h>
 #include <string.h>
@@ -91,6 +92,7 @@ static bool is_vmflag_set(unsigned long addr, const char *vmflag)
 #define SIZE "Size:"
 #define RSS  "Rss:"
 #define LOCKED "lo"
+#define VMLCK "VmLck:"
 
 static unsigned long get_value_for_name(unsigned long addr, const char *name)
 {
@@ -177,6 +179,27 @@ static int unlock_lock_check(char *map, bool mlock_supported)
 	return 1;
 }
 
+static unsigned long get_vmlck(void)
+{
+	unsigned long vmlck;
+	char line[1024];
+	FILE *file;
+
+	file = fopen("/proc/self/status", "r");
+	if (!file)
+		ksft_exit_fail_msg("fopen: %s\n", strerror(errno));
+
+	while (fgets(line, sizeof(line), file)) {
+		if (sscanf(line, VMLCK "\t%lu kB", &vmlck) == 1) {
+			fclose(file);
+			return vmlck << 10;
+		}
+	}
+
+	fclose(file);
+	ksft_exit_fail_msg("cannot parse VmLck in /proc/self/status\n");
+}
+
 static void test_mlock_lock(void)
 {
 	char *map;
@@ -204,6 +227,167 @@ static void test_mlock_lock(void)
 	munmap(map, 2 * page_size);
 }
 
+static void test_mlock_zero_length(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(!mlock(map, 0),
+			 "%s: zero length mlock() at an aligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length mlock() at an aligned address locked nothing\n",
+			 __func__);
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(!mlock(map + 5, 0),
+			 "%s: zero length mlock() at an unaligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length mlock() at an unaligned address locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_munlock_zero_length(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	if (mlock(map, 2 * page_size)) {
+		munmap(map, 2 * page_size);
+		ksft_exit_fail_msg("mlock(): %s\n", strerror(errno));
+	}
+
+	vmlck_before = get_vmlck();
+	ksft_test_result(vmlck_before > 0,
+			 "%s: the range to release is accounted as locked\n",
+			 __func__);
+	ksft_test_result(!munlock(map + 5, 0),
+			 "%s: zero length munlock() at an unaligned address\n", __func__);
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: zero length munlock() at an unaligned address released nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlock_length_wrap(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	char *map;
+	int ret;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map, ULONG_MAX);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: mlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: mlock() with a wrapping length locked nothing\n",
+			 __func__);
+
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map + 5, ULONG_MAX);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: unaligned mlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: unaligned mlock() with a wrapping length locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_mlock_addr_overflow(void)
+{
+	unsigned long page_size = getpagesize();
+	unsigned long vmlck_before, vmlck_after;
+	size_t len;
+	char *map;
+	int ret;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	/* addr + len wraps to 0 */
+	len = (size_t)(0UL - (unsigned long)map);
+
+	/* -EINVAL with or without CAP_IPC_LOCK */
+	vmlck_before = get_vmlck();
+	errno = 0;
+	ret = mlock(map, len);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "%s: mlock() with an overflowing addr + len is rejected\n",
+			 __func__);
+
+	vmlck_after = get_vmlck();
+	ksft_test_result(vmlck_before == vmlck_after,
+			 "%s: mlock() with an overflowing addr + len locked nothing\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
+static void test_munlock_range_overflow(void)
+{
+	unsigned long page_size = getpagesize();
+	size_t len;
+	char *map;
+
+	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (map == MAP_FAILED)
+		ksft_exit_fail_msg("mmap error: %s\n", strerror(errno));
+
+	errno = 0;
+	ksft_test_result(munlock(map, ULONG_MAX) == -1 && errno == EINVAL,
+			 "%s: munlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	errno = 0;
+	ksft_test_result(munlock(map + 5, ULONG_MAX) == -1 && errno == EINVAL,
+			 "%s: unaligned munlock() with a wrapping length is rejected\n",
+			 __func__);
+
+	len = (size_t)(0UL - (unsigned long)map);
+	errno = 0;
+	ksft_test_result(munlock(map, len) == -1 && errno == EINVAL,
+			 "%s: munlock() with an overflowing addr + len is rejected\n",
+			 __func__);
+
+	munmap(map, 2 * page_size);
+}
+
 static int onfault_check(char *map)
 {
 	*map = 'a';
@@ -506,9 +690,14 @@ int main(int argc, char **argv)
 
 	munmap(map, size);
 
-	ksft_set_plan(15);
+	ksft_set_plan(31);
 
 	test_mlock_lock();
+	test_mlock_zero_length();
+	test_munlock_zero_length();
+	test_mlock_length_wrap();
+	test_mlock_addr_overflow();
+	test_munlock_range_overflow();
 	test_mlock_onfault();
 	test_munlockall0();
 	test_munlockall1();
-- 
2.56.0

