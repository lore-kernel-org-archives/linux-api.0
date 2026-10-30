Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394622;
	b=G05yA32uuDWeicHqYXmZRUFf8aWGHfWUrmgH2gEnkOVmhaIvn8tF/nwb8tv+O2hVhsDt
	 kF6CFC86hQU4e5kp4dfe+bgoMW8OkLr/3nxE/13Rig+mSXRmP3Sh0g9xOraIXU36nhWfD
	 IhnG8fndITd1HnSViflZiA3gBtf/JbB7ruxQP2TfzFASLifIcu0IhLrJRDG/X+HWoSaEE
	 o4nV1G1/j5Kq09z91onLNW8souj9lMTiE/R39LoINyCBT2XwgeIom27T4nkGoUiJz6hbA
	 F08buJshDhYPlp1B6Ub7B09sjb4Nm2v97nof5ORTQ/cBPTQS/Jw6+d71+d+qNvV6gAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394622;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b6rgIm+5PbCV1VV/h+qGVE2kN3elc6rHKJjG61+uC6E=;
	b=vLp6D9Z3QR1MJyOFlQtCdiQuq+tZyPdoj7kE164/mUdCOD/lbghJpMXUn4iwjjLVzQKM
	 dGIJIlA1waBtKz7/8hlck0hA4l36prz6gppyxX2trdt7xL19vjdQi0xVhLHWhn+pnqHGy
	 xmGc4WHPj3ib2EmMwfhm1Zh4I9cx9ajz9D4MYpMAlafPKbX+2cXtsvuT63PbHH9dnjksQ
	 +v8e5g1mcRcUvpV7sBNaMb7UpQEZB1jUSqaRAKSwv4uLHHT9JZptaIkYj8o7ik8Appxep
	 b2tb7cKi+Mp2wyRedmt+uItbVYk5oWgWaXBQSXcgCw5l6XEbdAbb/zcdmawmI7DbZPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=bfb4H3Ja;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0EA60A263E
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 21:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D0EA60A263E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=bfb4H3Ja
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-15943c9c005so239368c88.1
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 14:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793394620; x=1793999420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b6rgIm+5PbCV1VV/h+qGVE2kN3elc6rHKJjG61+uC6E=;
        b=bfb4H3Ja92X3d9BVzx0zy/DiN96n2Dee4Kykw1jdIKADVNsOMyCtGPlMdJJ58ZTfOX
         bzu0/KRWsSCh1CPt95Vwiei/OwzvRPo7ka5TFEi8Zv07E4pdUdyoK/mMq4mUPgk1XPHp
         qfHPqKtxBko5a8v3thC5K1lsFyydIdqP0Dv/NNec8wL7Zme/uN84ZjbTMKfpRwWquyX7
         fq9oZy49jz8rzvomyGKezWhZkwkf752VkUC6CfZX0I9E4kRP3L78t1xJvGOc0QG0Dp65
         FvpBh/5e8t7FyGc6xLnuCEhCmmv2KuFY7TWrJFQFgBDmn8C9Q+khLD9Xvz/ReEq/1R2U
         KGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394620; x=1793999420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b6rgIm+5PbCV1VV/h+qGVE2kN3elc6rHKJjG61+uC6E=;
        b=Mbm57NS4Nwfe1m0Npuug9s5u03O85g9nPU0NNPAGAu/C/I2qfVvwcHQ5jAtoOW+WFX
         Ya7xjAtX79LXvRV77s+NrZOqwTFInyp+BaU96BLtE3fAGB3WWyG451qbwCJi/7W9MxT9
         bNP8evGlpVVE/32V9Mzq6EDNuJx/XgaHKCpSf6XK2yoZyudRryel3VX5HAq5dnMMm8Ei
         BVRRLNiHNwdCqvO1SBBj2x9Zf/Gft9fwGPWkhWQbEEbOizzQKm10SKxJ/zwvwY6gYjH1
         YXOj3Jv6So34QHpUFOKgOA6kH2bgIarUcl6UvZA+frQv+ZUn/BenBf/cPMiks33XfNLc
         ewaA==
