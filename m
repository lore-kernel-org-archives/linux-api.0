Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FA133E362
	for <linux-api@vger.kernel.org>; Mon, 26 Jan 2026 15:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769440577; cv=none; b=oR5tfiGJ2rOrzpiVeUmwvAS/bNN2AaAYZQUCtq+CmPreDNUHC2OrATnHmXd6Aa189GKsp4X2oUFL+vk9hDDgvsnI0Cm0UTCduB4bzbJCwoh3xhezWCpfCP1gMA53TJ8J6RAsG1ErXsXjZ/OMd37pvj96GJK1O7xTQrmm9xM0bno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769440577; c=relaxed/simple;
	bh=j7dw6UF6ug58KgBwYKbX0sX0RWaqzYAcnVLqOfVXLSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk4ulJ8uvj6FfPFXp85qgNFreMfAgGwS3vIyY1Aqs0Y7+j0Ryz0cb7IZ/3tMITUJm43zZlmFKGO4++UBz77Yo6gOQ8bvTQbipdKp9lgLZXp5v1XDWuCz+WY0YVqNcog/yak6JRN4dBn9FQaSN9Gdq896L/Jb1e831mBzXzww3EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cY8aGCwK; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cY8aGCwK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769440563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mHNwhGZ/a7bs2rBmc5MNX1NQzbdUO+5ibn0YYAlaad0=;
	b=cY8aGCwK2DtIqjbBpveG/aklLDp0XdpvQQKJGaQrXJG4vgRVWD3L4lm3RujVtL2e6ZP3QS
	x4kc5GzLpWnbgoij//0NJNSqzfEbbo4iLaj+db13Yojghw4UxFOMOVgI8j3sx5BjVWWfHb
	cWaPNOYJfc/qwAGrHkM89/4BdAy4xlY=
From: Leon Hwang <leon.hwang@linux.dev>
To: bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Seth Forshee <sforshee@kernel.org>,
	Yuichiro Tsuji <yuichtsu@amazon.com>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-patches-bot@fb.com
Subject: [PATCH bpf-next v8 6/9] bpf: Add syscall common attributes support for btf_load
Date: Mon, 26 Jan 2026 23:14:06 +0800
Message-ID: <20260126151409.52072-7-leon.hwang@linux.dev>
In-Reply-To: <20260126151409.52072-1-leon.hwang@linux.dev>
References: <20260126151409.52072-1-leon.hwang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since bpf_log_attr_init() now supports struct bpf_common_attr, pass the
common attributes to it to enable syscall common attributes support for
BPF_BTF_LOAD.

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 include/linux/bpf_verifier.h | 3 ++-
 kernel/bpf/log.c             | 5 +++--
 kernel/bpf/syscall.c         | 8 +++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 28e22a03ac84..732bc4baee1c 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -642,7 +642,8 @@ struct bpf_log_attr {
 
 int bpf_prog_load_log_attr_init(struct bpf_log_attr *log_attr, struct bpf_attrs *attrs,
 				struct bpf_attrs *attrs_common);
-int bpf_btf_load_log_attr_init(struct bpf_log_attr *log_attr, struct bpf_attrs *attrs);
+int bpf_btf_load_log_attr_init(struct bpf_log_attr *log_attr, struct bpf_attrs *attrs,
+			       struct bpf_attrs *attrs_common);
 int bpf_log_attr_finalize(struct bpf_log_attr *log_attr, struct bpf_verifier_log *log);
 
 #define BPF_MAX_SUBPROGS 256
diff --git a/kernel/bpf/log.c b/kernel/bpf/log.c
index f1ed24157d71..3cccb0c5e482 100644
--- a/kernel/bpf/log.c
+++ b/kernel/bpf/log.c
@@ -902,13 +902,14 @@ int bpf_prog_load_log_attr_init(struct bpf_log_attr *log_attr, struct bpf_attrs
 				 offsetof(union bpf_attr, log_true_size), attrs_common);
 }
 
-int bpf_btf_load_log_attr_init(struct bpf_log_attr *log_attr, struct bpf_attrs *attrs)
+int bpf_btf_load_log_attr_init(struct bpf_log_attr *log_attr, struct bpf_attrs *attrs,
+			       struct bpf_attrs *attrs_common)
 {
 	const union bpf_attr *attr = attrs->attr;
 
 	return bpf_log_attr_init(log_attr, attrs, attr->btf_log_buf, attr->btf_log_size,
 				 attr->btf_log_level, offsetof(union bpf_attr, btf_log_true_size),
-				 NULL);
+				 attrs_common);
 }
 
 int bpf_log_attr_finalize(struct bpf_log_attr *log_attr, struct bpf_verifier_log *log)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1ed007511776..040b105ab676 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5449,7 +5449,8 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 
 #define BPF_BTF_LOAD_LAST_FIELD btf_token_fd
 
-static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr, __u32 uattr_size)
+static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr, __u32 uattr_size,
+			struct bpf_attrs *attrs_common)
 {
 	struct bpf_token *token = NULL;
 	struct bpf_log_attr log_attr;
@@ -5463,7 +5464,7 @@ static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr, __u32 uattr_
 		return -EINVAL;
 
 	bpf_attrs_init(&attrs, attr, uattr, uattr_size);
-	err = bpf_btf_load_log_attr_init(&log_attr, &attrs);
+	err = bpf_btf_load_log_attr_init(&log_attr, &attrs, attrs_common);
 	if (err)
 		return err;
 
@@ -6297,7 +6298,8 @@ static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size,
 		err = bpf_raw_tracepoint_open(&attr);
 		break;
 	case BPF_BTF_LOAD:
-		err = bpf_btf_load(&attr, uattr, size);
+		bpf_attrs_init(&attrs_common, &attr_common, uattr_common, size_common);
+		err = bpf_btf_load(&attr, uattr, size, &attrs_common);
 		break;
 	case BPF_BTF_GET_FD_BY_ID:
 		err = bpf_btf_get_fd_by_id(&attr);
-- 
2.52.0

