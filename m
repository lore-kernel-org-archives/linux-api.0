Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907478;
	b=1rZ083X1/K4La10EGr+Hv1pj8hLpq89g4DEVJNKE+ddRugTCV5lPKWrGUx+s1llQzhpY
	 qyCVb+Pxz/RA4wtm+ITvWxZKBqZbv6HkDT1lANfLHqTaMx4H0leasiNijm0qb/MjjN3oQ
	 Ud5V/sYNr5iee75SW+5PP55frlLPXxAbLvh27xX7FbKzDB9LI3dMjsuTILMhbo8lG61RU
	 PNe3iG8h3ies2HkFaxi9ytNI6qyKG6BlPgsNTP/lQ6NcfS/qOOuTcxZPZAwkIU8IqOW0f
	 9j3D4Y5DRH9OSx8YHjCfK+1ncFB/OUZbdYortrW1idwEJTho/ZMZHbk4hhtCuttQOhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3AyWWDFVbKJ/DkrPhpXcM2lwKymyXBABHoZtsa2/+w4=;
	b=aEuIBp3ETHHIQJ/2kIub0vbcVzjRjk+L5NvYk7VxrORWRZGrg09dOeKO99Pj8S+stCtg
	 iSNG67+RCBryNR8R4IhJwy/PD+GyE77Kv2kcN/fCJA6rgLRPDJsX0fHxGUlGJQH9O3Lcv
	 9gS06L4QbQxqb6NvxDkGDmMrjmWllvr/SiRhKmy3+zqI6S6Lu42cdhSBcGXSYvDKQjNQ2
	 1Ah5nVpybQ3AIcenZ5izO3OtFX8CH9llnUi/lPu86q+8U8jGhuyVQBKNkwf7rqHOmIV/T
	 AM0dHitgPsww289pNN5+GTGTEBAJ6MtdN4YIuQa/AIZF6mvh7jg7150ogBljnR8WBBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=cPl6L7vv;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1C607B974
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 19:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40B1C607B974
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=cPl6L7vv
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso3706110eec.0
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 11:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793907477; x=1794512277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3AyWWDFVbKJ/DkrPhpXcM2lwKymyXBABHoZtsa2/+w4=;
        b=cPl6L7vv4IdiTxomRsfBZyJX59O6aKePsnYBsOL+Il0TM2e7QZLMYUoor5RewSvnv7
         vLLbLRMSyMW/YKWH7JVRt+VA8awqGEfSTnb3NSI212h84khTjynO2iw5mzK2nVh11z5d
         EZ6tC6WQcQkAThRjYpVZDYHpM0IHCup/ssjDItaCiUmXD6fNSzFXuqyMXfcjXo9Y3C18
         AjZA2LqCbQEPJQKpzTHX/9JMW5k+59UhN0TUOXzSYbdIuRgq6YZLqhp3MfDyp1FFBB4n
         21C0wHgHpp9aOnGvecq21MbiLJ846BIuczpuDUnGu78BBlZgT6V+04NGwiDJ3uZbl2e6
         YlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907477; x=1794512277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3AyWWDFVbKJ/DkrPhpXcM2lwKymyXBABHoZtsa2/+w4=;
        b=bt9LPisdWpv4PZlkqp//ZDB+7C9ArT+CVHoqySB19s+6a6rvaiilwPy/eXnkxotD22
         WxBiKcRhOD1oT5Y6DFMGeGiX1TDx33A7w/StIbgutH/15MNN4yLH9A+gwvz9QccTnfWA
         ywhQlsbKv4xuiGPMwdXo4naMzQgLZhxM/HaljxjQcbvx2+1MtFqmMfnEIeTs8JpJJpyi
         pusPBNLGlHFZ0d7Sf7l0CJnNThlEz5CH2IIlETw5FTbcSY4aGvvf7NgSEyT15bnlNo9K
         UIBKGFvQNw21AoJj0EBGhMtukdmIbod2aERP4cwq2DDtcxgKp1+xp1auqvePMBGRt6D9
         rGuA==
X-Forwarded-Encrypted: i=1; AKwUvByn+vam0cSnI6D6orycfDhrKL4DGE7W1LpK1u0Lgr0xGo8/sg2+dYfrVBTOWpMCfS2hO7l/ID0/4lI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+07w0oxOtp7XD67uxHwW7SGxtfCmTL/96OR6sZ8GUXoEnQTj+E
	42SimXeR+VlKjV8650Bp29b3qxrV5I4Hv6P6hY/U817gAGaAvpe12RYGOUISkSQvlw==
