Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002A1314B91;
	Mon, 16 Feb 2026 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771254414; cv=none; b=TkmEmNVFrVaa7s1rud5+w5zPdx04mXQWgkl0SWBOyBWBWlaYScr7p+qKdpM5/9BVDEp0bIbliMGAsiNv6exaGyHWkDpT7CR8/Wpf35caTCD8FVGnXOW8AqyAYCMzgFItBO23bGWftO346NrZ2Cht0akoEbekoKDl7dfpwCuKgbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771254414; c=relaxed/simple;
	bh=MniUfsXm35VlpPAC10yUhsc1/tywBRIQaETCuy/HQUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkC7HBS5dCsxvw3Fl9ktvWYFpLmTkfq94TIhnu7xuLNCoKE/O0teLARWIdekugZLfKFNvh7E809ILnL8vkLzsq001Uqu9XAgnG6ybuNkgMsNA/4y031nuI3sR9h33J/TjkorTwa350Iq6eYpAAg7gdbUqwmmNXqqHQuDVmA6ulk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J1d+XsmR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J1d+XsmR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771254410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pd+XEM/uBOYtPAyprTQvce3wuyLfg25eqbS4ipXXqUk=;
	b=J1d+XsmRKtjzVV3oHSDUSa7AXBQL59q29LPMio73TKo9avVP5ZqOU+ZYAasmRGs63+5lHi
	c4mARZXmrQ9JjuOCiP+113qc0JFUIxHBRp9gZKvMoF+SAAFjQzOoxYEPc7Vga6Avfz6IJZ
	3uxzKBII4ODX0taSnC8aLuWSg9ZtY2c=
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
Subject: [PATCH bpf-next v11 4/8] bpf: Add syscall common attributes support for prog_load
Date: Mon, 16 Feb 2026 23:04:41 +0800
Message-ID: <20260216150445.68278-5-leon.hwang@linux.dev>
In-Reply-To: <20260216150445.68278-1-leon.hwang@linux.dev>
References: <20260216150445.68278-1-leon.hwang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

BPF_PROG_LOAD can now take log parameters from both union bpf_attr and
struct bpf_common_attr. The merge rules are:

- if both sides provide a complete log tuple (buf/size/level) and they
  match, use it;
- if only one side provides log parameters, use that one;
- if both sides provide complete tuples but they differ, return -EINVAL.

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 include/linux/bpf_verifier.h |  3 ++-
 kernel/bpf/log.c             | 38 ++++++++++++++++++++++++++++--------
 kernel/bpf/syscall.c         |  2 +-
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index b21cb7066f6f..de1d42a48af5 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -642,7 +642,8 @@ struct bpf_log_attr {
 };
 
 int bpf_log_attr_init(struct bpf_log_attr *log, u64 log_buf, u32 log_size, u32 log_level,
-		      u32 __user *log_true_size);
+		      u32 __user *log_true_size, struct bpf_common_attr *common, bpfptr_t uattr,
+		      u32 size);
 int bpf_log_attr_finalize(struct bpf_log_attr *attr, struct bpf_verifier_log *log);
 
 #define BPF_MAX_SUBPROGS 256
diff --git a/kernel/bpf/log.c b/kernel/bpf/log.c
index d4dbf2465620..a1c0c42b0b8c 100644
--- a/kernel/bpf/log.c
+++ b/kernel/bpf/log.c
@@ -13,17 +13,17 @@
 
 #define verbose(env, fmt, args...) bpf_verifier_log_write(env, fmt, ##args)
 
-static bool bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log)
+static bool bpf_verifier_log_attr_valid(u32 log_level, char __user *log_buf, u32 log_size)
 {
 	/* ubuf and len_total should both be specified (or not) together */
-	if (!!log->ubuf != !!log->len_total)
+	if (!!log_buf != !!log_size)
 		return false;
 	/* log buf without log_level is meaningless */
-	if (log->ubuf && log->level == 0)
+	if (log_buf && log_level == 0)
 		return false;
-	if (log->level & ~BPF_LOG_MASK)
+	if (log_level & ~BPF_LOG_MASK)
 		return false;
-	if (log->len_total > UINT_MAX >> 2)
+	if (log_size > UINT_MAX >> 2)
 		return false;
 	return true;
 }
@@ -36,7 +36,7 @@ int bpf_vlog_init(struct bpf_verifier_log *log, u32 log_level,
 	log->len_total = log_size;
 
 	/* log attributes have to be sane */
-	if (!bpf_verifier_log_attr_valid(log))
+	if (!bpf_verifier_log_attr_valid(log_level, log_buf, log_size))
 		return -EINVAL;
 
 	return 0;
@@ -867,13 +867,35 @@ void print_insn_state(struct bpf_verifier_env *env, const struct bpf_verifier_st
 }
 
 int bpf_log_attr_init(struct bpf_log_attr *log, u64 log_buf, u32 log_size, u32 log_level,
-		      u32 __user *log_true_size)
+		      u32 __user *log_true_size, struct bpf_common_attr *common, bpfptr_t uattr,
+		      u32 size)
 {
+	char __user *ubuf_common = u64_to_user_ptr(common->log_buf);
+	char __user *ubuf = u64_to_user_ptr(log_buf);
+
+	if (!bpf_verifier_log_attr_valid(common->log_level, ubuf_common, common->log_size) ||
+	    !bpf_verifier_log_attr_valid(log_level, ubuf, log_size))
+		return -EINVAL;
+
+	if (ubuf && ubuf_common && (ubuf != ubuf_common || log_size != common->log_size ||
+				    log_level != common->log_level))
+		return -EINVAL;
+
 	memset(log, 0, sizeof(*log));
-	log->log_buf = u64_to_user_ptr(log_buf);
+	log->log_buf = ubuf;
 	log->log_size = log_size;
 	log->log_level = log_level;
 	log->log_true_size = log_true_size;
+
+	if (!ubuf && ubuf_common) {
+		log->log_buf = ubuf_common;
+		log->log_size = common->log_size;
+		log->log_level = common->log_level;
+		log->log_true_size = NULL;
+		if (size >= offsetofend(struct bpf_common_attr, log_true_size))
+			log->log_true_size = uattr.user +
+				offsetof(struct bpf_common_attr, log_true_size);
+	}
 	return 0;
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d6fa752401a9..f37396f71e8d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6248,7 +6248,7 @@ static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size,
 		if (from_user && size >= offsetofend(union bpf_attr, log_true_size))
 			log_true_size = uattr.user + offsetof(union bpf_attr, log_true_size);
 		err = bpf_log_attr_init(&attr_log, attr.log_buf, attr.log_size, attr.log_level,
-					log_true_size);
+					log_true_size, &attr_common, uattr_common, size_common);
 		err = err ?: bpf_prog_load(&attr, uattr, &attr_log);
 		break;
 	case BPF_OBJ_PIN:
-- 
2.52.0

