Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907481;
	b=Y5wuOEcJ1+OHw581ucS4GlUilQcBZsnWYhNoIzTQqrDgqC0Jnu84OQDgn7eZSreCieau
	 sPTH5rCAW8e4tn+Y56tyafBmE+sc2JYV1ZLtW2g5ATcXkkTEMCsFH4M0ujnOMDiOrJ57G
	 +8lIBS7wkF0ldAp/U8ZrTOnT+r5o+bZ4dw7+2Ynr4gATY4hatGMIyg0vQE1K5aIz8w9k6
	 1jHOHcQYdnd7npoW2uigCWXhwfPISwLnF9Ojocw3J6BjqfdleQiVzWtbASaZTifxwDqr8
	 7exz6RIB/L2Oa00qmbZ5XKgB7np4WjeXdYDnz5OypjCCx2lsx1LTtkVyJT7gL6AS+9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907481;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7bcu232iuzEPPkVhi+Cx9Y1OtsDK4XfsaODqfX6al5w=;
	b=LEI+Mb7quTlLhUAo6me8yFAFzExizBW7u48UeX74HFLcjcBWEe1KrAeXMcAzmH6Kq8cf
	 FcBItPGJoFw5qtHGQw3WHrM2WN2rmPxlViIoQVXEUa6nwHwlR+nply8p9KvPHC6Vmr04T
	 g59/ss23ixShc0uQFUnqucnHvBbM2Ta7cF08uZRUo/AO94XHMOU2dZVDKCUcGoY1Bx/DG
	 aNjjWuTs4Syc/dpeigqVhZ/d7etYmcXXMsBjTectgOa+ApbuxzpMTKbH81rjJI1VuzT0X
	 OJIHA74T6bCgdoOsgRWbDR2Le2m9K90e9P0zGzDlIpmWLJfNIvkRXXIg3sZtCKU2khA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arista.com;
	spf=pass smtp.mailfrom=arista.com;
	dkim=pass header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=VLc5JO6+;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1601E60A380D
	for <linux-api@vger.kernel.org>; Thu,  5 Nov 2026 19:38:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1601E60A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arista.com header.i=@arista.com header.a=rsa-sha256 header.s=google header.b=VLc5JO6+
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-33fb4680717so27479eec.1
        for <linux-api@vger.kernel.org>; Thu, 05 Nov 2026 11:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1793907480; x=1794512280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7bcu232iuzEPPkVhi+Cx9Y1OtsDK4XfsaODqfX6al5w=;
        b=VLc5JO6+rtl2MZnTRl0v2elWuOG0Y46MfP965Kk3L89ZYPzgE8rEodLj9EG0gERh+j
         Ix39sOI1xDDG/REcON8G+2lsyCO0Y40eNm92u5XtpJLrIPUwiagQWgQOEg62a1o161mm
         tzpfSJoNndqw0YdEEtpWa1jjgMe7ZyaGvsoq5oy8KVjb3NNO9qdpXrqDrNdbWWZ0llLd
         ZjYKfYH7wbDOSsKn5NF/rz34DHhXdKuTomP/7LdK5c2K5cUdhQaMMsPwlLKzRldzYwYP
         FXs/pVuK0naPTUC92O9sOUi/TIdcNl5FU5YN+R/5Cy/cWzMe/0irjm0pzQVf3Hgle+pg
         K0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793907480; x=1794512280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7bcu232iuzEPPkVhi+Cx9Y1OtsDK4XfsaODqfX6al5w=;
        b=KchOIdl6jKautMuzjwSvPONMh1HWlDcxah6eHFj+nqGDYdDcnrUk8RF8SuSr8aNAw+
         lFVOf+7KFnaCIIHmFenErz1mqzMC7RW6YIiheksEePXscVeoTU+9UfA6EKcmmOrKrxNI
         ke+9pY/1JD+a/DdWb0vP5k5yU54acttJKd9eTBrbfUC7qMc8VACledrVZaQEyydHJPgs
         xupY2xxVepBNhHl6IwSdZnHTK0nzA++eHRIeIaLsCVqj7admK5uZpyfvNJiZMpCyYXef
         UWz6O1Y/u8Q25PwAfJ6Ksfgz/IZEiEdVgjPGzO4z4Xv1f6zvRP8h6bRlcr2NWJrw2Jch
         Licg==
