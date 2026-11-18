Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037335;
	b=OZj4+/qYScjJx7DbG9xBovBYCqMMLakAFPGodrAMS7U0kgAz5J42vGxvOgWSVcNRorqn
	 4sPNUgAXmi69wmwpvLc1SvpI8cSAK3GRUzSXRB83ubOyayk8Z19tAk1wsBYDCI772mdCz
	 2yXub08h1TyWdozrAIoSa/wtP9sJCT7bHeKJEFyeiwADd2cU0HF0SavatgGjvbI7zLF0w
	 2iJcd89AA47zzItv7fCKkMBar2invvKJRlbVhNn/ZfltrYib62+SFS6g3ACoNkWnYWNmA
	 RdqGBY9PlrWMUks51pceym7dHbNoIdXEYOf1FMSnoo44G02h16uN3yLmUa8RO6u7tUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4n5oLhMYFN0GZT8T1PCl7tWuEXQGuvdSxMt72RME2E=;
	b=Mogv87VWsCXeXNkAVM2MRg403bSJLBWDKwfArwnOx28rJYissFfsHz8y/Gh/fRZeUnX8
	 UWeqTnhphDvfA9wrxj9XDEhinCsjhcP983TQF+d0YsHNXo5qtj1r8UMwi7MBOIML+V7OB
	 7oD2xRQ1ivuHIdD3gGzqtk8tQrgqogGUUvfNOAi/19dieLTUxrE9elEy1zAw3bUReTi8y
	 AwdqSdx58ydU6G1TB1owffxytc9h0tA72qsZj58YjhD7W24JalCSxng3huR9MsA6vAi9R
	 om6yL+eMZGDEfzPJBsKaSJZBU8FntMPsamt9cB4Y0Y5GKprtADRO31W7p1x397ySanA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=soleen.com;
	spf=pass smtp.mailfrom=soleen.com;
	dkim=pass header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=DOjwVFMD;
	arc=none smtp.remote-ip=209.85.217.46
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDC460A3828
	for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 21:28:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DDC460A3828
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=DOjwVFMD
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7d2c8141dc6so725105137.1
        for <linux-api@vger.kernel.org>; Wed, 18 Nov 2026 13:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1795037334; x=1795642134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s4n5oLhMYFN0GZT8T1PCl7tWuEXQGuvdSxMt72RME2E=;
        b=DOjwVFMDfcMo57qcwPQexgRTtJ0WzI9qCReEasXVrgqEWpoptSAZ8EiO6SY+KBhmSt
         /mH9YngiZeYLZlw1qcnMhSZ8DkTcEtDddhbQxHDeIB+R63DtLzHMTLeWVryjDdCLTHbz
         AWTTlvc+CjIYNgAUi6mw52l5zJ5aBZheMgFYPh2Hk51rrE74237uB4YnPOTy0AmYFZan
         B8bqcVH8j2nn+3mkI9X0uVPSXrMWlXfdTAQrGAI8bQxPgUs8uZbFLD5gYpDFkjSrk5az
         4kMLST8/D7yE6ut+5k8xblahHCDXf2wCzdWyy4eQd+8O/HTk9c2shtP2RRDIIea/7qxF
         /xqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037334; x=1795642134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=s4n5oLhMYFN0GZT8T1PCl7tWuEXQGuvdSxMt72RME2E=;
        b=UOpQ73BoYSs5ToYdglarLCIKbdMO+puBclvLxrxdKTQNs+IXmN1m4nOpVXnuNCbjOv
         VjSje86wKKC3MysPwfy9gbOdWhHcgh+29Hir2p/pRaHC8i/y/4xx7vPB6aKPUepZLq4h
         +xLSJI8pXckYrpJ+Q4ZQ1HZKihVuqNVDqRZitUBeINH4OJyyMi3NK9kyTLRPljMnjHQp
         nfdMfluz4w0LGwnZ1ZmZy9IISgbQg4G412hl8o2rM+SAmamZ9B2XtXHayDdgvp614N9F
         /4Ph0B4XhyHBvRipQEE0aBe/u1yumgqaSjfdDPbiopGd1Dfh6almuU56kHGsIdkloW9X
         vI8A==
