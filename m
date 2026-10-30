Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394618;
	b=tlyyPOHQoy0n7GTF49ppN8N9NC12L+oDSxizguWyOQykSbAX7KNLnb8GBgrlCzaSYBf8
	 rMJXBlbMmScqufolPOhJF8XnHUjNLDS+LqWPcYYFPyWtwBO/7CoGDHPGwVLRe2AvnBXad
	 MWTpbRnnjaHMTneqqrlVyKp1o090JmJOQGJcTtXksklSekUeE2Azf2mihQ/EzopRPU2/O
	 iNli+sxP/1xG9yYzRseqksTCXKuR+QksGq7jQ6COUoLkSgHFKZD9kquoOh1S4kAxP2Lqf
	 Wd0efhkaDgx9PchMEZWkEA/PU5zlHslJxNLcyGtyEor7QIkQrhbpFA+t2SpLDZDhyCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394618;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0lofktk4aVZckRcCcRV6QntITM4Mli1YlgsaCWlDa8=;
	b=0wP+4WMT6BW//KZEGT8P2H6yLZeqbHdDjFO37SDWVc58cdSlalq4AX9HNiEuHUNV6jj9
	 6dPpMoOkjcjpJOMyZjB0eenq9qeKulllZe1tsA5wgLWnpQePZacNhLtoodynlKKS38uVC
	 MIdenQ3rZA89/jXG/oWNpbScdNZQFiCg/bA7P7EKSaLSKA4DdRz6GcisiU4Bfh6kxaNb2
	 ozrlklsklvFyBfYwROQfEDps/81kosOWtfWj9nbuv8+t/DDbMktSJJDoImqA3jU2vhTZF
	 NnNHMFgoNNbJRcYeJ6wuFtLK++KeFkm8qjiecOIP+1xJc7QX4C2rR6JmIRA0guQSwiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=kRsN7yMw;
	arc=none smtp.remote-ip=74.125.82.46
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C69B60A2607
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 21:10:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C69B60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=kRsN7yMw
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1adbf62dd31so964818c88.0
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 14:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793394616; x=1793999416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I0lofktk4aVZckRcCcRV6QntITM4Mli1YlgsaCWlDa8=;
        b=kRsN7yMwZgo28qTV/TO991Yy79ioZOc1J/0OwfKZdoy2ilaKYyxsHvjf34ppy3wwRF
         o+cs63h1F0blKJiAP5DtQWfytFi5lzxJYAA8MPOTl0MXJ93rtgjVYx8VZ0W6opwrI0RT
         9VMxk3rMzImpbwZssM0gBkO5ukGpqtec+0RRoWnp2Ik6GpP8ZIaOL//y9zNyuwI73jQC
         RHkSfwPQ/D2rCBBTlopvsRjY5An/2NTZWl9BNV0/6oGYh0aTO6EC8WNXUT/VezLZLEzu
         CTPHvT7PKf4cetvsPka7QQqZLpDiLog/p1Lwt1roGDnZXvIInTq1y/Ekzo0c83+it/9V
         v53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394616; x=1793999416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I0lofktk4aVZckRcCcRV6QntITM4Mli1YlgsaCWlDa8=;
        b=x12GRySZ843S49wLj243D+OgoHGscFZt+PAQJwhNix3gf4R6TfCY1jvpSNPH4Jf2Jf
         O5SimB+mOxPFwwH/FpT9Kzg3FR4e4d9BEzAvw6FdkZZJMotE9z8dS8B1nanhlwiS3YKZ
         ekEW0YAsh2rJINth6Hhej2HkO+Ft93Tc+B7rMgt2C1LIDqbzKferOXPj4iJfew2Xe09D
         SOijXvBI0v9zekEabCmzUJwUSiV0AoXey7E4BNhKRTn70wcTLHWm4mAV+EKd1/NjUEBS
         zNzSiRlGb5kZdwHB7LHDt6UaVslzPrPmdp380EqQ6dTm80uWND9og2zFSs5fg+iPsCIi
         oWtA==
X-Forwarded-Encrypted: i=1; AKwUvByJ8whK8GdSxJphU30DWCIoMX0uEbhGwtgbwhbdfJDMDA8D+ueDlfekqPrfPa5VLHXrTjWYsFEI1OU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJpnAFyRegsB63fTXAHE6PK3BwUkLE52BFQCotwGq/lIHNRWYSn
	JHe17sYJR+QaX2LfxYadUyju0r/PjsBjMEvPylCm9vTccxW7onDK6Ke11qm8DsDr1g==