X-Forwarded-Encrypted: i=1; AKwUvBzieMJlnVKJGf9VQk2t9r+LrQH3QH4ZpL2ne9lOudopLnqOVY961UwPgB4S72P1a56QmrpJ2xNLtsM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9j+vvKRJrsmLvWWEFxuwHBNszy4YTo+zcYJDp4ET8dbqjIc3so
	UlFtLs5K1yf2dENQrfeWu91QngCkX2HKfIY4/rlyDD4JV+K/3PJkQ7nL91vlyAd0Ww==
X-Gm-Gg: AYBFou0jXNNI/9sihPOgw962UBY27YiaGKNM6h34+hWjk4rC2FTkhfbYSJmT0iiHhT/
	InxDXIJX85wCI+ocNyOqqRJ+/At3gXhXR0STfKKIxquePaKUy/UCS+9vXcH2c94gK0+SahmzL2Q
	OwGNo1SyFkxhk3SExUG8yZ4an4iNK+575Dkiss9pXbjuYz7SY2virMDGrh4v9z/r3gLtO7DH6Rq
	/Eszmla51KFAu2dBFnnQB/Ji/coRaq7xvMhxZmC+wbo+iwGPxionb0N5L8SXbLvXG1/qPqa2HRf
	sQs/d75P/qE0OJoKoTOVGSZPszMDH76WhODXfpYu3K+n/ZOatbVKHseF1Zb2JK8xZx1/nhIR2LC
	3tIccTatOogftouLc3jhz9o9QTCTGZM3J/pp9G+IvkaOPiPkVUyRSJEuegGBdq8DEmmyKIS7mTD
	QjlX2Rx8TYita536wpbOTDIJfc6sXAJ1RmZOS1OzzUXORurUyQpCzHfGfyDgeOxbns94OAJcbMw
	ab8RgNtNXc1yQCuDFsImGgtmWU38pU41g5gLbSflxo3Wx9/WJXs+B4Vec/mT2U1Iq7AWNpxJXqC
	oHuRezichIHFM2TL2Upf9ZSr9yp9ARlpsqkTGqBv1qycPExD75LFacO00ouXNZaams/sDnyyAoX
	a8i6R3HdOVWP222CYbyBN0X4=
X-Received: by 2002:a05:7300:dd06:b0:36d:b933:675c with SMTP id 5a478bee46e88-36f75b1f6b4mr184738eec.17.1793907479989;
        Thu, 05 Nov 2026 11:37:59 -0800 (PST)
