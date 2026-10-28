Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225914;
	b=G0fuSu1VdEc+4psKr8CHAoPfVGszKYAXKPhfUvWmvmha80A1kmXobBNNYULEVTisMSwn
	 kM98m4Ow8rxZJ2vSWx86aU7p2wvUGXTPZspLzFJtnrBO/8l47lvMo73bzr09OtdcL24c1
	 PfDmJYYX4FAV9MrXaJT7hwXkcgKhbtwcI06uYfvaLoauEZB38VNCNLXuOH2tO/VBN/lKa
	 R/leV3vrLnoPfPW0B6JHTxBj+4qRLEIs38UkkKbw8DiqxjOS2BH6bxc5tAS8hXrbM48YT
	 nF+w01WemVH9sTRZH/IhMmOPkZ0UxVSGFcjHgC5RqxuFa2BSocs/2XHQfl0p5lbddZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225914;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=O3jI53IvGMjui3qM6yb8MAnyltVbJGBw/n9i8mncKWg=;
	b=HvgKAbcl0NSgFHbXMUxHNP+Ej8YCK144HQPujbSJGTxzddI4s66syaB4y8TdMVqsjS7N
	 avFUa/zORVDhXHnw2uYr3hP4wfhSidbkJt+RXNIMwbn2DdaAkaI+iPx7k28O/IgBOgatB
	 qzbaLL8j32bnbMAewew3zgyIEjD05bOLvbhBBkYWfDPei4yvr8dbLQUH77Jz98HKgGyex
	 lC0B3w+TvEdBciqEbN5Z6bcQ47gBW0I5dkFJzkGFDeeJKD5D3GZiwfBTXKoLJkqZZQQYC
	 qWflwL6421i1suwERSU4CLym0VhdEFCIz/gRxllFK7H0esZBTVKSYHinjoHvQUGFIxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZocZJ6fm;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A31060A5BC4
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 22:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A31060A5BC4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZocZJ6fm
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c41dae9db9dso147782266b.2
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793225899; x=1793830699; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O3jI53IvGMjui3qM6yb8MAnyltVbJGBw/n9i8mncKWg=;
        b=ZocZJ6fmNbV1TfdYdsOMCEl0qWX8N3eFzH/u4GRw09k6dmxM/tq2H/RruUScFwtoFY
         LlLlFx/WAwBD+j19yldTxYyQKpxfNoqfQimaMqQ1ZZx9H5MrwNdEgryllmDk834aXdgT
         n525rXNjQTppvAF3SeM4QeqsRs/nddO07X5aZRYGgacWMN+ovuxez+GkR31/sil69fLK
         E1MuMlQU8Cvtwpsp+kKlDyunAYnV2JIRJ/WrUnNqwTR6tuTWtZWZsc4pmXwjpr7sK2NK
         1QFGq77AxEUSq/bZC4ZovdO1+8DqqbFpKRA60xvycYhhr3jS+O2OjNZPaPNicnj4Vm53
         IAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225899; x=1793830699;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O3jI53IvGMjui3qM6yb8MAnyltVbJGBw/n9i8mncKWg=;
        b=WoPD1wJyVYG19Jsqh4a3kenqLSA5gYmd2EHkByObjRdZ8siLjlpz0bZ6Xcj6UlYXY5
         Ad7hTvmg/M0nGElh4++cy6oG/0/SIekM4+3V4nfrBa7dNm4BbVxQQxZDZwyIRGNzPiCS
         zNsXKnivvVdBvKgKTii+jkqQ7YbxmolzLSmfUJPl1X5uvZpeO4/eeaQK094C1+I5tKsV
         fiu7Mb2wouxNAL09BatNg+HXMUafUrIxcENgV7/u5xV5sN5BQontFDgh0UyhBqGNO5n3
         WHps5xqdMHQg8UbACJLbS947jx14lKt8GX1JFJ2TGWjwkhzgSx2r5+MPSIcHPWSeTj16
         IShw==
X-Forwarded-Encrypted: i=1; AKwUvBxOFBH8H+lCdwQlnsgCXgTP8CH4DhL7rJOZ5mdWGxNZc6VmQgOtYgcWhKa1A6j+ye3sq8kl6QMHqZ8=@vger.kernel.org
X-Gm-Message-State: AFq9FYKkCloXTkR83fhWzEaOE6dTldqfSYjaD7pt8O+pY+MNei8/Nfqi
	ohv33rceYU8+ThyuXQYS7J025Uz4NIK6NIgt4arf7Nh621ZZODL9gcZl4ephF9pgQ4IojNNQEw=
	=
X-Received: from ejbch15.prod.google.com ([2002:a17:906:c2cf:b0:c2e:81fe:4522])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:980c:b0:c2e:4d39:b5a1
 with SMTP id a640c23a62f3a-c49bdf2c6efmr324604666b.17.1793225898939; Wed, 28
 Oct 2026 15:18:18 -0700 (PDT)