X-Gm-Gg: AYBFou00E3sSophzICSIZA38OlCljv9iRfy+g7xqN1xqr7i9ZXri1PGpgyS/j4ppJFD
	jpBs9EkAfTs18LMTkSImfSqvkBZXN9iewDwXwOYHvSmX59ZNUjeG1GOgAzyW0vPZqwIdr2zpLBP
	XqCMjtW7O6akmORrVcjDL6Fj3cbvAqJRSXeAtL8T+aHBaN0ed0r87YQW8e1rSm149tAyuNZa1LO
	jUDvK8OhirVS9tV+s5Ub108nw6M4oOgn0gIuprcgfokqiG1ysbienQpvQwqmR+oG5BcpAIS1cJ5
	4NNjqRITDslfYtpzHwYHvuz/adntSypO5Wmch/xA1pPDIJll1OYZL1a2huEJVKbXea0EKduGSod
	32K2YBqKOguQ0Xe7M6F5ojs8t0Lzt0ULH86Bgm3/60LYvdKtieMGKTYg/0T7T/SjpZFzpH52p3X
	AW06xtP10TMLBbjliCJuDkj6soX/KIgAbP0zVHAg11i0XSwk0/qt8LXrodWCuhMF16KhbgBEy4m
	LIipYCSHFCLaGCPACcFrQThBkEAgm1t+kC9zXe/L3937BglisaZMMEhLX4t/UKt0BbwLZPMm0By
	VQzhvpA97iBDv/Jjbj36P3T2cBvqgYY4/YrJZL00RdgP1sl14TSabbdCcDtBCcxW/o2a6YvB3vg
	YH84k92x4yiDYud4oduGIzVA=
X-Received: by 2002:a05:7301:6285:b0:35c:85fa:5a61 with SMTP id 5a478bee46e88-36f76f0e752mr142560eec.38.1793907476899;
        Thu, 05 Nov 2026 11:37:56 -0800 (PST)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72ec8a02sm326134eec.11.2026.11.05.11.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:37:56 -0800 (PST)
From: Danny Hu <dannyhu@arista.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Victor Kamensky <kamensky@cisco.com>,
	Taras Kondratiuk <takondra@cisco.com>,
	Zheng Zengkai <zhengzengkai@huawei.com>,
	zhangguangzhi <zhangguangzhi3@huawei.com>,
	Danny Hu <dannyhu@arista.com>,
	Jason Yan <yanaijie@huawei.com>,
	silviu.vlasceanu@huawei.com,
	hpa@zytor.com,
	arnd@arndb.de,
	james.w.mcmechan@gmail.com,
	niveditas98@gmail.com,
	pierre@arista.com,
	julien@arista.com,
	kbharathi@arista.com,
	alexandr.lobakin@intel.com,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bug-cpio@gnu.org
Subject: [PATCH v6 2/4] initramfs: add file metadata
Date: Thu,  5 Nov 2026 11:37:41 -0800
Message-ID: <20261105193743.2654656-3-dannyhu@arista.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105193743.2654656-1-dannyhu@arista.com>
References: <20261105193743.2654656-1-dannyhu@arista.com>
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

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

This patch adds metadata to a file from a supplied buffer. The buffer might
contains multiple metadata records. The format of each record is:

<metadata len (ASCII, 8 chars)><version><type><metadata>

For now, only the TYPE_XATTR metadata type is supported. The specific
format of this metadata type is:

<xattr #N name>\0<xattr #N value>

[kamensky: fixed restoring of xattrs for symbolic links by using
           sys_lsetxattr() instead of sys_setxattr()]

[sassu: removed state management, kept only do_setxattrs(), added support
        for generic file metadata, replaced sys_lsetxattr() with
        vfs_setxattr(), added check for entry_size, added check for
        hdr->c_size, replaced strlen() with strnlen(); moved do_setxattrs()
        before do_name()]

[zhangguangzhi: fix checkpatch warning EMBEDDED_FILENAME in
                include/linux/initramfs.h]

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Victor Kamensky <kamensky@cisco.com>
Signed-off-by: Taras Kondratiuk <takondra@cisco.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Tianxing Zhang <zhangtianxing3@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Signed-off-by: zhoushuiqing <zhoushuiqing2@huawei.com>
Signed-off-by: zhangguangzhi <zhangguangzhi3@huawei.com>
Signed-off-by: Danny Hu <dannyhu@arista.com>
---
Changes in v6:
 - Document lack of support for POSIX ACL restoration. The main use case is to
   restore security.ima xattr for IMA use. POSIX ACL support is out of scope
   for this patchset
 - Check xattr name and value lengths to ensure they are valid and do not
   exceed the limit
 - Compare metadata header and record sizes against the remaining buffer
   length to avoid pointer arithmetic overflow in bounds checks
 - Use the kernel u32 type instead of uint32_t

Changes in v5:
 - For debug print in do_setxattrs(), use print_hex_dump_debug() rather
   than printing the xattr value as a string
 - Use u32 metadata record lengths and reject records smaller than their
   header

 include/linux/initramfs.h |  19 +++++++
 init/initramfs.c          | 103 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/initramfs.h

