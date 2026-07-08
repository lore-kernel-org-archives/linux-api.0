Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8A941737E
	for <linux-api@vger.kernel.org>; Wed,  8 Jul 2026 09:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503301; cv=none; b=S7JupjOrwt8jTxIMLuw/t2L4pTLvqtKcIH619ZwQOB3yj3xGUHAaSjfPQlv42fH8hKc94zDiTs8G8Hkl6SzFfF/zosngNrxFahxpRQFwi4q7fnqqB0LSxJL6BVg2mq0uHkaf+4X69M3jhJinye9fgfLU5G9iZy37q2dwjFSheRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503301; c=relaxed/simple;
	bh=+YM52HXxSxuV5weI/GccaysssIx+dgWT34zTMKItYIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZCAhgP5+J/AgMdcO5kbgBoh30PdHQFdAA6H4JRC7KkjXfX7XrK8baV4uLiBx4v+muELOMUrjoCqYs7GmCvB73MISU6hUo7a4KRuHyPY1volsEYcGMUbcLZOjhiKmldlJifs4RuM+0MQMLuwrnTJNK2iD2gs1xy2suzaW57qh/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fruOiv1C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fruOiv1C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783503297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jpQHmVZWu/cPOGUIrg9MSqvGn+4kpt3IxztqRSV+J7U=;
	b=fruOiv1CyIlnyJAjyrKisJEtdbVZadmKr7FJsPxgvh+qHghioc1kiLLkhNmT5CqCGG6IhO
	6C3Xqk7o71xYX3z/jNB06Lf8RHr6XWPH/AE/EOn2m7RG1ewgMOWTMlY5p8BPjcwBhjQT+0
	Qh22DPQvC2ttSrQT8uK1nbDcOJrOrxo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-LG3sZ6g7MXOdEE8BqjtmHQ-1; Wed,
 08 Jul 2026 05:34:54 -0400
X-MC-Unique: LG3sZ6g7MXOdEE8BqjtmHQ-1
X-Mimecast-MFC-AGG-ID: LG3sZ6g7MXOdEE8BqjtmHQ_1783503294
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E40C41800BD4;
	Wed,  8 Jul 2026 09:34:53 +0000 (UTC)
Received: from oxygen.redhat.com (unknown [10.44.33.242])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC8A51955F7B;
	Wed,  8 Jul 2026 09:34:52 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: linux-erofs@lists.ozlabs.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH 2/2] erofs: add ioctl to retrieve the backing source file descriptor
Date: Wed,  8 Jul 2026 11:34:27 +0200
Message-ID: <20260708093446.3370200-3-gscrivan@redhat.com>
In-Reply-To: <20260708093446.3370200-1-gscrivan@redhat.com>
References: <20260708093446.3370200-1-gscrivan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add EROFS_IOC_GET_SOURCE_FD ioctl that returns a file descriptor to the
backing image file for file-backed erofs mounts.

Returns -ENOENT for block-device-backed erofs mounts where there is no
backing file.

The UAPI constant is defined in include/uapi/linux/erofs.h.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
 fs/erofs/inode.c           | 25 +++++++++++++++++++++++++
 include/uapi/linux/erofs.h |  9 +++++++++
 2 files changed, 34 insertions(+)
 create mode 100644 include/uapi/linux/erofs.h

diff --git a/fs/erofs/inode.c b/fs/erofs/inode.c
index 45afe5c50de8..0a38cb5cfc5d 100644
--- a/fs/erofs/inode.c
+++ b/fs/erofs/inode.c
@@ -6,6 +6,8 @@
  */
 #include "xattr.h"
 #include <linux/compat.h>
+#include <linux/file.h>
+#include <uapi/linux/erofs.h>
 #include <trace/events/erofs.h>
 
 static int erofs_fill_symlink(struct inode *inode, void *bptr, unsigned int ofs)
@@ -356,6 +358,27 @@ static int erofs_ioctl_get_volume_label(struct inode *inode, void __user *arg)
 	return ret ? -EFAULT : 0;
 }
 
+static int erofs_ioctl_get_source_fd(struct file *filp)
+{
+	struct erofs_sb_info *sbi = EROFS_I_SB(file_inode(filp));
+	struct file *f;
+	int fd;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!erofs_is_fileio_mode(sbi))
+		return -ENOENT;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	f = get_file(sbi->dif0.file);
+	fd_install(fd, f);
+	return fd;
+}
+
 long erofs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -364,6 +387,8 @@ long erofs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case FS_IOC_GETFSLABEL:
 		return erofs_ioctl_get_volume_label(inode, argp);
+	case EROFS_IOC_GET_SOURCE_FD:
+		return erofs_ioctl_get_source_fd(filp);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/erofs.h b/include/uapi/linux/erofs.h
new file mode 100644
index 000000000000..17c835785ea9
--- /dev/null
+++ b/include/uapi/linux/erofs.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_EROFS_H
+#define _UAPI_LINUX_EROFS_H
+
+#include <linux/ioctl.h>
+
+#define EROFS_IOC_GET_SOURCE_FD	_IO('e', 1)
+
+#endif /* _UAPI_LINUX_EROFS_H */
-- 
2.55.0

