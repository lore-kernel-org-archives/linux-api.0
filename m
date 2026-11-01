Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793498254;
	b=VZoIYEcRV2TWGFn3Br0KJ1veqYD445QqzAj+jpILuycOLDwb2TJGSFc1HTUGzdl/CSvl
	 C2Kne5XYsc/pUS3C3nzBHqyqVCTlifaEXFi4SFoZ0rszR36GC20UDkatkwX4DbEIZwY0h
	 HVvtJxCffcs1OghSwMSBFp8CRF1LA8ikQPtraERzSj0WomVga5cVHgxFdlaUFrpnzL85t
	 HiwOlETUHYjGFugzDdk8FgKA9A7ioUerrTXK1JJNRyiEYv2zzy/tYlDcP2+xz8Vx9/o3y
	 1rWw9X/jiSJpsRRI5IeeE7VlNNE0crQiKQK1MVnlqKUWPahYAM7NBS9e0pOdClgEo5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793498254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wh05uwxck5UmOLJ9YmZlO1YWWLOh3OZ0b/ieclJl0NA=;
	b=SLfEYybLv1vIkZRDlhx9UgRXvfCwjEnjmkJQ0akA/2CfkDpnQAqaQiWqBIu+BpLOMtpS
	 P+KwJRyQ5JZztHiW5GDnKXoSmm4q3RdJE1C+r3PvNPwjHkBTJ3c0GX3H7m+2+6loH4DAd
	 3ZtfLmAntS7T/zQPEH7b1OivtY0hev9rxlJkhM4RjIzm8jIYoNtCOXUL7HNPoo9jArhiS
	 kN4TKkLOUVQha9zgB+LwQtJWzMjTrZpPfv7JIBnLiP/0+b9q8lTeetf2uzKaQRUmt5Tmc
	 tbMAem2tfX50u3OY315SIDz+OcIaHepT3ErEWoZozJtBod+jsUGU1Z8c2Wjx7SREB5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="jOyfQ/WX";
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EDD60A3818
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 01:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75EDD60A3818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jOyfQ/WX
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso12134755e9.0
        for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 18:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793498253; x=1794103053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wh05uwxck5UmOLJ9YmZlO1YWWLOh3OZ0b/ieclJl0NA=;
        b=jOyfQ/WX0fZmp0JTYzxlMBtqPLgymsXeoaUemAGVw5rAyPbGNVSlaWNAUiREmtZx9w
         YqYq6+GmYgyBjA2Gx40WVdHba8BGnC1NlwYDRiuOEsehWzj9WrEBKx+izfjK9DDNjtCv
         u1KV3kBGsDDm21Eo7t7mm4sZCLxUnFJudWJXzNgqNGdGM28sGNTydoqOwy6oDsUUbPU5
         mEqHu3zdSgQgZ/jZXXs6h0K5724Cx0vcwRCdfF0jb+Fo/wliD+pxZ+U+tqWJMcaftgXv
         OB2mwICPVi9LpecqH+POditYftUol/J1LSNN1maMAXCSawb+md+wM8DnjP+NlndKH5FJ
         H/rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793498253; x=1794103053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wh05uwxck5UmOLJ9YmZlO1YWWLOh3OZ0b/ieclJl0NA=;
        b=fP3mMrW2WahCbVDo++97LHrlikd23fMKPQPp3bbtvfuemsFoQXIcCnf1ToAczPUd+H
         0JxKuPO0diABU3af/aTbG+EX/l4ETeavbnjlbPuj8E4OeJMwx/qzkoOgaPWMkm3l+Prn
         4G/C5/eSfUwInf6eUkxwkFWkmESPhiQgk4bpGcRffrwXKCzR+XLQfdxR5fLA1aJEW8qz
         0FtxfLc8YBZRr1HvCBEBY6OwSdUjo7lIbQRemcruBoc+qCjMwncbnvYUiOv+9znqq5RG
         LPkhjHQaZq82ZohD4u/Af6Tyo64TBH4dmbyNm/j+MCHHZOB+IvVVY84QI82i2MsBRbpG
         wDjA==
