Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306161;
	b=onlwCm7kHPnMS1bvl/x+wHIMUoSqUocUckpX9Ntc2LzJxvBNCjYrAYnIf44bQLRU8rYL
	 R0S3Sjfo0o8bipbQbbmiu/pZi9yFcoHjPWmBuQh4gqvZ7yKLhmekcuiNP1vO+hxEatL39
	 e9zPAW4fLUv7wx5BxobHb7AAxzF+tdx3YYwBDVBRJ8dtuIEU5ejqARumMrbmgSVc848zE
	 NsbopZJyuGiYD2tbZIqxx/1bxMXwecH89wI7httguxQ/hpPANDtcnwjc9gaQjVK6ZyFN4
	 zeD1oogsz8pemFx8c5wIK3IxwyJ5pq2K4OSoWh0c0HXi5SE3FEC3QdSIYdamLn3pjxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306161;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4xZytGWv8+w9GAco63iTykOZG4XUcvcZgoLypgA0ThI=;
	b=GQsFoFQh+f+93vr+E0/MFyDZ9nLW5rXkEZM0uvBYz+eRiDfMbYdZtd5HocmMOGqrs47v
	 21VTJIljbw4Ahs3sdRiU3kfKr74S/Rw778HABylOv3Oa9aiUNylF4hEc1/Oh5+sAdjt0A
	 E56F5ckknTwV7mOnjETQd33Cq/CynL7XjFhr0EjozqLy/VmMo5xzt1No5jqEBq7vlwKKc
	 OxZ31wPfQD5KXdI0oi2+5h9bz0iRlO2Cz28NEicNXBtFaZKTntJdaE+C/cuN3qqt4PGOp
	 ve4rLkf4tYh9btIsUWS57Lt2Zzq8/pu55Vy2BxwTYGaMtj5dDzOv6hYWqOcxPYqCd4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AdgEZnCD;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A06606A68C
	for <linux-api@vger.kernel.org>; Sun, 22 Nov 2026 00:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15A06606A68C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AdgEZnCD
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso20255015e9.3
        for <linux-api@vger.kernel.org>; Sat, 21 Nov 2026 16:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795306159; x=1795910959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4xZytGWv8+w9GAco63iTykOZG4XUcvcZgoLypgA0ThI=;
        b=AdgEZnCDRq3OA0dGqO0rG+3FNmDWcKc9OiYKdCb+BC4wRCIERy/XVNqE1HQRURlfWW
         6++IpNbbLaanVXSE8qHXRXM7YFV2oogVAsIfMXtAKT5Kp/baA4Q+e9ObD3oSg3GSLaIc
         7uUXZQEfksKoDCYMnbSUOU2Bc7N8EvbIuIafw0xZFpfWAGqG+XEshXHv+bTvelS5Jn73
         yoQISUCLkMC7nbi3tuqortv6L5uJQuSrod6nfemPgOwy8xMpxp8NmzM+Vic7LDYP8tzL
         U6yOTYV8nqC5iN0OWt1OCeEPuqBcmDcHoYFIVAivmMCy8//NpPo2tEutcaNOzYrzIT5n
         LYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306159; x=1795910959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4xZytGWv8+w9GAco63iTykOZG4XUcvcZgoLypgA0ThI=;
        b=GUk+Vntm3r7KUeNs0IdFG9qYYuuVWBro0yxP0DX+2ncjy77ZHivosNdl90dFUxxMC+
         zg6kYZjoxY/jwxP2Be2z0NY7SLMHMCZoyA2nF0Lv42qFwfnOjwPg1vPDe0GTGhM3XQbq
         5TKnlFRYae080prb6IKnyD7BottyW9cegcu3Xgzsp9zR8OzBbmzSptOkIkOfoaWnc/dt
         mVDSaarruBfmw+PhWA8AlknRWx3ZMb/1DBwDfxw7FKAnuyYekAyNAP7NCZvYrqwX6bF6
         v5X+w/FQd2CAmYeD62UwA6l44xBmK0kaoqLuJAfKJsod7d970gO6CXan6rBEYaxZnulv
         ToIQ==
X-Forwarded-Encrypted: i=1; AL+hErHwnd2zMCyFnbaC/cIE621vcZewFDrurSb4u+pMRkyV4J7XHmcnxanRJFjjX2kGBegiocoXUEc5bCk=@vger.kernel.org
X-Gm-Message-State: APuU4Z815D5ozEQUpVRnGL0J2++qPrXGh1m7qMdDrmGV7vVriqwoKhTL
	SbuYZYCEJKd3YueYeLjLIOFFilV8DVeyxOZ1SPsR8RTbeeHK52Ji0pj7