Received: from dannyhu-upstreamLinux.sjc.aristanetworks.com ([74.123.28.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36f72ec8a02sm326134eec.11.2026.11.05.11.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:37:59 -0800 (PST)
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
Subject: [PATCH v6 4/4] gen_init_cpio: add support for file metadata
Date: Thu,  5 Nov 2026 11:37:43 -0800
Message-ID: <20261105193743.2654656-5-dannyhu@arista.com>
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
Changes in v6:
 - Detect if path is NULL in write_xattrs and early return
 - Define __packed before including initramfs.h in gen_init_cpio.c

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
 usr/gen_init_cpio.c  | 221 +++++++++++++++++++++++++++++++++++++------
 usr/gen_initramfs.sh |  15 ++-
 4 files changed, 224 insertions(+), 34 deletions(-)

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
index b7296edc6626..64ac78e68087 100644
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
@@ -14,6 +15,12 @@
 #include <ctype.h>
 #include <limits.h>
 
+#ifndef __packed
+#define __packed __attribute__((__packed__))
+#endif
+
+#include "../include/linux/initramfs.h"
+
 /*
  * Original work by Jeff Garzik
  *
@@ -37,12 +44,126 @@ static bool do_file_mtime;
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
+	if (metadata_fd < 0 || !path)
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
@@ -119,7 +240,8 @@ static int cpio_trailer(void)
 }
 
 static int cpio_mkslink(const char *name, const char *target,
-			 unsigned int mode, uid_t uid, gid_t gid)
+			const char *location, unsigned int mode,
+			uid_t uid, gid_t gid)
 {
 	int len;
 	unsigned int namesize, targetsize = strlen(target) + 1;
@@ -150,7 +272,8 @@ static int cpio_mkslink(const char *name, const char *target,
 	    push_buf(name, namesize) < 0 ||
 	    push_pad(padlen(offset, 4)) < 0 ||
 	    push_buf(target, targetsize) < 0 ||
-	    push_pad(padlen(offset, 4)) < 0)
+	    push_pad(padlen(offset, 4)) < 0 ||
+	    write_xattrs(location) < 0)
 		return -1;
 
 	return 0;
@@ -161,22 +284,29 @@ static int cpio_mkslink_line(const char *line)
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
@@ -204,7 +334,8 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 	offset += len;
 
 	if (len != CPIO_HDR_LEN ||
-	    push_rest(name, namesize) < 0)
+	    push_rest(name, namesize) < 0 ||
+	    write_xattrs(location) < 0)
 		return -1;
 
 	return 0;
@@ -239,18 +370,24 @@ static const struct generic_type generic_type_table[] = {
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
+			    nfields == 5 ? cpio_replace_env(location) : NULL,
+			    mode, uid, gid);
  fail:
 	return rc;
 }
@@ -270,9 +407,9 @@ static int cpio_mksock_line(const char *line)
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
@@ -305,7 +442,8 @@ static int cpio_mknod(const char *name, unsigned int mode,
 	offset += len;
 
 	if (len != CPIO_HDR_LEN ||
-	    push_rest(name, namesize) < 0)
+	    push_rest(name, namesize) < 0 ||
+	    write_xattrs(location) < 0)
 		return -1;
 
 	return 0;
@@ -314,20 +452,26 @@ static int cpio_mknod(const char *name, unsigned int mode,
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
@@ -490,7 +634,7 @@ static int cpio_mkfile(const char *name, const char *location,
 		name += namesize;
 	}
 	ino++;
-	rc = 0;
+	rc = write_xattrs(location);
 
 error:
 	if (file >= 0)
@@ -570,22 +714,24 @@ static int cpio_mkfile_line(const char *line)
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
@@ -611,7 +757,8 @@ static void usage(const char *prog)
 		"<output_file>: write cpio to this file instead of stdout\n"
 		"<data_align>: attempt to align file data by zero-padding the\n"
 		"filename field up to data_align. Must be a multiple of 4.\n"
-		"Alignment is best-effort; PATH_MAX limits filename padding.\n",
+		"Alignment is best-effort; PATH_MAX limits filename padding.\n"
+		"<type>: include file metadata: none (default) or xattr.\n",
 		prog);
 }
 
@@ -640,7 +787,7 @@ static const struct file_handler file_handler_table[] = {
 	}
 };
 
-#define LINE_SIZE (2 * PATH_MAX + 50)
+#define LINE_SIZE (3 * PATH_MAX + 50)
 
 int main (int argc, char *argv[])
 {
@@ -650,10 +797,11 @@ int main (int argc, char *argv[])
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
@@ -669,6 +817,9 @@ int main (int argc, char *argv[])
 			}
 			do_file_mtime = true;
 			break;
+		case 'e':
+			metadata_type = parse_metadata_type(optarg);
+			break;
 		case 'c':
 			do_csum = true;
 			break;
@@ -721,6 +872,13 @@ int main (int argc, char *argv[])
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
@@ -777,5 +935,12 @@ int main (int argc, char *argv[])
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