X-Forwarded-Encrypted: i=1; AKwUvBzS+qwkBAWOnPLEqqk/O3UHaLEUKMJ/7kPoYnJIHYVaixE3uaC651minRi01L89IwXqyz1TZSIOKJo=@vger.kernel.org
X-Gm-Message-State: AFq9FYJuyRRkCRlLDTbeZi/0cjxdOhR4NrtZPyCaofh1qUiTouCMckQm
	m6hLkXGwCtsofXDeTmdl+oQwn3muUkD98QBaT+JnyPDJlQ6EYK6WV1yxIBxFWqiizA==
X-Gm-Gg: AYBFou2o5ykWisTTZIlWXKjVpVOnR7fizjAQ5r/LIIqi5v/ZJeyU1eR7HrJLlIcO8da
	06Zjag5rXNttaxw460BsBK1KX3u1e2L1hzTAX4T/oi9lQ9hWFI/aBryH5L+zYRXsZIpoxAgeBlK
	fRNV6/t4eCV982en06L6jybPuZSzIcCrrdpwVbLbRebk7iwu2FQ1ltnwrlRxqSP4In9ubF5Gp94
	Bhy+k9NxBk0uBfjgOoERzs9711rt+8Seho2LmnjwJ/AfBEO+Lf4ZzFDQg7gP2Uq0m/3U4xvM3nW
	GhkbTe2+6WU0bdH55JR+36s6ZiXuo5CVyqflBXv8BYFZKkLpZ85DRPC6/pIHqjFZUWlTBM5Ygdx
	QfmzQfuc9JcimNMBTagKyo5qqjWzw65g17TeTdNxdvRQ3FbLVE2bP0Po1RDFIjfKC6YJhdHFFBH
	fSVhjiIJ8eOaBbY57ESzwST/LhDe2fr0E82s3WrJ/EI/GjMeCQJfyWHfkOo1IKpUYMYrVzxnucg
	jDm3QCHsXK6j1ePHW+KgFOXfdg2IgubgrejtdmerG/hdCghPWPAm4om1nhMV6NmZnwdQA+YXU8l
	1kAi0X+TJ3QUaENnoiyqpuIWn3rQP9PpOhtwrvLJA6rsnUQGMpC83mcQfMUUTTzu/7960EaK3Vk
	8jasm5HRk1i8S8PN6KX4k/vo=
X-Received: by 2002:a05:7022:b043:20b0:19c:dd9b:d09e with SMTP id a92af1059eb24-1ac5cdf9b17mr5090344c88.23.1793394619875;
        Fri, 30 Oct 2026 14:10:19 -0700 (PDT)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.18])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm9471777c88.21.2026.10.30.14.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:10:19 -0700 (PDT)
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
Subject: [PATCH v5 4/4] gen_init_cpio: add support for file metadata
Date: Fri, 30 Oct 2026 14:09:43 -0700
Message-ID: <20261030210944.2143778-5-dannyhu@arista.com>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

This patch adds support for file metadata (only TYPE_XATTR metadata type).
gen_init_cpio has been modified to read xattrs from files that will be
added to the image and to include file metadata as separate files with the
special name 'METADATA!!!'.

