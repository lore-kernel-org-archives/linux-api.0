Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436C9242910;
	Thu, 20 Aug 2026 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230963; cv=none; b=cWiutemtlcCiV4arpL0kFyeKn8/9u3kMLLhvsd0tlSbe8bvxyaObDaceUHAdcOyQuLiVRxm+CFAv2ne9NjgRYexIAbJUGsGnJ1lSpOx5nxmp56WxaETqoI7G8xzNkRx9Tgxnqw4L9r5W7UWSXvBwyban/eaCRJZhPS4LcH78yjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230963; c=relaxed/simple;
	bh=3BOSagCYHSXYSSlAI3BXVEaLc7IJaiOllCs2CcwHhyc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axonnfRxiW2MyBjMdaMR7TovJn8UoDTv9bjS/tbV8NBWyBlJrKlDMqKFmkhVmd6/HKutB9Qfe5UsA+sygATFd53ONpwjEctnf+zMtX9W5OU2RP9Z+2v8FBVXI0MRU2hoCArc/Rzx7cwt4b78hPSyEJS4ltAIy0hollbdzAzJdM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=shL2wc0C; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="shL2wc0C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787230962; x=1818766962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TmhlGf2UjnP+JtX2La7bxsJ2rBRB1E5qckNV4lWaN1E=;
  b=shL2wc0C/7G2kGS488jcqAce68fJoLT06RmtJQ1tBzWi+KtBj5faaB6E
   Q0ZNUSzC1CcwZoJfCxZdMr+q+M+7pRSO58vgJVcgXCUgYnV15V54qPMvC
   JnQ4WKg8Gp3j7YTomOANf0Ipw0nX85aQRcx5ubCJQe3mOMTBJ4CWh/nPj
   +3dHPsZ77f7q9FUhD67XrDP+cZRsDczh/2vmJ3N6gza/lFzIqqLCJqlcH
   +rdgOU2WNT+SKt3T5T+73m1XcP5AVMibussHcTgQZEj2ua0g3ERDVMkEt
   IdvO9ik0N/zQWKoZLaS/lEk1DXvx2l2oSfhmc86nbU4wQEu7OwgRAiTC9
   w==;
X-CSE-ConnectionGUID: QI4sMvMXRVem7H/WweT9xQ==
X-CSE-MsgGUID: 5xnput/SScCTHmYrnkEpKQ==
X-IronPort-AV: E=Sophos;i="6.25,233,1779148800"; 
   d="scan'208";a="26501818"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 13:02:42 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:9293]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.75:2525] with esmtp (Farcaster)
 id 6e438dc1-2af6-4d16-9ca6-4222d902327f; Thu, 20 Aug 2026 13:02:41 +0000 (UTC)
X-Farcaster-Flow-ID: 6e438dc1-2af6-4d16-9ca6-4222d902327f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 20 Aug 2026 13:02:41 +0000
Received: from dev-dsk-jamz-1e-e35f4cd9.us-east-1.amazon.com (10.189.35.140)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 20 Aug 2026 13:02:40 +0000
From: Jimmy Zuber <jamz@amazon.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <fuse-devel@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-api@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Shuah Khan
	<shuah@kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v3 1/2] fuse: allow FUSE_SYNCFS for privileged userspace servers