X-Gm-Gg: AZFdTZdMRJAk7daLM3LIC9PvMK850BpQG5uTWM9T9JMkEaBrs5L7eou4LVrnIH7ilzF
	prd7qum+nfrvDUwMxq5dTKOo+l7lT8LAw8AHue3eCJNIfWTl1UfuE53c9UZtwvnQ8w9g0tQFqfX
	rGRL6azLAiCMUsxTckF9gl8sDfFgsabzdLNN16paob0LzIQbMYIxzZomkMkG9SLvqZJ2imy55Ef
	nFoh53wmzKWzKZ2OicIPzsVEPr4RemeSHiqtUmZb+m4jbvq4Ou4Dpz3FdYRUge9BxyVec33DOiP
	SBFQ8r/ktszyj17Z6p+bofncSEkU08lupWxzEWX6D1hV0sO/s/P2bcHlSQ78cSvcHMvMRe7n7al
	8WAWiY5QoPbFbkOmKK8RMGjDydpvIp/CO54qRTGCKi2D3P3rhn1m+n9Z9KVB2AW/Y6mEpS6uV6j
	ZUnKLP7iPy35P0EUVE9bketADao6jFGEKlWF7/nCDz3F10lPNOuQNhmnpYyv5u2KWGOqxKTX2Ve
	4b8Q/cYPTKjDz1BUFQf0ftX5+GPOjwPFcKQtBHaY/wkV9GrQLR4DSc5IuPsWc6mvOtBeT788+Vp
	5G0zTd5o/z6pA14f9wXHwxyX
X-Received: by 2002:a05:600c:8210:b0:4a2:1a:a116 with SMTP id 5b1f17b1804b1-4bb887865b5mr159815355e9.0.1795306159378;
        Sat, 21 Nov 2026 16:09:19 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm13461872f8f.0.2026.11.21.16.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:18 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
Date: Sun, 22 Nov 2026 01:08:56 +0100
Message-ID: <20261122000856.536902-4-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261122000856.536902-1-koray.fra@gmail.com>
References: <20261122000856.536902-1-koray.fra@gmail.com>
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

Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
modern xflags (FS_XFLAG_*) fileattr API with masks.

Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
to be used in this API switch.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c           |  8 +++++
 fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
 include/linux/fileattr.h |  6 ++--
 include/uapi/linux/fs.h  |  2 ++
 4 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 0e16c23368b2..815b8ba50e1f 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -39,6 +39,10 @@ void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags)
 		fa->flags |= FS_VERITY_FL;
 	if (fa->fsx_xflags & FS_XFLAG_CASEFOLD)
 		fa->flags |= FS_CASEFOLD_FL;
+	if (fa->fsx_xflags & FS_XFLAG_COMPR)
+		fa->flags |= FS_COMPR_FL;
+	if (fa->fsx_xflags & FS_XFLAG_ENCRYPT)
+		fa->flags |= FS_ENCRYPT_FL;
 }
 EXPORT_SYMBOL(fileattr_fill_xflags);
 
@@ -71,6 +75,10 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
 		fa->fsx_xflags |= FS_XFLAG_VERITY;
 	if (fa->flags & FS_CASEFOLD_FL)
 		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
+	if (fa->flags & FS_COMPR_FL)
+		fa->fsx_xflags |= FS_XFLAG_COMPR;
+	if (fa->flags & FS_ENCRYPT_FL)
+		fa->fsx_xflags |= FS_XFLAG_ENCRYPT;
 }
 EXPORT_SYMBOL(fileattr_fill_flags);
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 50be49f4c913..fde6fb2fe39c 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct file *filp)
  * @dentry: dentry to report the flags of
  * @fa: filled in with the flags of @dentry
  */
+#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_CASEFOLD)
+#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
+			FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)
 int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
 	struct inode *vi = d_inode(dentry);
 	struct ntfs_inode *ni = NTFS_I(vi);
-	u32 flags = 0;
+	u32 xflags = 0;
 
 	if (NVolShutdown(ni->vol))
 		return -EIO;
 
 	if (NInoCompressed(ni) || NInoWofCompressed(ni))
-		flags |= FS_COMPR_FL;
+		xflags |= FS_XFLAG_COMPR;
 	if (NInoEncrypted(ni))
-		flags |= FS_ENCRYPT_FL;
+		xflags |= FS_XFLAG_ENCRYPT;
 	if (vi->i_flags & S_IMMUTABLE)
-		flags |= FS_IMMUTABLE_FL;
+		xflags |= FS_XFLAG_IMMUTABLE;
 	if (vi->i_flags & S_APPEND)
-		flags |= FS_APPEND_FL;
+		xflags |= FS_XFLAG_APPEND;
 	if (vi->i_flags & S_NOATIME)
-		flags |= FS_NOATIME_FL;
+		xflags |= FS_XFLAG_NOATIME;
 	if (ni->linuxflags & NTFS_LINUXFLAGS_NODUMP)
-		flags |= FS_NODUMP_FL;
+		xflags |= FS_XFLAG_NODUMP;
 	if (!NVolCaseSensitive(ni->vol))
