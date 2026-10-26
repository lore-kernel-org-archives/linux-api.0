Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793052393;
	b=ZARQGAHbLOnA9y6NPOqcL2DZHb4BPKaCb11Gnj4lT6VEBzrfx0PJdG+DaqEGgp0+svTE
	 1o189r13Q9F9px9bvZAM0f/FUwmMq+XNxMbfpuy3yrhZHljhpadAw7SitvCKavRV4PdcF
	 ftOjnv9Zv64roXdaIqmOKBMq8wu6F+FIFehzo/+NY6Ad9FZeF+4PLKq4xH4xNXaf5t8RX
	 J6slveqLCMqg2Fe5saAVLCsHQBKT2o7h4XJlf1BfP8q7BXYCwEl8QyNyArSlYVnnNp1SJ
	 FQRgkGciGN49xGtElPO2ftbcEjUhuo2Y0RbMT/nKUn8gBW60ZqxfYIWz1e6U0ic8Ebw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JbeI020SnpugISxSyc+z9N6JHGvPCZP0HYKr/jk1BYM=;
	b=dcb9Ww5S/XTto+urdlb3kmqvqZQuw5nVV77eZ485c9RfK9KtMXejSlNoDyA0y83HM1AS
	 5ty7Aeq5a7bxQWqYEkYOgAaNcaPMimFYBDUx0xgo+T1xGNw8zQs+SD5WW0zMdLkDoE64n
	 69pFnKP6qmMqfYQdZorjNymN32tCb6Q3jiSfyq3fk6ez1idRXwv1UU2oMnUpMZyaSCzNH
	 JTfvWtqY46yK7iV4dnfx6gSuAM7hfIcksWArYjnY4BrwkXahB60xmU/J/xoCOdwEfNeNO
	 3wip7+OrNLxJr1gsN9rZj8t+LM5rSGdPyNEV1p/67DIlkAMD5RpaQ846JvQcx8GVctw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TPbFrQyD;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FF5606A33D
	for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 22:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36FF5606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=TPbFrQyD
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-88c768885b4so6047067b3a.0
        for <linux-api@vger.kernel.org>; Mon, 26 Oct 2026 15:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793052392; x=1793657192; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JbeI020SnpugISxSyc+z9N6JHGvPCZP0HYKr/jk1BYM=;
        b=TPbFrQyDnQ3X2ODTkC5Ghf3QJey5ayVfOW9a6h/mIXdaI4wS7Zuy7Lm3Ye14m2RZIr
         W/ysoFKbYw6B010/w/3MTtieRdYsfbDLUbTd9sRVoRySVf9nuhXNUMjL8VyUSGhNyDUt
         FxdLBk6fq4BekRTUR170BUsK1G0XLlrtqliDoAu7JTbzUnCWYKSQs9hDza91b+0AEGH0
         cz76REwf49YYA/LjIZ1GnRJA0+6lAEKCfmbxkUsBNzCEkD4TcOdoVp4T4lhhR6Q6RNpl
         ++GYdo0/v+KIeLNVAQzc6JOcJ8EiAyTL7xBr3qGRdPVjSvpu9FAoqpr5seFlRHyosc7m
         sFow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052392; x=1793657192;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JbeI020SnpugISxSyc+z9N6JHGvPCZP0HYKr/jk1BYM=;
        b=q22fR2JBeLMaEpBTFt6RweSOrbwMQrNgePBCvMnfi6W8H+/4Zw8HNWw01tDpH47bcI
         SbVnzQ/srhI7wP1EiHEtD/HHm/PUkPqgmY3FjRM+ri7rjJYVC8qiqhe9/qnnif1KJjM0
         0kXLH1RrRTvRUo21+4CnQNn+0kCn9lCiHiSbxD11HFkYrq6aSrKdb0xWQ+0WfDP5jAJE
         Lsko40W4fq1KaeHS1v/okCbpk5drPuf/XYcg47gJf70VJ96o56dtFF2sHJjDEbMi2a7u
         ALRBzc96lHxaZVrn0Z6i5xqN8ZqOJGi+LtdNI51wzAvMmMcl4W8aP8lNIOUcbR7Tw0Qt
         2mEQ==
X-Forwarded-Encrypted: i=1; AKwUvBxaj3INZaW0T9YUS2P20HML6IeKPY4sj1TuBx8Qfeq6w4tSnORGc7sF4sFUggDnor/JKkCzmmFNLCY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJMXzCEJA+vLtDwSd1nXRvBHa97/WiVjRpx/BhFgFe5RQ7P4lS6
	IXm6EP1nXgkvn5AIR42SWO68x81WeL4i6Eay0yaKIZDs9WPMBOr7RzDIYlCe923ZN4HWP07duEW
	b+xh4fSibmfTy2w==
X-Received: from pgdo1-n2.prod.google.com ([2002:a05:6a02:6201:20b0:cd6:b08a:e7cb])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4e0b:b0:3e1:8890:8400 with SMTP id adf61e73a8af0-3e7bfbdb8dcmr6859849637.15.1793052392197;
 Mon, 26 Oct 2026 15:06:32 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:05:46 +0000
In-Reply-To: <20261026220546.3114241-1-skhawaja@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026220546.3114241-3-skhawaja@google.com>
Subject: [PATCH 2/2] selftests/memfd: add F_SEAL_PUNCH_HOLE tests
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Add tests for the new F_SEAL_PUNCH_HOLE seal. Like the rest of
memfd_test, they run on shmem memfds by default and on hugetlbfs memfds
when memfd_test is invoked with the "hugetlbfs" argument.