diff --git a/include/linux/initramfs.h b/include/linux/initramfs.h
new file mode 100644
index 000000000000..9b3839dc88a1
--- /dev/null
+++ b/include/linux/initramfs.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Include file for file metadata in the initial ram disk.
+ */
+#ifndef _LINUX_INITRAMFS_H
+#define _LINUX_INITRAMFS_H
+
+#define METADATA_FILENAME "METADATA!!!"
+
+enum metadata_types { TYPE_NONE, TYPE_XATTR, TYPE__LAST };
+
+struct metadata_hdr {
+	char c_size[8];     /* total size including c_size field */
+	char c_version;     /* header version */
+	char c_type;        /* metadata type */
+	char c_metadata[];  /* metadata */
+} __packed;
+
+#endif /*LINUX_INITRAMFS_H*/
diff --git a/init/initramfs.c b/init/initramfs.c
index ebddde9c8f0d..d206624d1160 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -10,7 +10,9 @@
 #include <linux/hex.h>
 #include <linux/init.h>
 #include <linux/init_syscalls.h>
+#include <linux/initramfs.h>
 #include <linux/kstrtox.h>
+#include <linux/limits.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/namei.h>
@@ -22,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/umh.h>
 #include <linux/utime.h>
+#include <linux/xattr.h>
 
 #include <asm/byteorder.h>
 
@@ -189,7 +192,7 @@ static __initdata time64_t mtime;
 
 static __initdata unsigned long ino, major, minor, nlink;
 static __initdata umode_t mode;
-static __initdata unsigned long body_len, name_len;
+static __initdata unsigned long body_len, name_len, metadata_len;
 static __initdata uid_t uid;
 static __initdata gid_t gid;
 static __initdata unsigned rdev;
@@ -264,6 +267,7 @@ static void __init read_into(char *buf, unsigned size, enum state next)
 }
 
 static __initdata char *header_buf, *symlink_buf, *name_buf;
+static __initdata char *metadata_buf;
 
 static int __init do_start(void)
 {
@@ -365,6 +369,103 @@ static int __init maybe_link(void)
 	return 0;
 }
 
+static int __init do_setxattrs(char *pathname, char *buf, size_t size)
+{
+	struct path path;
+	char *xattr_name, *xattr_value;
+	u32 xattr_name_size, xattr_value_size;
+	int ret;
+
+	xattr_name = buf;
+	xattr_name_size = strnlen(xattr_name, size);
+	if (xattr_name_size == size) {
+		error("malformed xattrs");
+		return -EINVAL;
+	}
+
+	if (!xattr_name_size || xattr_name_size > XATTR_NAME_MAX) {
+		error("invalid xattr name length");
+		return -EINVAL;
+	}
+
+	xattr_value = xattr_name + xattr_name_size + 1;
+	xattr_value_size = buf + size - xattr_value;
+	if (xattr_value_size > XATTR_SIZE_MAX) {
+		error("xattr value exceeds size limit");
+		return -EINVAL;
+	}
+
+	ret = kern_path(pathname, 0, &path);
+	if (!ret) {
+		/*
+		 * POSIX ACL restoration is currently unsupported.
+		 * vfs_setxattr() rejects POSIX ACL xattrs with -EOPNOTSUPP.
+		 */
+		ret = vfs_setxattr(&nop_mnt_idmap, path.dentry, xattr_name, xattr_value,
+				   xattr_value_size, 0);
+
+		path_put(&path);
+	}
+
+	pr_debug("%s: %s size: %u (ret: %d)\n", pathname, xattr_name,
+		 xattr_value_size, ret);
+	print_hex_dump_debug("xattr value: ", DUMP_PREFIX_OFFSET,
+			     16, 1, xattr_value, xattr_value_size, false);
+
+	return ret;
+}
+
+static int __init __maybe_unused do_parse_metadata(char *pathname)
+{
+	char *buf = metadata_buf;
+	char *bufend = metadata_buf + metadata_len;
+	struct metadata_hdr *hdr;
+	char str[sizeof(hdr->c_size) + 1];
+	u32 entry_size;
+
+	if (!metadata_len)
+		return 0;
+
+	str[sizeof(hdr->c_size)] = 0;
+
+	while (buf < bufend) {
+		int ret;
+
+		if (bufend - buf < sizeof(*hdr)) {
+			error("malformed metadata");
+			break;
+		}
+
+		hdr = (struct metadata_hdr *)buf;
+		if (hdr->c_version != 1) {
+			pr_debug("Unsupported header version\n");
+			break;
+		}
+
+		memcpy(str, hdr->c_size, sizeof(hdr->c_size));
+		ret = kstrtou32(str, 16, &entry_size);
+		if (ret || entry_size < sizeof(*hdr) ||
+		    entry_size > bufend - buf) {
+			error("malformed xattrs");
+			break;
+		}
+
+		switch (hdr->c_type) {
+		case TYPE_XATTR:
+			do_setxattrs(pathname, buf + sizeof(*hdr),
+				     entry_size - sizeof(*hdr));
+			break;
+		default:
+			pr_debug("Unsupported metadata type\n");
+			break;
+		}
+
+		buf += entry_size;
+	}
+
+	return 0;
+}
+
 static __initdata struct file *wfile;
 static __initdata loff_t wfile_pos;
 
-- 
2.51.0