This behavior can be selected by setting the desired file metadata type as
value for CONFIG_INITRAMFS_FILE_METADATA.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Tianxing Zhang <zhangtianxing3@huawei.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Signed-off-by: zhoushuiqing <zhoushuiqing2@huawei.com>
Signed-off-by: zhangguangzhi <zhangguangzhi3@huawei.com>
Signed-off-by: Danny Hu <dannyhu@arista.com>
---
Changes in v5:
 - context adapt usr/Makefile, usr/gen_initramfs.sh (zhangguangzhi)
 - del duplicate code in usr/Makefile (zhangguangzhi)
 - fix checkpatch warning STATIC_CONST_CHAR_ARRAY in usr/gen_init_cpio.c:38
   (zhangguangzhi)
 - make CONFIG_INITRAMFS_FILE_METADATA a choice rather than having to
   specify it manually
 - document -e option and supported values in gen_init_cpio usage()
 - Update gen_initramfs.sh to pass source paths to gen_init_cpio.c for
   nonregular entries (slink, dir, nod). Modify gen_init_cpio to
   properly collect xattrs from the source object. Without this change,
   xattrs will not get included for slink, dir and nod.
 - xattr collection now uses llistxattr() and lgetxattr() so symlink
   xattrs come from the link itself rather than the target.
 - use the size_t hexadecimal format specifier in write_xattrs()
 - initialize xattr_value as NULL to prevent free of uninitialized ptr
 - free xattr_list after checking whether xattr iteration completed
 - clean up temporary metadata file before gen_init_cpio exits

 usr/Kconfig          |  19 ++++
 usr/Makefile         |   3 +-
 usr/gen_init_cpio.c  | 216 +++++++++++++++++++++++++++++++++++++------
 usr/gen_initramfs.sh |  15 ++-
 4 files changed, 219 insertions(+), 34 deletions(-)

diff --git a/usr/Kconfig b/usr/Kconfig
index 9279a2893ab0..135a9248bba2 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -227,3 +227,22 @@ config INITRAMFS_COMPRESSION_NONE
 	  filesystem image will be present in memory simultaneously
 
 endchoice
+
+choice
+	prompt "File metadata type"
+	default INITRAMFS_FILE_METADATA_NONE
+	help
+	  Specify the metadata types to be included in the image.
+
+	  If you are not sure, leave unchanged.
+
+	config INITRAMFS_FILE_METADATA_NONE
+		bool "no xattrs (default)"
+	config INITRAMFS_FILE_METADATA_XATTR
+		bool "xattr"
+endchoice
+
+config INITRAMFS_FILE_METADATA
+	string
+	default "" if INITRAMFS_FILE_METADATA_NONE
+	default "xattr" if INITRAMFS_FILE_METADATA_XATTR
diff --git a/usr/Makefile b/usr/Makefile
index e8f42478a0b7..dc4a1f4b3da2 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -65,7 +65,8 @@ quiet_cmd_initfs = GEN     $@
 	$(addprefix -u , $(CONFIG_INITRAMFS_ROOT_UID)) \
 	$(addprefix -g , $(CONFIG_INITRAMFS_ROOT_GID)) \
 	$(if $(KBUILD_BUILD_TIMESTAMP), -d "$(KBUILD_BUILD_TIMESTAMP)") \
-	$(ramfs-input)
+	$(if $(filter-out "",$(CONFIG_INITRAMFS_FILE_METADATA)), \
+	  -e $(CONFIG_INITRAMFS_FILE_METADATA)) $(ramfs-input)
 
 # We rebuild initramfs_data.cpio if:
 # 1) Any included file is newer than initramfs_data.cpio
diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index b7296edc6626..f07be54c9219 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -6,6 +6,7 @@
 #include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/xattr.h>
 #include <string.h>
 #include <unistd.h>
 #include <time.h>
@@ -13,6 +14,7 @@
 #include <errno.h>
 #include <ctype.h>
 #include <limits.h>