mfd_assert_write() checks that the file can be written, and then also
checks that a hole can be punched into it. The second check no longer
holds once F_SEAL_PUNCH_HOLE is set. Move the write checks into
__mfd_assert_write() and the punch check into mfd_assert_punch_hole(),
and have mfd_assert_write() call both, so the existing tests keep doing
exactly what they did before.

Add mfd_fail_punch_hole(), which checks that both
fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
EPERM, and use it in two new tests. SEAL-PUNCH-HOLE sets only the new
seal and checks that punching a hole fails, while writing, shrinking and
growing the file still work. SEAL-PUNCH-HOLE-SHRINK adds F_SEAL_SHRINK
as well and checks that the file can neither have holes punched into it
nor be shrunk, while it can still grow.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 tools/testing/selftests/memfd/memfd_test.c | 111 ++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index cdab3a837624..095c5eb255af 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -35,6 +35,10 @@
 
 #define F_SEAL_EXEC	0x0020
 
+#ifndef F_SEAL_PUNCH_HOLE
+#define F_SEAL_PUNCH_HOLE	0x0040
+#endif
+
 #define F_WX_SEALS (F_SEAL_SHRINK | \
 		    F_SEAL_GROW | \
 		    F_SEAL_WRITE | \
@@ -455,7 +459,7 @@ static void mfd_assert_fork_private_write(int fd)
 	munmap(p, mfd_def_size);
 }
 
-static void mfd_assert_write(int fd)
+static void __mfd_assert_write(int fd)
 {
 	ssize_t l;
 	void *p;
@@ -523,6 +527,11 @@ static void mfd_assert_write(int fd)
 
 	*(char *)p = 0;
 	munmap(p, mfd_def_size);
+}
+
+static void mfd_assert_punch_hole(int fd)
+{
+	int r;
 
 	/* verify PUNCH_HOLE works */
 	r = fallocate(fd,
@@ -535,6 +544,49 @@ static void mfd_assert_write(int fd)
 	}
 }
 
+static void mfd_fail_punch_hole(int fd)
+{
+	void *p;
+	int r;
+
+	/* verify PUNCH_HOLE fails */
+	r = fallocate(fd,
+		      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+		      0,
+		      mfd_def_size);
+	if (r >= 0 || errno != EPERM) {
+		printf("expected EPERM on fallocate(PUNCH_HOLE), but got %d: %m\n",
+		       r);
+		abort();
+	}
+
+	/* verify MADV_REMOVE fails, it punches a hole as well */
+	p = mmap(NULL,
+		 mfd_def_size,
+		 PROT_READ | PROT_WRITE,
+		 MAP_SHARED,
+		 fd,
+		 0);
+	if (p == MAP_FAILED) {
+		printf("mmap() failed: %m\n");
+		abort();
+	}
+
+	r = madvise(p, mfd_def_size, MADV_REMOVE);
+	if (r >= 0 || errno != EPERM) {
+		printf("expected EPERM on madvise(MADV_REMOVE), but got %d: %m\n",
+		       r);
+		abort();
+	}
+	munmap(p, mfd_def_size);
+}
+
+static void mfd_assert_write(int fd)
+{
+	__mfd_assert_write(fd);
+	mfd_assert_punch_hole(fd);
+}
+
 static void mfd_fail_write(int fd)
 {
 	ssize_t l;
@@ -1117,6 +1169,61 @@ static void test_seal_resize(void)
 	close(fd);
 }
 
+/*
+ * Test SEAL_PUNCH_HOLE
+ * Test whether SEAL_PUNCH_HOLE actually prevents punching holes, but still
+ * allows writing and resizing
+ */
+static void test_seal_punch_hole(void)
+{
+	int fd;
+
+	printf("%s SEAL-PUNCH-HOLE\n", memfd_str);
+
+	fd = mfd_assert_new("kern_memfd_seal_punch_hole",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_add_seals(fd, F_SEAL_PUNCH_HOLE);
+	mfd_assert_has_seals(fd, F_SEAL_PUNCH_HOLE);
+
+	mfd_assert_read(fd);
+	__mfd_assert_write(fd);
+	mfd_fail_punch_hole(fd);
+	mfd_assert_shrink(fd);
+	mfd_assert_grow(fd);
+	mfd_assert_grow_write(fd);
+
+	close(fd);
+}
+
+/*
+ * Test SEAL_PUNCH_HOLE | SEAL_SHRINK
+ * Test whether SEAL_PUNCH_HOLE | SEAL_SHRINK prevents removing pages from
+ * the file
+ */
+static void test_seal_punch_hole_shrink(void)
+{
+	int fd;
+
+	printf("%s SEAL-PUNCH-HOLE-SHRINK\n", memfd_str);
+
+	fd = mfd_assert_new("kern_memfd_seal_punch_hole_shrink",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_add_seals(fd, F_SEAL_PUNCH_HOLE | F_SEAL_SHRINK);
+	mfd_assert_has_seals(fd, F_SEAL_PUNCH_HOLE | F_SEAL_SHRINK);
+
+	mfd_assert_read(fd);
+	__mfd_assert_write(fd);
+	mfd_fail_punch_hole(fd);
+	mfd_fail_shrink(fd);
+	mfd_assert_grow(fd);
+
+	close(fd);
+}
+
 /*
  * Test SEAL_EXEC
  * Test fd is created with exec and allow sealing.
@@ -1736,6 +1843,8 @@ int main(int argc, char **argv)
 	test_seal_shrink();
 	test_seal_grow();
 	test_seal_resize();
+	test_seal_punch_hole();
+	test_seal_punch_hole_shrink();
 
 	if (pid_ns_supported()) {
 		test_sysctl_simple();
-- 
2.56.0.307.g5fe7bd680c-goog