X-Forwarded-Encrypted: i=1; AKwUvBz1PHTR4y3+v/pKRGq9w2TLXUu3dyLHQeATzvci+Vqbh/HGLAyMWILRGmHQQYHnLOAXRM1/+MSAuZ0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJDz067Fmk3yZblbLxvQGO3uKRzvAZqjXNNQwhKVE9PzjmvFmww
	w5OF0nIQHjEQID9Sfwo9R0E19/tK247GjkhyvLDNkcstkj4ohn1teQmE
X-Gm-Gg: AYBFou3oHl2rfr/zbU3fOcl4b0RHNguAWFa817KedFFK1CNjvqEsUGz0GN3ALJW4ht+
	aT6gbg6dlYAWUs6EZpS3UeQNS9bi722j2BmxCr+rUnBWVTVHxPkK9BS5zU78ex6hwVI9r/EDAHN
	r9q+pWOZaApeD9sx/j/Z/XVtsNj/woQsmSaT2ysk/f7hCuy9prqGO3HAAyMNI3FmZJIQODIXGV/
	0BiUxaUNfsXxJRkz32ttKeO09IXpcobVTlrADHtAbkZ3rZ5xEpY/PfhhFIel+Q1Ohg4CnWaPipx
	ue0Xx8D/IBW0N5m0yR4eIq22EpYMtFn7rX685BofoC0kiRuFX9kI3TwCmMOI8P0/Xcm9bsncl/r
	xIeWTNRue3oOas1AxVx6d/EG0SRM1jzMAb0Pw/oeahEvFMwZXBvJm8uL/QpWH3Pkv+ivj70OaEh
	5MUWekQ0u7IXt0E/3QCiUnLHUlIP8LtHeRMZneVmRLkV4TNMV+hwK+2FJ6LQAjbD42eXpFe+szD
	GBUlSnI01uf3WOovGQhp5BMUAFmF/wsSW32jkJKa7g7GUaboVBFMn42aYcV5J5s551yrPgztC9Q
	I/v+Nwduj99gJWQa2FUDnu4q
X-Received: by 2002:a05:600c:630d:b0:4a7:a309:6b73 with SMTP id 5b1f17b1804b1-4ac150b2896mr139236435e9.1.1793498252977;
        Sat, 31 Oct 2026 18:57:32 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm273532835e9.11.2026.10.31.18.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:57:32 -0700 (PDT)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Chris Mason <mason@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <cel@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v3 5/5] btrfs: add provenance time (ptime)
Date: Sun,  1 Nov 2026 02:55:51 +0100
Message-ID: <20261101015551.786044-6-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101015551.786044-1-koray.fra@gmail.com>
References: <20261101015551.786044-1-koray.fra@gmail.com>
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

Implement provenance time (ptime) in Btrfs, as introduced in a
previous commit ("vfs: add provenance time (ptime)").

Update the on-disk format by claiming 12 bytes from the reserved[] space
in btrfs_inode_item, putting ptime before other timestamps.

Also, set .fileattr_[gs]et to btrfs_fileattr_[gs]et() for both
symlinks and special files.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/btrfs/btrfs_inode.h          |  4 ++++
 fs/btrfs/delayed-inode.c        |  6 ++++++
 fs/btrfs/inode.c                | 29 ++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.c                | 13 ++++++++++++-
 fs/btrfs/print-tree.c           |  1 +
 fs/btrfs/tree-log.c             |  3 +++
 include/uapi/linux/btrfs_tree.h |  3 ++-
 7 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0782f917fccc..c9822340567a 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -332,6 +332,10 @@ struct btrfs_inode {
 	u64 i_otime_sec;
 	u32 i_otime_nsec;
 
+	/* File *data* creation (provenance) time. */
+	s64 i_ptime_sec;
+	u32 i_ptime_nsec;
+
 	/* Hook into fs_info->delayed_iputs */
 	struct list_head delayed_iput;
 
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 333ce8b52489..eef73ebb4a52 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1932,6 +1932,9 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_stack_timespec_sec(&inode_item->otime, inode->i_otime_sec);
 	btrfs_set_stack_timespec_nsec(&inode_item->otime, inode->i_otime_nsec);
+
+	btrfs_set_stack_timespec_sec(&inode_item->ptime, inode->i_ptime_sec);
+	btrfs_set_stack_timespec_nsec(&inode_item->ptime, inode->i_ptime_nsec);
 }
 
 int btrfs_fill_inode(struct btrfs_inode *inode, u32 *rdev)
