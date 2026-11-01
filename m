Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793498253;
	b=hoPvaDuNQO5F0juXAPgjv0dkc54Sag8/1TOzfRu3AkqonzZKNVHIJdjMwIpjZ6TwXAEv
	 rHMR36WoPn0EvZjbJMDemkzTsIixrJj/JCMsWGYUI1HNAI2FWq/bPm73JeBNywSOLeSIr
	 +2KcIEjU73UJ7ytQ49NO8JatJdft1cKe5sFVf/gImoj0KTIQVGZINJYh2+evMswIwcUmn
	 W4hyhyjR6pLGKECQHKBOwX/bz0Uhn6v0ldddzo/OUM/1/egTzKNzJMz7wR3jSD6Y3tQcI
	 yaX0IzbxVCZuDkB70riytzJ6C8qLAdor+WOScAX+HSp9wZkmTHyCXy6sfdA+cTBqrLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793498253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p8gqfUFSv+Rji6NVZjPl0fEsf893Obde69tyzuNJ1VA=;
	b=LhiOfhWZ+lrtSaTEnpfLdev8Rw1INCvtdu9/B8QxnG+MOmY0DW9RMZWW6c4wdpqjT962
	 dxZOD4RU7/fkRphGAJvIQ1wws9EiQt1VGlWxvF8TqZcNlz8LZ85uP+K8VD75tAB1GoWIe
	 T/UvHPBkhGk0+D/HQy4l1GZ49y28A0WDfEalR2taJO99vWP6umZTLIruxZImt5oQRE2nj
	 g9iwXnofeUITvTi43zwHIWGq2VA+6AMHTDu1tEbaj5AgMBXGeJFkWRPnLTl/aQ0qv/ErB
	 ZET2C6GmkWZBI0KOnGx3WaAl5v/4jXZWDb7Ymx2EyluqXwUhoUpGds9TNG8woHmJxbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FyEr0mg5;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE1E60A3817
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 01:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBE1E60A3817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FyEr0mg5
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so19809295e9.3
        for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 18:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793498251; x=1794103051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p8gqfUFSv+Rji6NVZjPl0fEsf893Obde69tyzuNJ1VA=;
        b=FyEr0mg5qfm+AS19Djqfasj9/qCbMdjarJt1OOKZwZ2DFTLKgN6I7WvSBds+QF4GA+
         HidC8Eq5Nx+K9pCCoQ6iDVlchrI07WQOgx0xyjLjiu00rlWKJORa4NXpgvJ8WPaDxTLG
         eeCaxTUpHF4bKWY1K/tgEzcUUbylAy9SV6Mpbza8P69uZCFf+lJhIRaEOMY1s0cT7OMt
         uyDMFk5RV28BywX9FVaa9WZvGmgVDM0BbHPrDVd7W4Snr3XoDvwD4I5HUa8s0QRg7Nvg
         Ddzgrp54zc+XOnaVrcKafgDR3MZ/5D/LAPBpX1JdlwNWypMoQvdnjnafvMzb5YcE4aEi
         5Y9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793498251; x=1794103051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p8gqfUFSv+Rji6NVZjPl0fEsf893Obde69tyzuNJ1VA=;
        b=dBTM6IcfsFP6ZJVkFtNbh2q6wp74qzW7R4B6nfScvBMZbeLqVnR2NnmMao+Z/MjVKj
         43ssMGxyxZJixY2JqKbSDX//6RnW5w8Rls0y8NxsC9Gn2GVeoaaKhy+MUF+zQhoVFtdu
         Wvlfn1eILb9CYW46JgaPnAiDWls9IL0N8Lz8LJ6oUm9qpdCjHJc9W0iEVXSbq2gZSrK4
         Ehwhhjv3BZaht5moESF6+0rrycTrI0RDpSYa13jMVswDO/kN3CAPp0Aryqf89bsTl9eR
         ENsNDrofRDtZVG4mLpRpOKOa0vUl2Eji3rCsUFC3+LhZRkcdKwSj/QLxKzuVL1yDqrv7
         uVdw==
X-Forwarded-Encrypted: i=1; AKwUvByIEzCGt5mUs93rxiIfCrhWlhoYJlbvRLYGOqwdNOHoVqeph/0kfWjPRTD1geiFPH6Ju7LlwAbOMFg=@vger.kernel.org
X-Gm-Message-State: AFq9FYJriRGzMShDozp2FpqZST5HFXFbFz/lN6E1yGBUuq/17vvKU1g8
	fq09+BdlYrpTKD8Si1aEFJOwJkFrnJeIrsVYHieTQHtkoYb7YLPsqya7
X-Gm-Gg: AYBFou16SLvEfE9byn2f8kDM2NBY6EvUWCxAXas043ft23GvgJIr/fyT3uwiSdFsEWZ
	wEcFluGX5UXv6uj/rdfsELDftgRpERu9xrDZsmWDUTSw8T0RqRM5UZTWwsPl0FEkol7YPtFeJy0
	hcC6zXEY9M7dbLM4MTH7FwtuqGHOVcLi11lca+1Aeh3DH2364rhg/8pkL9BHh/8d0kErFpEI9xL
	P1IiiQiaKqHBfyd0XcQaWxU6/kK/jV87b5jbr57SH/XI0P05xc8WvUJ0wKe6Ywci15mJw8jTL9Z
	EB1iNpF6Y7phldicIS4DlRGZO1++eawOIiWEfUj15MF+w3nzFghi6h65Q76VBWpRNn3fTy1NTyl
	m4lNaSYiRj4WfnyC/UYZa0L56Yj554tbI42hTdF0Gf823M1WuiH2JMBGo0N6+BDdRq/5Sdg7+P1
	e5myjDY9D7iTVrwEs9rKBYu3lPlLATxdFPCJz2ZCUD+aYmONcSvra2bc8KDsa/zj3CBtqMhPPt2
	8Ep5MaSRzUfAeiQyyr6iD3kfngDDCGwoRcXD3/Ik+Z+ZvI6dKlHQPmbY6T2Tw6bKGkG0p256WSd
	uX2AnZXWS+oPv32w9lGXCOF5