X-Gm-Gg: AYBFou0casMA7jmqDlfVMDe42OVleUDKTeo1hwlnaexinHs424cGcXzvrFZ1Zj6RCKQ
	PUoeCiT0HQfd/LiR6+vahyvaAx0sKq5ZwI2D7AvHC0K96BYat1wViLDgkYKxC/Ry/eW0EPtZkOm
	LF3F1gPGxqcJLDEIoPZGMjZaDSKB5AfwNKI544SqMmxUBtJsQJqfBl1mWa0wLs9XHTdOV4i2vdy
	MWvTeOVzfGMIJRBmjaA4FMJ55nQzKDIjvRBd5G1LA3o7iox5BTGuYQbgEQkKW5XZkIfm0EKCpLt
	Zzg3IVUcD2z/75fe4B0Idj63p+pNlZJ7bPHU26WZaP9nicCUr9D+V6ZgdJlm/5em73+Uiidoi2E
	zDhS24m5tvUOLxrh1UyrMveDg+76amgFp6Uix8GNST82GH5h/gk84se6n/jkU6EAKFZtuqL1DIm
	ybASdX9HHBinpFHC2/WYgjX9paYYKx1OAlJEe5X08N1JQYiMYSQPQLKdcIt+1g/nL47tTdQjDHA
	jvmbgyLVtw1SZbsqqeNYkTSLflD12Bwmf8wiY57q8Knl7zA9DBhw/JUHP49QYGGzXR3HYg7Y99i
	8nhbO8MM4S5ZmZK0THS6kZ8cN3K0alXHbqWCqFOeMTtDobG3LxpICshMe7OpRmexYiSmKfYnTGa
	gnUdPUHU6Q8uUW2rF/NQS3Ac=
X-Received: by 2002:a05:7022:ea56:10b0:176:a225:e364 with SMTP id a92af1059eb24-1ac5de547afmr4542282c88.35.1793394615874;
        Fri, 30 Oct 2026 14:10:15 -0700 (PDT)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.18])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm9471777c88.21.2026.10.30.14.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:10:15 -0700 (PDT)
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
	Tianxing Zhang <zhangtianxing3@huawei.com>,
	Zheng Zengkai <zhengzengkai@huawei.com>,
	zhoushuiqing <zhoushuiqing2@huawei.com>,
	zhangguangzhi <zhangguangzhi3@huawei.com>,
	Danny Hu <dannyhu@arista.com>,
	Jason Yan <yanaijie@huawei.com>,
	silviu.vlasceanu@huawei.com,
	hpa@zytor.com,
	arnd@arndb.de,
	rob@landley.net,
	james.w.mcmechan@gmail.com,
	niveditas98@gmail.com,
	pierre@arista.com,
	julien@arista.com,
	kbharathi@arista.com,
	erosca@de.adit-jv.com,
	alexandr.lobakin@intel.com,
	jim_baxter@mentor.com,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	initramfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bug-cpio@gnu.org
Subject: [PATCH v5 2/4] initramfs: add file metadata
Date: Fri, 30 Oct 2026 14:09:41 -0700
Message-ID: <20261030210944.2143778-3-dannyhu@arista.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261030210944.2143778-1-dannyhu@arista.com>
References: <20261030210944.2143778-1-dannyhu@arista.com>
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
Changes in v5:
 - For debug print in do_setxattrs(), use print_hex_dump_debug() rather
   than printing the xattr value as a string
 - Use u32 metadata record lengths and reject records smaller than their
   header

 include/linux/initramfs.h | 19 +++++++++
 init/initramfs.c          | 89 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 1 deletion(-)
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
index ebddde9c8f0d..36254dba7822 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -10,6 +10,7 @@
 #include <linux/hex.h>
 #include <linux/init.h>
 #include <linux/init_syscalls.h>
+#include <linux/initramfs.h>
 #include <linux/kstrtox.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
@@ -22,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/umh.h>
 #include <linux/utime.h>
+#include <linux/xattr.h>
 
 #include <asm/byteorder.h>
 
@@ -189,7 +191,7 @@ static __initdata time64_t mtime;
 
 static __initdata unsigned long ino, major, minor, nlink;
 static __initdata umode_t mode;
-static __initdata unsigned long body_len, name_len;
+static __initdata unsigned long body_len, name_len, metadata_len;
 static __initdata uid_t uid;
 static __initdata gid_t gid;
 static __initdata unsigned rdev;
@@ -264,6 +266,7 @@ static void __init read_into(char *buf, unsigned size, enum state next)
 }
 
 static __initdata char *header_buf, *symlink_buf, *name_buf;
+static __initdata char *metadata_buf;
 
 static int __init do_start(void)
 {
@@ -365,6 +368,90 @@ static int __init maybe_link(void)
 	return 0;
 }
 
+static int __init do_setxattrs(char *pathname, char *buf, size_t size)
+{
+	struct path path;
+	char *xattr_name, *xattr_value;
+	uint32_t xattr_name_size, xattr_value_size;
+	int ret;
+
+	xattr_name = buf;
+	xattr_name_size = strnlen(xattr_name, size);
+	if (xattr_name_size == size) {
+		error("malformed xattrs");
+		return -EINVAL;
+	}
+
+	xattr_value = xattr_name + xattr_name_size + 1;
+	xattr_value_size = buf + size - xattr_value;
+
+	ret = kern_path(pathname, 0, &path);
+	if (!ret) {
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
+	uint32_t entry_size;
+
+	if (!metadata_len)
+		return 0;
+
+	str[sizeof(hdr->c_size)] = 0;
+
+	while (buf < bufend) {
+		int ret;
+
+		if (buf + sizeof(*hdr) > bufend) {
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
+		if (ret || buf + entry_size > bufend ||
+		    entry_size < sizeof(*hdr)) {
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

