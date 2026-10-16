Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431224519AA
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161430; cv=none; b=SLbbJotrAoCEK0+BBlDqXb6ondfz9+kwQlmAomf88RWxKlIqrmWazLhnTe968HlGr3Rpim9IHPmE3ftzopeHxCOwcBuNqyX/7vz/K/+VZiV59Np7rqWXl8X5d02jhatOLKvrVWHl8aNLMg664BaBUpv8xc5ZlZJTpJbrUQdgQq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161430; c=relaxed/simple;
	bh=TvFgq/dwnhWhXTs1Ma/IRs/wNwaqTxXDSC+rQuWR4A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZLkGkPwTvDySAcwKJsuQfDGRQ4CUAkYKeQTPbqsYrwpuZw9Wc7BKSo0/4bvexkZm0WXeoPu9s00Rhr7yW1YdjfKrlqhbYomM18zZYdmlheWIYTEdW1l5Hh3mU6HtX5bYqVoFujSGt/xhUpD7vBRRFSnO6TZ5Ldw72y2mKaX4rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=gUJgLTom; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="gUJgLTom"
X-KPN-MessageId: 0b54b103-c96f-11f1-bfc1-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 0b54b103-c96f-11f1-bfc1-00505699b430;
	Fri, 16 Oct 2026 16:36:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=78MPMbGST82mWlZceaziz908IXxPoLSfDnc6dkhjDFU=;
	b=gUJgLTomvrpoEmVthqDGPC0VMtucjAPJ0Ujg556yXIzTeKbBvbvBejtHfQtga+fmXw85V0oiYuYwc
	 b9lHpkjDrUcj2K311LNhGozFk1W8S9X+sEFVk3sQpc1UB+UJPJuPaIfQtaxgPrFKmZBNcmz0qIVrwv
	 PdPvX4rBrFk/DBiQD+2np+jFkYmYR5SG9ZcjLSX2RQv7vGFkQAaGOhcDfMv9DED6gKoQYbvzVJdjZO
	 t8lLSfcBEJKHJ8Wrp3QSUCQasHh/O+MOc2HIxs2ANIZZYjqg7mUWfHPvwnF8uIEp67QB7MFRDIMBZt
	 Cs1izK1h+PipAGKjj+XXp3mttEa454A==
X-KPN-MID: 33|yO7hHp2coDkb47xWUTfPL8uZ9ZpE5VRjZrcJxWqu/4dE7QtswDnJaUj/5ROK5sq
 OPDA2+duUJ1XMPXNvnaf+YyvTdYfCcHhqQHRmDCG8qAw=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|KQ8RAKI3I98DUEYV6HY0paGr2Jr1o2AJp/jID2ZY3FWY60y4EPX18pAJP42uP0H
 BGYbPh/EFzSS+a/ffbo7v6w==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 0b0e0ac6-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:36:59 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jori Koolstra <jkoolstra@xs4all.nl>
Subject: [PATCH v7 02/12] vfs: prepare vfs_creat|mkdir_no_perm for reuse in lookup_open()
Date: Fri, 16 Oct 2026 16:37:56 +0200
Message-ID: <20261016143806.2946578-3-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
References: <20261016143806.2946578-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To implement O_CREAT|O_DIRECTORY we will have to repeat some of the
logic that is now in vfs_mkdir() (e.g. do error checks in the same
order). Separate this out in vfs_mkdir_no_perm(), which does all the
non-permission related work of vfs_mkdir(). Permission checking for the
lookup_open() path is timed differently because we may just be doing an
open and no create. Similar considerations give rise to
vfs_create_no_perm().

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/namei.c | 77 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 839258260ad5..ab09dd7f7475 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4195,6 +4195,24 @@ static inline umode_t vfs_prepare_mode(struct mnt_idmap *idmap,
 	return mode;
 }
 