-		flags |= FS_CASEFOLD_FL;
+		xflags |= FS_XFLAG_CASEFOLD;
 
-	fileattr_fill_flags(fa, flags);
+	fileattr_fill_xflags(fa, xflags);
+	fa->fsx_xflags_ro_mask = NTFS_RO_XFLAGS;
+	fa->fsx_xflags_rw_mask = NTFS_RW_XFLAGS;
+	fa->has_masks = true;
 	return 0;
 }
 
@@ -207,9 +213,6 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 {
 	struct inode *vi = d_inode(dentry);
 	struct ntfs_inode *ni = NTFS_I(vi);
-	u32 allowed = FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL |
-		      FS_NOATIME_FL;
-	u32 readonly = 0;
 	u32 linuxflags = ni->linuxflags & ~NTFS_LINUXFLAGS_MASK;
 	unsigned int new_fl = 0;
 	bool forced_immutable;
@@ -219,42 +222,36 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (err)
 		return err;
 
-	if (fileattr_has_fsx(fa))
-		return -EOPNOTSUPP;
-
-	/* chattr passes the unchanged read-only flags back to us too. */
-	if (NInoCompressed(ni) || NInoWofCompressed(ni))
-		readonly |= FS_COMPR_FL;
-	if (NInoEncrypted(ni))
-		readonly |= FS_ENCRYPT_FL;
-	if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
-		return -EOPNOTSUPP;
-	allowed |= readonly;
-
-	/* Case folding is a read-only, mount-wide property. */
-	if (!NVolCaseSensitive(ni->vol))
-		allowed |= FS_CASEFOLD_FL;
-	if (fa->flags & ~allowed)
+	/*
+	 * When userspace uses file_[gs]etattr(), VFS already checks and fails
+	 * with -EOPNOTSUPP if rw_mask & ro_mask != 0 and rw_mask & ~allowed,
+	 * but for FS_IOC_SETFLAGS and FS_IOC_FSSETXATTR VFS can't check for
+	 * allowed flags as these ioctls don't support fsx_xflags_{rw,ro}_mask,
+	 * so we need to check for unsupported flags anyway.
+	 */
+	if (!fa->has_masks &&
+	    ((fa->fsx_xflags & ~NTFS_RW_XFLAGS) ||
+	     fa->fsx_extsize || fa->fsx_projid || fa->fsx_cowextsize))
 		return -EOPNOTSUPP;
 
 	forced_immutable = ntfs_is_forced_immutable(vi);
-	if (!(fa->flags & FS_IMMUTABLE_FL) && forced_immutable)
+	if (!(fa->fsx_xflags & FS_XFLAG_IMMUTABLE) && forced_immutable)
 		return -EPERM;
 
-	if (fa->flags & FS_IMMUTABLE_FL) {
+	if (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) {
 		new_fl |= S_IMMUTABLE;
 		/* Do not persist an immutable bit derived from the mount. */
 		if (!forced_immutable ||
 		    (ni->linuxflags & NTFS_LINUXFLAGS_IMMUTABLE))
 			linuxflags |= NTFS_LINUXFLAGS_IMMUTABLE;
 	}
-	if (fa->flags & FS_APPEND_FL) {
+	if (fa->fsx_xflags & FS_XFLAG_APPEND) {
 		new_fl |= S_APPEND;
 		linuxflags |= NTFS_LINUXFLAGS_APPEND;
 	}
-	if (fa->flags & FS_NODUMP_FL)
+	if (fa->fsx_xflags & FS_XFLAG_NODUMP)
 		linuxflags |= NTFS_LINUXFLAGS_NODUMP;
-	if (fa->flags & FS_NOATIME_FL) {
+	if (fa->fsx_xflags & FS_XFLAG_NOATIME) {
 		new_fl |= S_NOATIME;
 		linuxflags |= NTFS_LINUXFLAGS_NOATIME;
 	}
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 4faa40febf11..219e7c8eb601 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -7,12 +7,14 @@
 #define FS_COMMON_FL \
 	(FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
 	 FS_NODUMP_FL |	FS_NOATIME_FL | FS_DAX_FL | \
-	 FS_PROJINHERIT_FL | FS_VERITY_FL)
+	 FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
+	 FS_ENCRYPT_FL)
 
 #define FS_XFLAG_COMMON \
 	(FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
 	 FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
-	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
+	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
+	 FS_XFLAG_ENCRYPT)
 
 /* Read-only inode flags */
 #define FS_XFLAG_RDONLY_MASK \
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index e40806b3a69c..09fc7e066485 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -275,6 +275,8 @@ struct file_attr {
 #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
 
 #define FS_XFLAG_PROJID		0x00100000	/* project ID */
+#define FS_XFLAG_COMPR		0x00200000	/* Compress file */
+#define FS_XFLAG_ENCRYPT	0x00400000	/* Encrypted file */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.56.0