Date: Thu, 20 Aug 2026 13:01:57 +0000
Message-ID: <20260820130158.254808-2-jamz@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260820130158.254808-1-jamz@amazon.com>
References: <20260820130158.254808-1-jamz@amazon.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWB002.ant.amazon.com (10.13.139.185) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Propagating syncfs()/sync() to a FUSE server via FUSE_SYNCFS lets the
server flush its own cached or intermediate state when userspace asks the
filesystem to sync.  This is currently enabled only for virtiofs and
fuseblk, because an untrusted server can use it to stall sync()
indefinitely (see commit 2d82ab251ef0 ("virtiofs: propagate sync() to file
server"), and commit d3906d8f3cee ("fuse: enable FUSE_SYNCFS for all
fuseblk servers")).  Both of those mount types require host privilege to
set up, so the server is trusted not to abuse it.

There is nothing virtiofs- or block-specific about wanting to handle
syncfs(), though.  A plain /dev/fuse server is just as entitled to
participate in the sync() path -- so that data it has buffered reaches
stable storage when the user asks for it -- provided it is equally
trusted.

The trust property that virtiofs and fuseblk satisfy is that neither can
be mounted without CAP_SYS_ADMIN in the initial user namespace (neither
sets FS_USERNS_MOUNT).  A plain fuse mount does set FS_USERNS_MOUNT, so its
existence guarantees no such privilege; the privilege has to be checked
rather than assumed.

Add an opt-in INIT flag, FUSE_HAS_SYNCFS, and honor it only when the
server opened /dev/fuse with CAP_SYS_ADMIN in the initial user namespace,
recorded at mount time via file_ns_capable().  This is the same privilege
that mounting virtiofs or fuseblk requires, applied to the process that
actually services (and could stall) the connection.  Checking the device
opener's capability -- rather than the mount's user namespace -- avoids
treating an unprivileged server that merely happens to run in the initial
user namespace (e.g. a normal sshfs mount) as trusted.

The flag is only advertised to servers that pass this check, so an
unprivileged server is never invited to opt in (and is ignored by
fuse_syncfs_enable() if it sets the flag anyway).

Signed-off-by: Jimmy Zuber <jamz@amazon.com>
Assisted-by: Claude:claude-opus-4-8 [Claude-Code]
---
 fs/fuse/fuse_i.h          |  9 +++++++++
 fs/fuse/inode.c           | 28 ++++++++++++++++++++++++++++
 include/uapi/linux/fuse.h | 12 +++++++++++-
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c8d4c5f3af7e..97d356588d00 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -391,6 +391,7 @@ struct fuse_fs_context {
 	bool no_control:1;
 	bool no_force_umount:1;
 	bool legacy_opts_show:1;
+	bool syncfs_capable:1;
 	enum fuse_dax_mode dax_mode;
 	unsigned int max_read;
 	unsigned int blksize;
@@ -675,6 +676,14 @@ struct fuse_conn {
 	/** @sync_fs: Propagate syncfs() to server */
 	unsigned int sync_fs:1;
 
+	/**
+	 * @syncfs_capable: the privilege required to honor FUSE_HAS_SYNCFS was
+	 * present when /dev/fuse was opened (CAP_SYS_ADMIN in the initial user
+	 * namespace), i.e. the same privilege that mounting virtiofs/fuseblk
+	 * requires.
+	 */
+	unsigned int syncfs_capable:1;
+
 	/** @init_security: Initialize security xattrs when creating a new inode */
 	unsigned int init_security:1;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1c6ee01c6796..970d4d2e9833 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -803,6 +803,15 @@ static int fuse_opt_fd(struct fs_context *fsc, struct file *file)
 	if (file->f_cred->user_ns != fsc->user_ns)
 		return invalfc(fsc, "wrong user namespace for fuse device");
 
+	/*
+	 * Record whether the server opened /dev/fuse with CAP_SYS_ADMIN in the
+	 * initial user namespace -- the same privilege that mounting virtiofs
+	 * or fuseblk requires.  Only such servers are trusted to receive
+	 * FUSE_SYNCFS (see fuse_syncfs_enable()).
+	 */
+	ctx->syncfs_capable = file_ns_capable(file, &init_user_ns,
+					      CAP_SYS_ADMIN);
+
 	ctx->fud = fuse_dev_grab(file);
 
 	return 0;
@@ -1269,6 +1278,16 @@ struct fuse_init_args {
 	struct fuse_mount *fm;
 };
 
+/*
+ * A server can stall syncfs()/sync(), so only honor FUSE_HAS_SYNCFS for
+ * servers that opened /dev/fuse with CAP_SYS_ADMIN in the initial user
+ * namespace -- the same privilege required to mount virtiofs or fuseblk.
+ */
+static bool fuse_syncfs_enable(struct fuse_conn *fc, u64 flags)
+{
+	return (flags & FUSE_HAS_SYNCFS) && fc->syncfs_capable;
+}
+
 static void process_init_reply(struct fuse_args *args, int error)
 {
 	struct fuse_init_args *ia = container_of(args, typeof(*ia), args);
@@ -1410,6 +1429,9 @@ static void process_init_reply(struct fuse_args *args, int error)
 
 			if (flags & FUSE_REQUEST_TIMEOUT)
 				timeout = arg->request_timeout;
+
+			if (fuse_syncfs_enable(fc, flags))
+				fc->sync_fs = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1479,6 +1501,11 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
 		flags |= FUSE_SUBMOUNTS;
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
+	/* Only offered to sufficiently privileged servers; see
+	 * fuse_syncfs_enable().
+	 */
+	if (fm->fc->syncfs_capable)
+		flags |= FUSE_HAS_SYNCFS;
 
 	/*
 	 * This is just an information flag for fuse server. No need to check
@@ -1774,6 +1801,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 
 	fc->default_permissions = ctx->default_permissions;
 	fc->allow_other = ctx->allow_other;
+	fc->syncfs_capable = ctx->syncfs_capable;
 	fc->user_id = ctx->user_id;
 	fc->group_id = ctx->group_id;
 	fc->legacy_opts_show = ctx->legacy_opts_show;
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 7435e09c87fe..10a7f31c4bdf 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -248,6 +248,9 @@
  *  - add bufpool offset field to fuse_uring_ent_in_out struct
  *  - add FUSE_URING_ZERO_COPY, FUSE_URING_ENT_ZERO_COPY, and
  *    FOPEN_IO_URING_ZERO_COPY flag
+ *
+ *  7.47
+ *  - add FUSE_HAS_SYNCFS opt-in flag for privileged userspace servers
  */
 
 #ifndef _LINUX_FUSE_H
@@ -283,7 +286,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 46
+#define FUSE_KERNEL_MINOR_VERSION 47
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -464,6 +467,12 @@ struct fuse_file_lock {
  * FUSE_REQUEST_TIMEOUT: kernel supports timing out requests.
  *			 init_out.request_timeout contains the timeout (in secs)
  * FUSE_HAS_IO_URING_BUFPOOL: kernel supports io-uring buffer pools
+ * FUSE_HAS_SYNCFS: server requests that syncfs()/sync() be propagated as
+ *		FUSE_SYNCFS requests.  Since an untrusted server can use this
+ *		to stall sync(), it is only honored when /dev/fuse was opened
+ *		with CAP_SYS_ADMIN in the initial user namespace (the same
+ *		privilege that mounting virtiofs or fuseblk requires).
+ *		Insufficiently privileged servers ignore it.
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -512,6 +521,7 @@ struct fuse_file_lock {
 #define FUSE_OVER_IO_URING	(1ULL << 41)
 #define FUSE_REQUEST_TIMEOUT	(1ULL << 42)
 #define FUSE_HAS_IO_URING_BUFPOOL (1ULL << 43)
+#define FUSE_HAS_SYNCFS		(1ULL << 44)
 
 /**
  * CUSE INIT request/reply flags
-- 
2.50.1