X-Forwarded-Encrypted: i=1; AL+hErHsnDp8jvLs6YapUu8EehMsOAqzoHSTLPSI6aRYZATfQLq9T6IETyoqCt5SpRNUEubL5EiyzLcgrI8=@vger.kernel.org
X-Gm-Message-State: APuU4Z9VGzR4MUHaS2pbNJZ1dwQ2M/tEMsiKGsbtU6Cin1Vmed5Xjwht
	x/Iw+AhP1r/ILSU2P6Dw9RWwQ6zltImDErhhnLty0y1kZlHRJSjNWC7XYJ/2VkMwiH4=
X-Gm-Gg: AYBFou29VbFV2O+/hHCGoQCZ3hHtqZ4btgFhXh/0W0WY7jKqs9XpvrwzE/8Rd7YdgQX
	alQLyo3jU3eNfm/rV5aZa+PngRIhZEWpGB6qVN1D+GZ3kvtM9cl/ul/9ne26nV62BhgDn/R1aGI
	ZI94R1XhOttFTYeaLzWYOsCL8tp2Cxphq8W5ci80nOOt7bL72wfPtMe67bZdO/4oHXlJsJbcRUI
	r5p4l3EfY6X4BgKNVslfkqDvCsHBVDTjZfNHEzbHhYxLjuTFWw9/cRO25DpxkO2xLOqXOMYkpdK
	t0jngJSuYdCEXqyRoeAh+tDHnnjIqnJxv2/H6MOUkbQdgaCD+IKZuxUeMqgYcUrBjsxhlF2dZm3
	PsePfYh7yR9s/DZ4kV1EI7epYcxDB+TbyrODTkg6HRajYBGBa5HcJFfVxOyRiDa0APBs4WkWzJl
	6HNdIAmfD2m5udMlCzL9DXxe8Ja1ibRWxP5pnAREwH19DwmIJSPByudYH9/ZQh2mOu832UWGjJm
	6x4GcQTvo6T7W30VSxg5GaSilm8jzlKOLp52NknYyuxNgvuO/whIHH0ojxpbrfDHnBz1G4n7Y29
	SCDyQg/8FMAY6Mt1+JEJwel/N4CIEnutXy0B7whHegP8P2zwidFvBU6AuFf2zR+77709fXrz1IT
	+kRyPcTl9qlkvmraNL0oMI+6b2sOup5IRTOarTJX0yf+RajzCR5SWx6O+sLuuGS47LEHZ7SEiFQ
	==
X-Received: by 2002:a05:6102:4412:b0:7d2:8529:6892 with SMTP id ada2fe7eead31-7d6ba3e7857mr1999245137.11.1795037334470;
        Wed, 18 Nov 2026 13:28:54 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6b9185bc3sm2724635137.5.2026.11.18.13.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:28:54 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	linux-api@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v6 6/7] selftests: liveupdate: Add unit tests for LIVEUPDATE_SESSION_FREEZE
Date: Wed, 18 Nov 2026 16:28:41 -0500
Message-ID: <20261118212845.2855249-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
In-Reply-To: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
References: <20261118212845.2855249-1-pasha.tatashin@soleen.com>
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

Add a luo_session_freeze() helper and unit tests in liveupdate.c for
LIVEUPDATE_SESSION_FREEZE. Verify negative cases (unsupported flags,
double freeze, and preserving files after freeze), that closing a
frozen uncommitted session unfreezes and returns resources, and that
closing a committed session retains LUO ownership of the session and
its preserved files.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |   1 +
 .../selftests/liveupdate/lib/lu_utils.c       |  13 +++
 .../testing/selftests/liveupdate/liveupdate.c | 107 ++++++++++++++++++
 3 files changed, 121 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..34657d6eb67b 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -26,6 +26,7 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 int luo_get_session_name(int session_fd, char *name, size_t name_len);
+int luo_session_freeze(int session_fd, __u32 flags);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..51384374305d 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -198,6 +198,19 @@ int luo_session_finish(int session_fd)
 	return 0;
 }
 
