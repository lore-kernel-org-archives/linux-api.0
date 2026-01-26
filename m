Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B70252900
	for <linux-api@vger.kernel.org>; Mon, 26 Jan 2026 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769440491; cv=none; b=gImlmnapqt3Y9nAcO01tIWlZJvr5qMbU9rzSXPpnLZWXEiuD0armmIpclnTcVMLLGiS/P9qmc4wLKH5uRDOVlpEyv1IO2vTWq6D6JfAzVwMavNdDDkP1ZfLGEQgkzqqQ5YKBvFAjSBYJBzOrUkiO1K9PaIXaL9sou5NTHcfpngg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769440491; c=relaxed/simple;
	bh=EfDci4aAKrGFTvZ1ZqjNhcJ4BLNu5tXigdVPS+fkkrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5kzE00y3bHt0/Que5rp5WygWkN0BWRJaLldJlgnYMSiVVCfpw2taKkBUT7BJovzpj0BSU3uJwa5rb1CXKSgrlTFU/g5mJ+sCj1P1QWGVE1zBzEXhtB2nVCEgOnu8DxtvFZEFjStwntJAOpaBm8/4EJvEQU6uy6hENQ6H6fNQTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AUQSoQKC; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AUQSoQKC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769440486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kBQU738wkB0LE2d5CWz2sTQKdf2BsoSEej9rnF/lOwI=;
	b=AUQSoQKC8CVM2j+LC0CxsNjJNVarUwhgx9bGLacU4wiR94BJfYFnFP4h3I9PWB6S7fOafH
	YrYHuqBlhpDwocNznGB8t8zQC8EYHXh8UX5qwuEbj7lK9qxx6LHx00+JTYgBnwY3OwcsMc
	yRF/3CZP6m/GVZb0flqp0JEBmc/2W/g=
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
Subject: [PATCH bpf-next v8 1/9] bpf: Extend BPF syscall with common attributes support
Date: Mon, 26 Jan 2026 23:14:01 +0800
Message-ID: <20260126151409.52072-2-leon.hwang@linux.dev>
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

Extend the BPF syscall to support a set of common attributes shared
across all BPF commands:

1. 'log_buf': User-provided buffer for storing logs.
2. 'log_size': Size of the log buffer.
3. 'log_level': Log verbosity level.
4. 'log_true_size': The size of log reported by kernel.

These common attributes are passed as the 4th argument to the BPF
syscall, with the 5th argument specifying the size of this structure.

To indicate the use of these common attributes from userspace, a new flag
'BPF_COMMON_ATTRS' ('1 << 16') is introduced. This flag is OR-ed into the
'cmd' field of the syscall.

When 'cmd & BPF_COMMON_ATTRS' is set, the kernel will copy the common
attributes from userspace into kernel space for use.

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 include/linux/syscalls.h       |  3 ++-
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/syscall.c           | 25 +++++++++++++++++++++----
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index cf84d98964b2..729659202d77 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -937,7 +937,8 @@ asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
 			      unsigned int flags);
 asmlinkage long sys_memfd_create(const char __user *uname_ptr, unsigned int flags);
-asmlinkage long sys_bpf(int cmd, union bpf_attr __user *attr, unsigned int size);
+asmlinkage long sys_bpf(int cmd, union bpf_attr __user *attr, unsigned int size,
+			struct bpf_common_attr __user *attr_common, unsigned int size_common);
 asmlinkage long sys_execveat(int dfd, const char __user *filename,
 			const char __user *const __user *argv,
 			const char __user *const __user *envp, int flags);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 44e7dbc278e3..656757e7a4fb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -986,6 +986,7 @@ enum bpf_cmd {
 	BPF_PROG_STREAM_READ_BY_FD,
 	BPF_PROG_ASSOC_STRUCT_OPS,
 	__MAX_BPF_CMD,
+	BPF_COMMON_ATTRS = 1 << 16, /* Indicate carrying syscall common attrs. */
 };
 
 enum bpf_map_type {
@@ -1492,6 +1493,13 @@ struct bpf_stack_build_id {
 	};
 };
 
+struct bpf_common_attr {
+	__u64 log_buf;
+	__u32 log_size;
+	__u32 log_level;
+	__u32 log_true_size;
+};
+
 #define BPF_OBJ_NAME_LEN 16U
 
 enum {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b9184545c3fd..69bfcffb4389 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -6179,8 +6179,10 @@ static int prog_assoc_struct_ops(union bpf_attr *attr)
 	return ret;
 }
 
-static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size)
+static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size,
+		     bpfptr_t uattr_common, unsigned int size_common)
 {
+	struct bpf_common_attr attr_common;
 	union bpf_attr attr;
 	int err;
 
@@ -6194,6 +6196,20 @@ static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size)
 	if (copy_from_bpfptr(&attr, uattr, size) != 0)
 		return -EFAULT;
 
+	memset(&attr_common, 0, sizeof(attr_common));
+	if (cmd & BPF_COMMON_ATTRS) {
+		err = bpf_check_uarg_tail_zero(uattr_common, sizeof(attr_common), size_common);
+		if (err)
+			return err;
+
+		cmd &= ~BPF_COMMON_ATTRS;
+		size_common = min_t(u32, size_common, sizeof(attr_common));
+		if (copy_from_bpfptr(&attr_common, uattr_common, size_common) != 0)
+			return -EFAULT;
+	} else {
+		size_common = 0;
+	}
+
 	err = security_bpf(cmd, &attr, size, uattr.is_kernel);
 	if (err < 0)
 		return err;
@@ -6329,9 +6345,10 @@ static int __sys_bpf(enum bpf_cmd cmd, bpfptr_t uattr, unsigned int size)
 	return err;
 }
 
-SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
+SYSCALL_DEFINE5(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size,
+		struct bpf_common_attr __user *, uattr_common, unsigned int, size_common)
 {
-	return __sys_bpf(cmd, USER_BPFPTR(uattr), size);
+	return __sys_bpf(cmd, USER_BPFPTR(uattr), size, USER_BPFPTR(uattr_common), size_common);
 }
 
 static bool syscall_prog_is_valid_access(int off, int size,
@@ -6362,7 +6379,7 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, union bpf_attr *, attr, u32, attr_size)
 	default:
 		return -EINVAL;
 	}
-	return __sys_bpf(cmd, KERNEL_BPFPTR(attr), attr_size);
+	return __sys_bpf(cmd, KERNEL_BPFPTR(attr), attr_size, KERNEL_BPFPTR(NULL), 0);
 }
 
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3ca7d76e05f0..39022e07f6fd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -986,6 +986,7 @@ enum bpf_cmd {
 	BPF_PROG_STREAM_READ_BY_FD,
 	BPF_PROG_ASSOC_STRUCT_OPS,
 	__MAX_BPF_CMD,
+	BPF_COMMON_ATTRS = 1 << 16, /* Indicate carrying syscall common attrs. */
 };
 
 enum bpf_map_type {
@@ -1492,6 +1493,13 @@ struct bpf_stack_build_id {
 	};
 };
 
+struct bpf_common_attr {
+	__u64 log_buf;
+	__u32 log_size;
+	__u32 log_level;
+	__u32 log_true_size;
+};
+
 #define BPF_OBJ_NAME_LEN 16U
 
 enum {
-- 
2.52.0

