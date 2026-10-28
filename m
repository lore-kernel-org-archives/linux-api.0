Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225899;
	b=muKCq86VdTf/ZXR6SLF3IbBifThZ56GcwtdCxaHVjI8hxQcalhx6WQ0qpZWfBl2XCeq3
	 GqsSooxSEasEZqElFymaxMHZFkOU4+KMTWIYANqP2WAnUQTesHatGZszeXy4FozAmgwXg
	 qM3GclGFalJVPk2wrUbgnNv3oM0+Ju1WjJQcopjjPmFpGovTCQE90RHwmV8xaGz90B3ll
	 DWl3EwE5OcJyfdWzroSQkSzWPdvz5fC2lYevCjGq3a7wSs6RFBtOr8itKeQ4dcThqfKsW
	 SJYTLGnh/1VsNJxvjNOfVlazAFZjOB8M5GbmcmJ2y191dvD7esRnsIuHvnapMxOoPiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225899;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=uR8d+2KzOCc+PCIXuOJ1VzHWTSd8KrcryDy/HkQ7hhE=;
	b=1qNKWfNmyshwYnRiboFY8btBdaoJCF2x9x4xJ9MWPphMWZziERZ4FqI6CpCeBgtHcsDt
	 w4If13ZZtxmYa/MBL9wPGVEaFee5NprcAbDIigZa4JnU1CI9BzLFPQ6+BbrSppYLm4qnp
	 NphTxS+63LO94UUnDMa61nqxCq17jgGBIkLkj5YGnlj0p4u38/kroXVmUB5ze/FQjm3u7
	 mrjelkpd5O/CAOBGBPA2nukUwe355LcEysjgZY6jSG6jF/ZpGA652Ec4t9nblxX9cQseZ
	 ycNwjxg4w4+dZt57R0EFByf5c2gQBIATndyJgAl53RCGzR5DbfZEUrf2beYnl1dztGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Naryf3Bo;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C16060A381F
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 22:18:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C16060A381F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Naryf3Bo
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c465c4c8da0so171249866b.2
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793225898; x=1793830698; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uR8d+2KzOCc+PCIXuOJ1VzHWTSd8KrcryDy/HkQ7hhE=;
        b=Naryf3BoTAgS7QAbA7uYgHtdsAfs7go5S+lar2IQfYFDv+/JIJ9a7cszrFOIZyL6tf
         5oHhU63oYx1IVKr5VVmiPISjhp7vO2E584Gxm/ZlmYR4cR3jO3py+08IctQz99Ceq0b5
         knm4LT9KQ5d6cLNyJdOeTTcqHGZpa2l1BhNVnLLUm+zVb547MxbQMXAjvcxSC4KBVe74
         3q/OpGcIrLthHI11T5bhowkmTxjrPp0t7IOcoE0BuEFX68r9dguAB6apV5AbAu6PtQ9C
         1Lso0n8Fq2kIvChHX0JFsJ+iuIEJ6dHrONLyb9LF8ShWotR9Bs9jZoyKrJyQuit9FpEP
         A1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225898; x=1793830698;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uR8d+2KzOCc+PCIXuOJ1VzHWTSd8KrcryDy/HkQ7hhE=;
        b=1uS7+0PixnS0/tT04Q6ssn+KE5YMZ0lU3a53XRVWV2ZOi9OwNVKAHthwqB+Tcpc8Jk
         /wvcBMHt4f9NLVmjgqapMSxrdGbqymNWXVlL65DMV2ucbUIHQ93vs7juW0Kdc4sgPmkz
         UIh3ug2DTwzJx2U9UQU7tLDJ1iLKta7iJLILCtRHNhO9Zy5ez6VKmL7xs7Q7+35G993R
         xwN3bsKrFOXASBDgHzuJ14ffa8RVGou6HwHKYFD+nUhOHD4cd8p3paN8870kHHqIrD03
         BWyK5COJFmOVySkDMTqupQQgcdiDCx4IHBAYRsvYMKN1oOlA2tTrod+Xr2Q1Edh/s6S4
         7fMQ==
X-Forwarded-Encrypted: i=1; AKwUvBw3mbOfedJ9P6M4bLNsEPyF93tid/2t2EzTN1P9EmxNEup6h5yrEvmtf5+LB0tZrKXEHpPMFH4RMnQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYKqF16HBgSZSoGOkbr8EdUquGtZmWubT57g1VzxzAIiGv9wbc5C
	NWY0HXdNxL/pYwOhdESCYfjyEl7CzlU6Ox5t+dXyfdhshRxmfSb8PBEZvUvtmqw6xi0by+lChA=
	=
X-Received: from ejckx26.prod.google.com ([2002:a17:907:775a:b0:c31:9629:c57e])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:868c:b0:c26:1648:a06b
 with SMTP id a640c23a62f3a-c49bdf5c1e6mr326815366b.38.1793225897748; Wed, 28
 Oct 2026 15:18:17 -0700 (PDT)
Date: Wed, 28 Oct 2026 22:17:04 +0000
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
Message-ID: <20261028221705.3915340-8-halg@google.com>
Subject: [PATCH 7/8] selftests/capabilities: add clone3() tests for CLONE_NEWUSER_BSET
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

Add tests to userns_bounding_set_test to verify per-namespace
capability bounding via CLONE_NEWUSER_BSET.

Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 .../capabilities/userns_bounding_set_test.c   | 146 ++++++++++++++++++
 .../selftests/clone3/clone3_selftests.h       |   1 +
 2 files changed, 147 insertions(+)