@@ -1981,6 +1984,9 @@ int btrfs_fill_inode(struct btrfs_inode *inode, u32 *rdev)
 	inode->i_otime_sec = btrfs_stack_timespec_sec(&inode_item->otime);
 	inode->i_otime_nsec = btrfs_stack_timespec_nsec(&inode_item->otime);
 
+	inode->i_ptime_sec = btrfs_stack_timespec_sec(&inode_item->ptime);
+	inode->i_ptime_nsec = btrfs_stack_timespec_nsec(&inode_item->ptime);
+
 	vfs_inode->i_generation = inode->generation;
 	if (S_ISDIR(vfs_inode->i_mode))
 		inode->index_cnt = (u64)-1;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index abaa33471456..6ac7fa774ccf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4057,6 +4057,17 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
 	inode->i_otime_sec = btrfs_timespec_sec(leaf, &inode_item->otime);
 	inode->i_otime_nsec = btrfs_timespec_nsec(leaf, &inode_item->otime);
 
+	inode->i_ptime_sec = btrfs_timespec_sec(leaf, &inode_item->ptime);
+	inode->i_ptime_nsec = btrfs_timespec_nsec(leaf, &inode_item->ptime);
+	/* Avoid old garbage on-disk data making btrfs load a bad value */
+	if (unlikely(inode->i_ptime_nsec >= NSEC_PER_SEC)) {
+		btrfs_warn(fs_info,
+			   "invalid ptime.nsec %u on ino %llu from disk, setting ptime to otime",
+			   inode->i_ptime_nsec, btrfs_ino(inode));
+		inode->i_ptime_sec = inode->i_otime_sec;
+		inode->i_ptime_nsec = inode->i_otime_nsec;
+	}
+
 	inode_set_bytes(vfs_inode, btrfs_inode_nbytes(leaf, inode_item));
 	inode->generation = btrfs_inode_generation(leaf, inode_item);
 	inode->last_trans = btrfs_inode_transid(leaf, inode_item);
@@ -4249,6 +4260,9 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
 	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
 
+	btrfs_set_timespec_sec(leaf, &item->ptime, BTRFS_I(inode)->i_ptime_sec);
+	btrfs_set_timespec_nsec(leaf, &item->ptime, BTRFS_I(inode)->i_ptime_nsec);
+
 	btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(inode));
 	btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
 	btrfs_set_inode_sequence(leaf, item, inode_peek_iversion(inode));