+#include "../include/linux/initramfs.h"
 
 /*
  * Original work by Jeff Garzik
@@ -37,12 +39,126 @@ static bool do_file_mtime;
 static bool do_csum = false;
 static int outfd = STDOUT_FILENO;
 static unsigned int dalign;
+static char metadata_path[] = "/tmp/cpio-metadata-XXXXXX";
+static int metadata_fd = -1;
 
 struct file_handler {
 	const char *type;
 	int (*handler)(const char *line);
 };
 
+static enum metadata_types parse_metadata_type(char *arg)
+{
+	static char *metadata_type_str[TYPE__LAST] = {
+		[TYPE_NONE] = "none",
+		[TYPE_XATTR] = "xattr",
+	};
+	int i;
+
+	for (i = 0; i < TYPE__LAST; i++)
+		if (!strcmp(metadata_type_str[i], arg))
+			return i;
+
+	return TYPE_NONE;
+}
+
+static int cpio_mkfile(const char *name, const char *location,
+		       unsigned int mode, uid_t uid, gid_t gid,
+		       unsigned int nlinks);
+
+static char *cpio_replace_env(char *new_location);
+
+static int write_xattrs(const char *path)
+{
+	struct metadata_hdr hdr = { .c_version = 1, .c_type = TYPE_XATTR };
+	char str[sizeof(hdr.c_size) + 1];
+	char *xattr_list, *list_ptr;
+	char *xattr_value = NULL;
+	ssize_t list_len, name_len, value_len, len;
+	int ret = -EINVAL;
+
+	if (metadata_fd < 0)
+		return 0;
+
+	if (path == metadata_path)
+		return 0;
+
+	list_len = llistxattr(path, NULL, 0);
+	if (list_len <= 0)
+		return 0;
+
+	list_ptr = xattr_list = malloc(list_len);
+	if (!list_ptr) {
+		fprintf(stderr, "out of memory\n");
+		return ret;
+	}
+
+	len = llistxattr(path, xattr_list, list_len);
+	if (len != list_len)
+		goto out;
+
+	if (ftruncate(metadata_fd, 0))
+		goto out;
+
+	lseek(metadata_fd, 0, SEEK_SET);
+
+	while (list_ptr < xattr_list + list_len) {
+		name_len = strlen(list_ptr);
+
+		value_len = lgetxattr(path, list_ptr, NULL, 0);
+		if (value_len < 0) {
+			fprintf(stderr, "cannot get xattrs\n");
+			break;
+		}
+
+		if (value_len) {
+			xattr_value = malloc(value_len);
+			if (!xattr_value) {
+				fprintf(stderr, "out of memory\n");
+				break;
+			}
+		} else {
+			xattr_value = NULL;
+		}
+
+		len = lgetxattr(path, list_ptr, xattr_value, value_len);
+		if (len != value_len)
+			break;
+
+		snprintf(str, sizeof(str), "%.8zx",
+			 sizeof(hdr) + name_len + 1 + value_len);
+
+		memcpy(hdr.c_size, str, sizeof(hdr.c_size));
+
+		if (write(metadata_fd, &hdr, sizeof(hdr)) != sizeof(hdr))
+			break;
+
+		if (write(metadata_fd, list_ptr, name_len + 1) != name_len + 1)
+			break;
+
+		if (write(metadata_fd, xattr_value, value_len) != value_len)
+			break;
+
+		if (fsync(metadata_fd))
+			break;
+
+		list_ptr += name_len + 1;
+		free(xattr_value);
+		xattr_value = NULL;
+	}
+
+	free(xattr_value);
+out:
+	if (list_ptr != xattr_list + list_len) {
+		free(xattr_list);
+		return ret;
+	}
+
+	free(xattr_list);
+
+	return cpio_mkfile(METADATA_FILENAME, metadata_path, S_IFREG, 0, 0, 1);
+}
+
 static int push_buf(const char *name, size_t name_len)
 {
 	ssize_t len;
@@ -119,7 +235,8 @@ static int cpio_trailer(void)
 }
 
 static int cpio_mkslink(const char *name, const char *target,
-			 unsigned int mode, uid_t uid, gid_t gid)
+			const char *location, unsigned int mode,
+			uid_t uid, gid_t gid)
 {
 	int len;
 	unsigned int namesize, targetsize = strlen(target) + 1;
@@ -150,7 +267,8 @@ static int cpio_mkslink(const char *name, const char *target,
 	    push_buf(name, namesize) < 0 ||
 	    push_pad(padlen(offset, 4)) < 0 ||
 	    push_buf(target, targetsize) < 0 ||
-	    push_pad(padlen(offset, 4)) < 0)
+	    push_pad(padlen(offset, 4)) < 0 ||
+	    write_xattrs(location) < 0)
 		return -1;
 
 	return 0;
@@ -161,22 +279,29 @@ static int cpio_mkslink_line(const char *line)
 {
 	char name[PATH_MAX + 1];
 	char target[PATH_MAX + 1];
+	char location[PATH_MAX + 1];
 	unsigned int mode;
 	int uid;
 	int gid;
+	int nfields;
 	int rc = -1;
 
-	if (5 != sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX) "s %o %d %d", name, target, &mode, &uid, &gid)) {
-		fprintf(stderr, "Unrecognized dir format '%s'", line);
+	nfields = sscanf(line, "%" str(PATH_MAX) "s %" str(PATH_MAX)
+			 "s %o %d %d %" str(PATH_MAX) "s",
+			 name, target, &mode, &uid, &gid, location);
+	if (nfields < 5) {
+		fprintf(stderr, "Unrecognized slink format '%s'", line);
 		goto fail;
 	}
-	rc = cpio_mkslink(name, target, mode, uid, gid);
+	rc = cpio_mkslink(name, target,
+			  nfields == 6 ? cpio_replace_env(location) : NULL,
+			  mode, uid, gid);
  fail:
 	return rc;
 }
 
-static int cpio_mkgeneric(const char *name, unsigned int mode,
-		       uid_t uid, gid_t gid)
+static int cpio_mkgeneric(const char *name, const char *location,
+			  unsigned int mode, uid_t uid, gid_t gid)
 {
 	int len;
 	unsigned int namesize;
@@ -204,7 +329,8 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 	offset += len;
 
 	if (len != CPIO_HDR_LEN ||
-	    push_rest(name, namesize) < 0)
+	    push_rest(name, namesize) < 0 ||
+	    write_xattrs(location) < 0)
 		return -1;
 
 	return 0;
@@ -239,18 +365,24 @@ static const struct generic_type generic_type_table[] = {
 static int cpio_mkgeneric_line(const char *line, enum generic_types gt)
 {
 	char name[PATH_MAX + 1];
+	char location[PATH_MAX + 1];
 	unsigned int mode;
 	int uid;
 	int gid;
+	int nfields;
 	int rc = -1;
 
-	if (4 != sscanf(line, "%" str(PATH_MAX) "s %o %d %d", name, &mode, &uid, &gid)) {
+	nfields = sscanf(line, "%" str(PATH_MAX) "s %o %d %d %"
+			 str(PATH_MAX) "s", name, &mode, &uid, &gid, location);
+	if (nfields < 4) {
 		fprintf(stderr, "Unrecognized %s format '%s'",
-			line, generic_type_table[gt].type);
+			generic_type_table[gt].type, line);
 		goto fail;
 	}
 	mode |= generic_type_table[gt].mode;
-	rc = cpio_mkgeneric(name, mode, uid, gid);
+	rc = cpio_mkgeneric(name,
+			   nfields == 5 ? cpio_replace_env(location) : NULL,
+			   mode, uid, gid);
  fail:
 	return rc;
 }
@@ -270,9 +402,9 @@ static int cpio_mksock_line(const char *line)
 	return cpio_mkgeneric_line(line, GT_SOCK);
 }
 
-static int cpio_mknod(const char *name, unsigned int mode,
-		       uid_t uid, gid_t gid, char dev_type,
-		       unsigned int maj, unsigned int min)
+static int cpio_mknod(const char *name, const char *location,
+		      unsigned int mode, uid_t uid, gid_t gid, char dev_type,
+		      unsigned int maj, unsigned int min)
 {
 	int len;
 	unsigned int namesize;
@@ -305,7 +437,8 @@ static int cpio_mknod(const char *name, unsigned int mode,
 	offset += len;
 
 	if (len != CPIO_HDR_LEN ||
-	    push_rest(name, namesize) < 0)
+	    push_rest(name, namesize) < 0 ||
+	    write_xattrs(location) < 0)
 		return -1;
 
 	return 0;
@@ -314,20 +447,26 @@ static int cpio_mknod(const char *name, unsigned int mode,
 static int cpio_mknod_line(const char *line)
 {
 	char name[PATH_MAX + 1];
+	char location[PATH_MAX + 1];
 	unsigned int mode;
 	int uid;
 	int gid;
 	char dev_type;
 	unsigned int maj;
 	unsigned int min;
+	int nfields;
 	int rc = -1;
 
-	if (7 != sscanf(line, "%" str(PATH_MAX) "s %o %d %d %c %u %u",
-			 name, &mode, &uid, &gid, &dev_type, &maj, &min)) {
+	nfields = sscanf(line, "%" str(PATH_MAX) "s %o %d %d %c %u %u %"
+			 str(PATH_MAX) "s", name, &mode, &uid, &gid, &dev_type,
+			 &maj, &min, location);
+	if (nfields < 7) {
 		fprintf(stderr, "Unrecognized nod format '%s'", line);
 		goto fail;
 	}
-	rc = cpio_mknod(name, mode, uid, gid, dev_type, maj, min);
+	rc = cpio_mknod(name,
+			nfields == 8 ? cpio_replace_env(location) : NULL,
+			mode, uid, gid, dev_type, maj, min);
  fail:
 	return rc;
 }
@@ -490,7 +629,7 @@ static int cpio_mkfile(const char *name, const char *location,
 		name += namesize;
 	}
 	ino++;
-	rc = 0;
+	rc = write_xattrs(location);
 
 error:
 	if (file >= 0)
@@ -570,22 +709,24 @@ static int cpio_mkfile_line(const char *line)
 static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage:\n"
-		"\t%s [-t <timestamp>] [-c] [-o <output_file>] [-a <data_align>] <cpio_list>\n"
+		"\t%s [-t <timestamp>] [-c] [-o <output_file>] [-a <data_align>] [-e <type>] <cpio_list>\n"
 		"\n"
 		"<cpio_list> is a file containing newline separated entries that\n"
 		"describe the files to be included in the initramfs archive:\n"
 		"\n"
 		"# a comment\n"
 		"file <name> <location> <mode> <uid> <gid> [<hard links>]\n"
-		"dir <name> <mode> <uid> <gid>\n"
-		"nod <name> <mode> <uid> <gid> <dev_type> <maj> <min>\n"
-		"slink <name> <target> <mode> <uid> <gid>\n"
-		"pipe <name> <mode> <uid> <gid>\n"
-		"sock <name> <mode> <uid> <gid>\n"
+		"dir <name> <mode> <uid> <gid> [<location>]\n"
+		"nod <name> <mode> <uid> <gid> <dev_type> <maj> <min> [<location>]\n"
+		"slink <name> <target> <mode> <uid> <gid> [<location>]\n"
+		"pipe <name> <mode> <uid> <gid> [<location>]\n"
+		"sock <name> <mode> <uid> <gid> [<location>]\n"
 		"\n"
 		"<name>       name of the file/dir/nod/etc in the archive\n"
 		"<location>   location of the file in the current filesystem\n"
 		"             expands shell variables quoted with ${}\n"
+		"             optional for nonregular entries; used to read xattrs\n"
+		"             with -e xattr. If omitted, no xattrs are included.\n"
 		"<target>     link target\n"
 		"<mode>       mode/permissions of the file\n"
 		"<uid>        user id (0=root)\n"
@@ -611,7 +752,8 @@ static void usage(const char *prog)
 		"<output_file>: write cpio to this file instead of stdout\n"
 		"<data_align>: attempt to align file data by zero-padding the\n"
 		"filename field up to data_align. Must be a multiple of 4.\n"
-		"Alignment is best-effort; PATH_MAX limits filename padding.\n",
+		"Alignment is best-effort; PATH_MAX limits filename padding.\n"
+		"<type>: include file metadata: none (default) or xattr.\n",
 		prog);
 }
 
@@ -640,7 +782,7 @@ static const struct file_handler file_handler_table[] = {
 	}
 };
 
-#define LINE_SIZE (2 * PATH_MAX + 50)
+#define LINE_SIZE (3 * PATH_MAX + 50)
 
 int main (int argc, char *argv[])
 {
@@ -650,10 +792,11 @@ int main (int argc, char *argv[])
 	int ec = 0;
 	int line_nr = 0;
 	const char *filename;
+	enum metadata_types metadata_type = TYPE_NONE;
 
 	default_mtime = time(NULL);
 	while (1) {
-		int opt = getopt(argc, argv, "t:cho:a:");
+		int opt = getopt(argc, argv, "t:e:cho:a:");
 		char *invalid;
 
 		if (opt == -1)
@@ -669,6 +812,9 @@ int main (int argc, char *argv[])
 			}
 			do_file_mtime = true;
 			break;
+		case 'e':
+			metadata_type = parse_metadata_type(optarg);
+			break;
 		case 'c':
 			do_csum = true;
 			break;
@@ -721,6 +867,13 @@ int main (int argc, char *argv[])
 		usage(argv[0]);
 		exit(1);
 	}
+	if (metadata_type != TYPE_NONE) {
+		metadata_fd = mkstemp(metadata_path);
+		if (metadata_fd < 0) {
+			fprintf(stderr, "cannot create temporary file\n");
+			exit(1);
+		}
+	}
 
 	while (fgets(line, LINE_SIZE, cpio_list)) {
 		int type_idx;
@@ -777,5 +930,12 @@ int main (int argc, char *argv[])
 	if (ec == 0)
 		ec = cpio_trailer();
 
+	if (metadata_type != TYPE_NONE) {
+		close(metadata_fd);
+		if (unlink(metadata_path))
+			fprintf(stderr,
+				"warning: cannot remove temporary file %s: %s\n",
+				metadata_path, strerror(errno));
+	}
 	exit(ec);
 }
diff --git a/usr/gen_initramfs.sh b/usr/gen_initramfs.sh
index 7eba2fddf0ef..fea88d761d62 100755
--- a/usr/gen_initramfs.sh
+++ b/usr/gen_initramfs.sh
@@ -14,7 +14,7 @@ set -e
 usage() {
 cat << EOF
 Usage:
-$0 [-o <file>] [-l <dep_list>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
+$0 [-o <file>] [-l <dep_list>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} [-e <type>]...
 	-o <file>      Create initramfs file named <file> by using gen_init_cpio
 	-l <dep_list>  Create dependency list named <dep_list>
 	-u <uid>       User ID to map to user ID 0 (root).
@@ -27,6 +27,7 @@ $0 [-o <file>] [-l <dep_list>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
 	<cpio_source>  File list or directory for cpio archive.
 		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
+	-e <type>      File metadata type to include in the cpio archive.
 
 All options except -o and -l may be repeated and are interpreted
 sequentially and immediately.  -u and -g states are preserved across
@@ -113,14 +114,14 @@ parse() {
 
 			[ -b "${location}" ] && dev="b" || dev="c"
 
-			str="${ftype} ${name} ${str} ${dev} ${maj} ${min}"
+			str="${ftype} ${name} ${str} ${dev} ${maj} ${min} ${location}"
 			;;
 		"slink")
 			local target=`readlink "${location}"`
-			str="${ftype} ${name} ${target} ${str}"
+			str="${ftype} ${name} ${target} ${str} ${location}"
 			;;
 		*)
-			str="${ftype} ${name} ${str}"
+			str="${ftype} ${name} ${str} ${location}"
 			;;
 	esac
 
@@ -228,6 +229,10 @@ while [ $# -gt 0 ]; do
 			fi
 			shift
 			;;
+		"-e")   # file metadata type
+			metadata_arg="-e $1"
+			shift
+			;;
 		"-h")
 			usage
 			exit 0
@@ -247,4 +252,4 @@ done
 
 # If output_file is set we will generate cpio archive
 # we are careful to delete tmp files
-usr/gen_init_cpio $output $timestamp $cpio_list
+usr/gen_init_cpio $output $metadata_arg $timestamp $cpio_list
-- 
2.51.0

