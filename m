Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D59234F479
	for <linux-api@vger.kernel.org>; Fri, 23 Jan 2026 03:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769138834; cv=none; b=sPfwOECxWtIMEQuyY7/f107k7O3hvNlAoNs+aaBkgVRfXB8fkYcABa2nYsN+93pjWY7L/rgjXTspaYCk0fDD9KH1r3lLVjbmFYWflIeLRldYIjUb40RzOJfetfvyNI0ru8PgG/+85ufFzE4Ej+ayHkKMPHvWD9HxUXahfxy4Myo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769138834; c=relaxed/simple;
	bh=y1kKlElWA1x/XM6Wz5R/d/glsIS6y2hLv2QEDt32Fc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEXRxOwJtnqxc0NZcg4w3PEwKGuSMdwSn6qRLo62t4Ro0BAsBfaIzco+qf5Q5jEOfMLfxGTqsfMNoIMH7a+aubrMJURKBm3IjKFe1YNcfHTp/l+RjkBD+H4oiuQH328bTQHY8YSBEf8Y5K0Nh9A7mVDyImnc/m1dw4EojpXHH/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=owjQ6Zry; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="owjQ6Zry"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769138818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lUdsbdc1S8X/9qw1zh3i4z0z65VGYSHUbuVLsq9rNHU=;
	b=owjQ6Zrywu1+UzaCdloCz6uSqOV57ZHTYsNFI8iqdNGRP0NSFrmyRjmDb7cdOmE6fBzrd4
	xQM7J3rSeTs09UDnRnwsdFiOyS1Fn3DPTkVIdlY4GrTW7HUGTP0ksgMsFiv4iIOJkXuWz6
	sWbOn6Z/s4NNvsoYj9g0vfz5fdogG7o=
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
Subject: [PATCH bpf-next v7 6/9] bpf: Add syscall common attributes support for btf_load
Date: Fri, 23 Jan 2026 11:24:42 +0800
Message-ID: <20260123032445.125259-7-leon.hwang@linux.dev>
In-Reply-To: <20260123032445.125259-1-leon.hwang@linux.dev>
References: <20260123032445.125259-1-leon.hwang@linux.dev>
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
index 6241ef35c164..d17cb243c5b3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5433,7 +5433,8 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 
 #define BPF_BTF_LOAD_LAST_FIELD btf_token_fd
 
-static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr, __u32 uattr_size)
+static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr, __u32 uattr_size,
+			struct bpf_attrs *attrs_common)
 {
 	struct bpf_token *token = NULL;
 	struct bpf_log_attr log_attr;
@@ -5447,7 +5448,7 @@ static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr, __u32 uattr_
 		return -EINVAL;
 
 	bpf_attrs_init(&attrs, attr, uattr, uattr_size);
-	err = bpf_btf_load_log_attr_init(&log_attr, &attrs);
+	err = bpf_btf_load_log_attr_init(&log_attr, &attrs, attrs_common);
 	if (err)
 		return err;
 
@@ -6281,7 +6282,8 @@ static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size,
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