@@ -5988,6 +6002,8 @@ static struct btrfs_inode *new_simple_dir(struct inode *dir,
 	inode_set_atime_to_ts(vfs_inode, inode_get_atime(dir));
 	inode->i_otime_sec = ts.tv_sec;
 	inode->i_otime_nsec = ts.tv_nsec;
+	inode->i_ptime_sec = ts.tv_sec;
+	inode->i_ptime_nsec = ts.tv_nsec;
 
 	vfs_inode->i_uid = dir->i_uid;
 	vfs_inode->i_gid = dir->i_gid;
@@ -6714,6 +6730,8 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	ts = simple_inode_init_ts(inode);
 	BTRFS_I(inode)->i_otime_sec = ts.tv_sec;
 	BTRFS_I(inode)->i_otime_nsec = ts.tv_nsec;
+	BTRFS_I(inode)->i_ptime_sec = ts.tv_sec;
+	BTRFS_I(inode)->i_ptime_nsec = ts.tv_nsec;
 
 	/*
 	 * We're going to fill the inode item now, so at this point the inode
@@ -8048,6 +8066,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->i_otime_sec = 0;
 	ei->i_otime_nsec = 0;
 
+	ei->i_ptime_sec = 0;
+	ei->i_ptime_nsec = 0;
+
 	inode = &ei->vfs_inode;
 	btrfs_extent_map_tree_init(&ei->extent_tree);
 
@@ -8186,9 +8207,11 @@ static int btrfs_getattr(const struct mnt_idmap *idmap,
 	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
 
-	stat->result_mask |= STATX_BTIME;
+	stat->result_mask |= (STATX_BTIME | STATX_PTIME);
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
 	stat->btime.tv_nsec = BTRFS_I(inode)->i_otime_nsec;
+	stat->ptime.tv_sec = BTRFS_I(inode)->i_ptime_sec;
+	stat->ptime.tv_nsec = BTRFS_I(inode)->i_ptime_nsec;
 	if (bi_flags & BTRFS_INODE_APPEND)
 		stat->attributes |= STATX_ATTR_APPEND;
 	if (bi_flags & BTRFS_INODE_COMPRESS)
@@ -10779,6 +10802,8 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.get_inode_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
+	.fileattr_get	= btrfs_fileattr_get,
+	.fileattr_set	= btrfs_fileattr_set,
 };
 static const struct inode_operations btrfs_symlink_inode_operations = {
 	.get_link	= page_get_link,
@@ -10787,6 +10812,8 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.permission	= btrfs_permission,
 	.listxattr	= btrfs_listxattr,
 	.update_time	= btrfs_update_time,
+	.fileattr_get	= btrfs_fileattr_get,
+	.fileattr_set	= btrfs_fileattr_set,
 };
 
 const struct dentry_operations btrfs_dentry_operations = {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f3e2afe221be..dfcf710d828c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -275,6 +275,9 @@ int btrfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	const struct btrfs_inode *inode = BTRFS_I(d_inode(dentry));
 
 	fileattr_fill_flags(fa, btrfs_inode_flags_to_fsflags(inode));
+	fa->fsx_ptime.tv_sec = inode->i_ptime_sec;
+	fa->fsx_ptime.tv_nsec = inode->i_ptime_nsec;
+	fa->fsx_xflags |= FS_XFLAG_PTIME;
 	return 0;
 }
 
@@ -294,7 +297,11 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	if (btrfs_root_readonly(root))
 		return -EROFS;
 
-	if (fileattr_has_fsx(fa))
+	/*
+	 * We now support FS_XFLAG_PTIME, so exclude it from the unsupported
+	 * check
+	 */
+	if (fileattr_has_fsx_mask(fa, FS_XFLAG_PTIME))
 		return -EOPNOTSUPP;
 
 	fsflags = btrfs_mask_fsflags_for_type(&inode->vfs_inode, fa->flags);
@@ -436,6 +443,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	}
 
 update_flags:
+	if (!fa->flags_valid && (fa->fsx_xflags & FS_XFLAG_PTIME)) {
+		inode->i_ptime_sec = fa->fsx_ptime.tv_sec;
+		inode->i_ptime_nsec = fa->fsx_ptime.tv_nsec;
+	}
 	inode->flags = inode_flags;
 	btrfs_update_inode_mapping_flags(inode);
 	btrfs_sync_inode_flags_to_i_flags(inode);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 53e726119ca7..ba385d0ed9ed 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -263,6 +263,7 @@ static void print_inode_item(const struct extent_buffer *eb, int i)
 	print_timespec(eb, &ii->ctime, "\t\tctime ", "\n");
 	print_timespec(eb, &ii->mtime, "\t\tmtime ", "\n");
 	print_timespec(eb, &ii->otime, "\t\totime ", "\n");
+	print_timespec(eb, &ii->ptime, "\t\tptime ", "\n");
 }
 
 static void print_dir_item(const struct extent_buffer *eb, int i)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d9dfb63fc5a..72a4a92b40b9 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4631,6 +4631,9 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_timespec_sec(leaf, &item->otime, inode->i_otime_sec);
 	btrfs_set_timespec_nsec(leaf, &item->otime, inode->i_otime_nsec);
 
+	btrfs_set_timespec_sec(leaf, &item->ptime, inode->i_ptime_sec);
+	btrfs_set_timespec_nsec(leaf, &item->ptime, inode->i_ptime_nsec);
+
 	/*
 	 * We do not need to set the nbytes field, in fact during a fast fsync
 	 * its value may not even be correct, since a fast fsync does not wait
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 47ee52859b45..c360b3e95f45 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -900,7 +900,8 @@ struct btrfs_inode_item {
 	 * a little future expansion, for more than this we can
 	 * just grow the inode item and version it
 	 */
-	__le64 reserved[4];
+	__le32 reserved[5];
+	struct btrfs_timespec ptime;
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
 	struct btrfs_timespec mtime;
-- 
2.56.0