+int luo_session_freeze(int session_fd, __u32 flags)
+{
+	struct liveupdate_session_freeze arg = {
+		.size = sizeof(arg),
+		.flags = flags,
+	};
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_FREEZE, &arg) < 0)
+		return -errno;
+
+	return 0;
+}
+
 void create_state_file(int luo_fd, const char *session_name, int token,
 		       int next_stage)
 {
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534..4b0c0fb1be87 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -530,4 +530,111 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Session Freeze
+ *
+ * Verifies LIVEUPDATE_SESSION_FREEZE with flags == 0: unsupported flags return
+ * -EOPNOTSUPP, repeated freeze and post-freeze preserve return -EBUSY, and
+ * closing the session FD unfreezes the session and returns all resources.
+ */
+TEST_F(liveupdate_device, session_freeze)
+{
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = luo_create_session(self->fd1, "session-freeze");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("freeze-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, mem_fd1, 0x1111), 0);
+
+	/* Unsupported flag bits must fail with -EOPNOTSUPP */
+	EXPECT_EQ(luo_session_freeze(session_fd, 1U << 1), -EOPNOTSUPP);
+
+	/* Freeze the session */
+	ASSERT_EQ(luo_session_freeze(session_fd, 0), 0);
+
+	/* Subsequent freeze attempts must fail with -EBUSY */
+	EXPECT_EQ(luo_session_freeze(session_fd, 0), -EBUSY);
+	EXPECT_EQ(luo_session_freeze(session_fd,
+				     LIVEUPDATE_SESSION_FREEZE_COMMIT),
+		  -EBUSY);
+
+	/* Preserving a file after freeze must fail with -EBUSY */
+	mem_fd2 = memfd_create("freeze-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd, mem_fd2, 0x2222), -EBUSY);
+
+	/* Closing the session FD must unfreeze and unpreserve resources */
+	ASSERT_EQ(close(session_fd), 0);
+
+	session_fd = luo_create_session(self->fd1, "session-freeze");
+	ASSERT_GE(session_fd, 0);
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, mem_fd1, 0x1111), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
+/*
+ * Test Case: Session Freeze and Commit
+ *
+ * Verifies LIVEUPDATE_SESSION_FREEZE with LIVEUPDATE_SESSION_FREEZE_COMMIT:
+ * once committed, the frozen session is serialized into KHO and survives
+ * closing the session FD with ownership retained by LUO until reboot.
+ */
+TEST_F(liveupdate_device, session_freeze_commit)
+{
+	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	int session_fd, session_fd2, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	snprintf(name, sizeof(name), "freeze-commit-%d", getpid());
+	session_fd = luo_create_session(self->fd1, name);
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("freeze-commit-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, mem_fd1, 0x1111), 0);
+
+	/* Freeze and commit the session */
+	ASSERT_EQ(luo_session_freeze(session_fd,
+				     LIVEUPDATE_SESSION_FREEZE_COMMIT), 0);
+
+	/* Subsequent freeze attempts must fail with -EBUSY */
+	EXPECT_EQ(luo_session_freeze(session_fd, 0), -EBUSY);
+	EXPECT_EQ(luo_session_freeze(session_fd,
+				     LIVEUPDATE_SESSION_FREEZE_COMMIT),
+		  -EBUSY);
+
+	/* Preserving a file after freeze must fail with -EBUSY */
+	mem_fd2 = memfd_create("freeze-commit-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd, mem_fd2, 0x2222), -EBUSY);
+
+	/* Closing the session FD must retain LUO ownership of session & files */
+	ASSERT_EQ(close(session_fd), 0);
+
+	EXPECT_EQ(luo_create_session(self->fd1, name), -EEXIST);
+
+	session_fd2 = luo_create_session(self->fd1, "freeze-commit-check");
+	ASSERT_GE(session_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd2, mem_fd1, 0x3333),
+		  -EBUSY);
+
+	ASSERT_EQ(close(session_fd2), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.1.708.g77570a6a1d-goog