X-Received: by 2002:a05:600c:4fd4:b0:4a1:e250:b191 with SMTP id 5b1f17b1804b1-4ac180f2ff3mr144286495e9.17.1793498251133;
        Sat, 31 Oct 2026 18:57:31 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm273532835e9.11.2026.10.31.18.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:57:29 -0700 (PDT)
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
Subject: [RFC PATCH v3 4/5] exfat: make crtime user-settable using ptime
Date: Sun,  1 Nov 2026 02:55:50 +0100
Message-ID: <20261101015551.786044-5-koray.fra@gmail.com>
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

Since exFAT supports user-settable file creation timestamps, map
provenance time (ptime) to exFAT file creation time (crtime) using the
newly introduced ptime API (in commit "vfs: add provenance time
(ptime)").

To do this, implement exfat_fileattr_set(), set .fileattr_set to it for
both file_inode and dir_inode operations and update exfat_fileattr_get()
and exfat_getattr().

The timestamp is now retrievable by using file_getattr() or statx(), and
is settable by using file_setattr() with the FS_XFLAG_PTIME flag.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/exfat/exfat_fs.h |  2 ++
 fs/exfat/file.c     | 36 +++++++++++++++++++++++++++++++++++-
 fs/exfat/namei.c    |  1 +
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index eee573d1697c..aff96afa258a 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -619,6 +619,8 @@ int exfat_getattr(const struct mnt_idmap *idmap, const struct path *path,
 		  unsigned int query_flags);
 struct file_kattr;
 int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
+int exfat_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
+		       struct file_kattr *fa);
 int exfat_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 long exfat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long exfat_compat_ioctl(struct file *filp, unsigned int cmd,
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 1386149916bb..70e226cb4ab7 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -384,15 +384,20 @@ int exfat_getattr(const struct mnt_idmap *idmap, const struct path *path,
 
 	generic_fillattr(idmap, request_mask, inode, stat);
 	exfat_truncate_atime(&stat->atime);
-	stat->result_mask |= STATX_BTIME;
+	stat->result_mask |= (STATX_BTIME | STATX_PTIME);
 	stat->btime.tv_sec = ei->i_crtime.tv_sec;
 	stat->btime.tv_nsec = ei->i_crtime.tv_nsec;
+	stat->ptime.tv_sec = ei->i_crtime.tv_sec;
+	stat->ptime.tv_nsec = ei->i_crtime.tv_nsec;
 	stat->blksize = EXFAT_SB(inode->i_sb)->cluster_size;
 	return 0;
 }
 
 int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
+	struct inode *inode = d_backing_inode(dentry);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+
 	/*
 	 * exFAT compares filenames through an upcase table, so lookup
 	 * is always case-insensitive. Long names are stored in UTF-16
@@ -400,6 +405,11 @@ int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	 */
 	fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	fa->flags |= FS_CASEFOLD_FL;
+
+	fa->fsx_ptime.tv_sec = ei->i_crtime.tv_sec;
+	fa->fsx_ptime.tv_nsec = ei->i_crtime.tv_nsec;
+	fa->fsx_xflags |= FS_XFLAG_PTIME;
+
 	return 0;
 }
 
@@ -485,6 +495,29 @@ int exfat_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	return error;
 }
 
+int exfat_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
+		      struct file_kattr *fa)
+{
+	struct inode *inode = d_backing_inode(dentry);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+
+	if (fileattr_has_fsx_mask(fa, FS_XFLAG_PTIME))
+		return -EOPNOTSUPP;
+
+	if (fa->flags & ~FS_CASEFOLD_FL)
+		return -EOPNOTSUPP;
+
+	if (fa->fsx_xflags & FS_XFLAG_PTIME) {
+		ei->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
+		ei->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
+	}
+
+	inode_set_ctime_current(inode);
+	mark_inode_dirty(inode);
+
+	return 0;
+}
+
 /*
  * modified ioctls from fat/file.c by Welmer Almesberger
  */
@@ -1110,4 +1143,5 @@ const struct inode_operations exfat_file_inode_operations = {
 	.setattr	= exfat_setattr,
 	.getattr	= exfat_getattr,
 	.fileattr_get	= exfat_fileattr_get,
+	.fileattr_set	= exfat_fileattr_set,
 };
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 68ddb9c5504f..15ec7f1942c8 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1349,4 +1349,5 @@ const struct inode_operations exfat_dir_inode_operations = {
 	.setattr	= exfat_setattr,
 	.getattr	= exfat_getattr,
 	.fileattr_get	= exfat_fileattr_get,
+	.fileattr_set	= exfat_fileattr_set,
 };
-- 
2.56.0