Date: Wed, 28 Oct 2026 22:17:05 +0000
In-Reply-To: <20261028221705.3915340-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028221705.3915340-9-halg@google.com>
Subject: [PATCH 8/8] selftests/nsfs: add tests for NS_USER_GET_INFO ioctl
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Jan Kara <jack@suse.cz>, James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

Add tests for the NS_USER_GET_INFO ioctl to verify user namespace
capability bounding set inspection and validate error paths.

Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 .../selftests/filesystems/nsfs/.gitignore     |   1 +
 .../selftests/filesystems/nsfs/Makefile       |   4 +-
 .../selftests/filesystems/nsfs/userns.c       | 120 ++++++++++++++++++
 3 files changed, 123 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/filesystems/nsfs/userns.c

diff --git a/tools/testing/selftests/filesystems/nsfs/.gitignore b/tools/testing/selftests/filesystems/nsfs/.gitignore
index 92a8249006d1..b0a59f5d49fc 100644
--- a/tools/testing/selftests/filesystems/nsfs/.gitignore
+++ b/tools/testing/selftests/filesystems/nsfs/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 owner
 pidns
+userns
 iterate_mntns
diff --git a/tools/testing/selftests/filesystems/nsfs/Makefile b/tools/testing/selftests/filesystems/nsfs/Makefile
index 231aaa7dfd95..9408d7948621 100644
--- a/tools/testing/selftests/filesystems/nsfs/Makefile
+++ b/tools/testing/selftests/filesystems/nsfs/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-TEST_GEN_PROGS := owner pidns iterate_mntns
+TEST_GEN_PROGS := owner pidns iterate_mntns userns
 
-CFLAGS := -Wall -Werror
+CFLAGS += -Wall -Werror $(KHDR_INCLUDES)
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/nsfs/userns.c b/tools/testing/selftests/filesystems/nsfs/userns.c
new file mode 100644
index 000000000000..70661a495afc
--- /dev/null
+++ b/tools/testing/selftests/filesystems/nsfs/userns.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <sys/ioctl.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include <linux/nsfs.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+
+#include "../../clone3/clone3_selftests.h"
+#include "../../kselftest_harness.h"
+
+TEST(user_get_info_self)
+{
+	struct user_ns_info info = {};
+	int fd;
+
+	fd = open("/proc/self/ns/user", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(fd, 0) {
+		TH_LOG("Failed to open /proc/self/ns/user: %m");
+	}
+
+	ASSERT_EQ(0, ioctl(fd, NS_USER_GET_INFO, &info)) {
+		TH_LOG("ioctl(NS_USER_GET_INFO) failed on self: %m");
+	}
+	close(fd);
+
+	EXPECT_EQ(USER_NS_INFO_SIZE_VER0, info.size);
+	EXPECT_EQ(0, info.spare);
+	EXPECT_NE(0ULL, info.cap_bset);
+}
+
+TEST(user_get_info_restricted_bset)
+{
+	struct __clone_args args = {
+		.flags = CLONE_NEWUSER | CLONE_NEWUSER_BSET,
+		.exit_signal = SIGCHLD,
+		.cap_bset = 0,
+	};
+	int status;
+	pid_t pid;
+
+	pid = sys_clone3(&args, sizeof(args));
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		struct user_ns_info info = {};
+		int fd;
+
+		fd = open("/proc/self/ns/user", O_RDONLY | O_CLOEXEC);
+		if (fd < 0)
+			_exit(1);
+
+		if (ioctl(fd, NS_USER_GET_INFO, &info) != 0) {
+			close(fd);
+			_exit(2);
+		}
+		close(fd);
+
+		if (info.cap_bset != 0)
+			_exit(3);
+
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+TEST(user_get_info_invalid_ns_type)
+{
+	struct user_ns_info info = {};
+	int mntns_fd;
+
+	mntns_fd = open("/proc/self/ns/mnt", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(mntns_fd, 0) {
+		TH_LOG("Failed to open /proc/self/ns/mnt: %m");
+	}
+
+	EXPECT_EQ(-1, ioctl(mntns_fd, NS_USER_GET_INFO, &info));
+	EXPECT_EQ(EINVAL, errno);
+
+	close(mntns_fd);
+}
+
+TEST(user_get_info_buffer_too_small)
+{
+	__u32 small_buf = 0;
+	int fd;
+
+	fd = open("/proc/self/ns/user", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(fd, 0);
+
+	/* Encode a buffer size smaller than USER_NS_INFO_SIZE_VER0 (4B vs 16B) */
+	EXPECT_EQ(-1, ioctl(fd, _IOR(NSIO, 14, __u32), &small_buf));
+
+	close(fd);
+}
+
+TEST(user_get_info_null_arg)
+{
+	int fd;
+
+	fd = open("/proc/self/ns/user", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(fd, 0);
+
+	EXPECT_EQ(-1, ioctl(fd, NS_USER_GET_INFO, NULL));
+	EXPECT_EQ(EINVAL, errno);
+
+	close(fd);
+}
+
+TEST_HARNESS_MAIN
-- 
2.56.0.313.g2479322e68-goog