diff --git a/tools/testing/selftests/capabilities/userns_bounding_set_test.c b/tools/testing/selftests/capabilities/userns_bounding_set_test.c
index 798758e0705d..140c12e16e9e 100644
--- a/tools/testing/selftests/capabilities/userns_bounding_set_test.c
+++ b/tools/testing/selftests/capabilities/userns_bounding_set_test.c
@@ -417,4 +417,150 @@ TEST_F(userns_bset, parent_owner_cap_restricted)
 	EXPECT_EQ(EPERM, run_parent_owner_setns(restricted_mask));
 }
 
+/*
+ * Verify that CLONE_NEWUSER_BSET restricts capabilities in the child user
+ * namespace even when the global sysctl allows all capabilities.
+ */
+TEST_F(userns_bset, clone3_bset_restriction)
+{
+	struct __clone_args args = {
+		.flags = CLONE_NEWUSER | CLONE_NEWUSER_BSET,
+		.exit_signal = SIGCHLD,
+		.cap_bset = cap_full_set & ~(1ULL << CAP_NET_ADMIN),
+	};
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(cap_full_set));
+
+	pid = sys_clone3(&args, sizeof(args));
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (!cap_raised(CAP_SYS_ADMIN))
+			_exit(1);
+		if (!cap_dropped(CAP_NET_ADMIN))
+			_exit(2);
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Verify that passing cap_bset = 0 with CLONE_NEWUSER_BSET drops all
+ * capabilities in the new user namespace.
+ */
+TEST_F(userns_bset, clone3_bset_empty)
+{
+	struct __clone_args args = {
+		.flags = CLONE_NEWUSER | CLONE_NEWUSER_BSET,
+		.exit_signal = SIGCHLD,
+		.cap_bset = 0,
+	};
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(cap_full_set));
+
+	pid = sys_clone3(&args, sizeof(args));
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		if (!cap_dropped(CAP_SYS_ADMIN))
+			_exit(1);
+		if (!cap_dropped(CAP_NET_ADMIN))
+			_exit(2);
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Verify that an unprivileged caller cannot use CLONE_NEWUSER_BSET to bypass
+ * the global sysctl ceiling.
+ */
+TEST_F(userns_bset, clone3_bset_cannot_bypass_sysctl)
+{
+	uint64_t restricted_mask = cap_full_set & ~(1ULL << CAP_NET_ADMIN);
+	pid_t pid;
+	int status;
+
+	ASSERT_EQ(0, write_sysctl_caps(restricted_mask));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (pid == 0) {
+		struct __clone_args args = {
+			.flags = CLONE_NEWUSER | CLONE_NEWUSER_BSET,
+			.exit_signal = SIGCHLD,
+			.cap_bset = cap_full_set,
+		};
+		int child_status;
+		pid_t child;
+
+		if (drop_privileges() != 0)
+			_exit(1);
+
+		child = sys_clone3(&args, sizeof(args));
+		if (child < 0)
+			_exit(2);
+
+		if (child == 0) {
+			if (!cap_raised(CAP_SYS_ADMIN))
+				_exit(3);
+			if (!cap_dropped(CAP_NET_ADMIN))
+				_exit(4);
+			_exit(0);
+		}
+
+		if (waitpid(child, &child_status, 0) != child ||
+		    !WIFEXITED(child_status) || WEXITSTATUS(child_status) != 0)
+			_exit(5);
+
+		_exit(0);
+	}
+
+	ASSERT_EQ(pid, waitpid(pid, &status, 0));
+	ASSERT_TRUE(WIFEXITED(status));
+	EXPECT_EQ(0, WEXITSTATUS(status));
+}
+
+/*
+ * Verify clone3() argument validation for CLONE_NEWUSER_BSET.
+ */
+TEST_F(userns_bset, clone3_bset_invalid_args)
+{
+	struct __clone_args args;
+
+	/* CLONE_NEWUSER_BSET without CLONE_NEWUSER must fail */
+	memset(&args, 0, sizeof(args));
+	args.flags = CLONE_NEWUSER_BSET;
+	args.exit_signal = SIGCHLD;
+	args.cap_bset = cap_full_set;
+	EXPECT_EQ(-1, sys_clone3(&args, sizeof(args)));
+	EXPECT_EQ(EINVAL, errno);
+
+	/* Non-zero cap_bset without CLONE_NEWUSER_BSET must fail */
+	memset(&args, 0, sizeof(args));
+	args.flags = CLONE_NEWUSER;
+	args.exit_signal = SIGCHLD;
+	args.cap_bset = cap_full_set;
+	EXPECT_EQ(-1, sys_clone3(&args, sizeof(args)));
+	EXPECT_EQ(EINVAL, errno);
+
+	/* CLONE_NEWUSER_BSET with struct size < VER3 must fail */
+	memset(&args, 0, sizeof(args));
+	args.flags = CLONE_NEWUSER | CLONE_NEWUSER_BSET;
+	args.exit_signal = SIGCHLD;
+	EXPECT_EQ(-1, sys_clone3(&args, CLONE_ARGS_SIZE_VER2));
+	EXPECT_EQ(EINVAL, errno);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/clone3/clone3_selftests.h b/tools/testing/selftests/clone3/clone3_selftests.h
index a0593e8950f0..2145d14956e5 100644
--- a/tools/testing/selftests/clone3/clone3_selftests.h
+++ b/tools/testing/selftests/clone3/clone3_selftests.h
@@ -31,6 +31,7 @@ struct __clone_args {
 	__aligned_u64 set_tid;
 	__aligned_u64 set_tid_size;
 	__aligned_u64 cgroup;
+	__aligned_u64 cap_bset;
 };
 
 static pid_t sys_clone3(struct __clone_args *args, size_t size)
-- 
2.56.0.313.g2479322e68-goog