+static inline
+int vfs_create_no_perm(struct mnt_idmap *idmap, struct dentry *dentry,
+		       umode_t mode, struct delegated_inode *di)
+{
+	struct inode *dir = d_inode(dentry->d_parent);
+	int error;
+
+	error = try_break_deleg(dir, LEASE_BREAK_DIR_CREATE, di);
+	if (error)
+		return error;
+
+	error = dir->i_op->create(idmap, dir, dentry, mode);
+	if (!error)
+		fsnotify_create(dir, dentry);
+
+	return error;
+}
+
 /**
  * vfs_create - create new file
  * @idmap:	idmap of the mount the inode was found from
@@ -4227,13 +4245,8 @@ int vfs_create(struct mnt_idmap *idmap, struct dentry *dentry, umode_t mode,
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
-	error = try_break_deleg(dir, LEASE_BREAK_DIR_CREATE, di);
-	if (error)
-		return error;
-	error = dir->i_op->create(idmap, dir, dentry, mode);
-	if (!error)
-		fsnotify_create(dir, dentry);
-	return error;
+
+	return vfs_create_no_perm(idmap, dentry, mode, di);
 }
 EXPORT_SYMBOL(vfs_create);
 
@@ -4447,6 +4460,7 @@ static struct dentry *atomic_open(const struct path *path, struct dentry *dentry
 		dput(dentry);
 		dentry = ERR_PTR(error);
 	}
+
 	return dentry;
 }
 
@@ -4573,6 +4587,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 			dentry = res;
 		}
 	}
+
 	if (dentry->d_inode || !(op->open_flag & O_CREAT)) {
 		/*
 		 * No need to create a file.  If lookup returned a positive
@@ -5387,6 +5402,33 @@ SYSCALL_DEFINE3(mknod, const char __user *, filename, umode_t, mode, unsigned, d
 	return filename_mknodat(AT_FDCWD, name, mode, dev);
 }
 
+static inline
+struct dentry *vfs_mkdir_no_perm(struct mnt_idmap *idmap, struct inode *dir,
+				 struct dentry *dentry, umode_t mode,
+				 struct delegated_inode *di)
+{
+	unsigned max_links = dir->i_sb->s_max_links;
+	struct dentry *de;
+	int error;
+
+	if (max_links && dir->i_nlink >= max_links)
+		return ERR_PTR(-EMLINK);
+
+	error = try_break_deleg(dir, LEASE_BREAK_DIR_CREATE, di);
+	if (error)
+		return ERR_PTR(error);
+
+	de = dir->i_op->mkdir(idmap, dir, dentry, mode);
+	if (IS_ERR(de))
+		return de;
+	if (de) {
+		dput(dentry);
+		dentry = de;
+	}
+	fsnotify_mkdir(dir, dentry);
+	return dentry;
+}
+
 /**
  * vfs_mkdir - create directory returning correct dentry if possible
  * @idmap:		idmap of the mount the inode was found from
@@ -5414,7 +5456,6 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 			 struct delegated_inode *delegated_inode)
 {
 	int error;
-	unsigned max_links = dir->i_sb->s_max_links;
 	struct dentry *de;
 
 	error = may_create_dentry(idmap, dir, dentry);
@@ -5430,24 +5471,12 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	if (error)
 		goto err;
 
-	error = -EMLINK;
-	if (max_links && dir->i_nlink >= max_links)
-		goto err;
-
-	error = try_break_deleg(dir, LEASE_BREAK_DIR_CREATE, delegated_inode);
-	if (error)
+	de = vfs_mkdir_no_perm(idmap, dir, dentry, mode, delegated_inode);
+	if (IS_ERR(de)) {
+		error = PTR_ERR(de);
 		goto err;
-
-	de = dir->i_op->mkdir(idmap, dir, dentry, mode);
-	error = PTR_ERR(de);
-	if (IS_ERR(de))
-		goto err;
-	if (de) {
-		dput(dentry);
-		dentry = de;
 	}
-	fsnotify_mkdir(dir, dentry);
-	return dentry;
+	return de;
 
 err:
 	end_creating(dentry);
-- 
2.56.0

