Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765864;
	b=gf9c0L54J6nbZcZjbkLxlaB7BKY9twbCC9eNiVUY6ImtbJDdoq5LWO4WsERF6rYz3ZnR
	 z3dT1MkzyAqHwoz5iNSON1PLqYmWArQoR2gHDgPiTmIyKxPH1RZz2+cHAAuiZRhAzsmHy
	 9DG36/CROGlVY1xd/JNsiVhFXWLDEWeiGM20rWyTQIu+kT/Un8Lm3o+csTRHX53ZaRg/7
	 zZcrPnviJaGJXhX5sZ05/MeN693MLc654/WuH42rVQmD/wAu+XoURL6MY8JpBZwSM4MJs
	 x3Z7nVJhb9Ih79kAu39oQRMaXVTLbEK0wTh70zkspxbVmVYbZfLzTgXKgnSRA5JOoaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lxukKPljbLBMj2KQ1RVi2fh6LR+mPswpZnw+yWTHXAg=;
	b=l1acfKS1sNgMRRgr3QPyTovK3+/JRFXjaz6X4d46ztAbdj7SOd/jLogF3YViZkKIIH3O
	 otRvDqKrOXVeaRI7OrLtH/SfwU6gAfuVhE9plgDWCNIEQc3oHEjJjxvESMvb4YDvfN+Dq
	 NYLYqxUhyfH02to0HwB1dr6J56lSrwB4DlSz+t8xXfnSrHXvdPZR26xBjEYsTeOYrxt4x
	 ESt1TT3HYmRzOPExPJv3AR3IPfJvP7wDjixDIrrFqSewbJ1wJ81dQ6eso5xMSaUUI5tya
	 dGJIx+G5wO4x0kuNjTbEAJmpdotbIgfm6+YkihnVnXBIWAcIMMpp0bQaN77wzVAf51Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DOC6fRFx;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E022606A899
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 18:04:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E022606A899
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DOC6fRFx
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-492690dd5daso2667304f8f.1
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 10:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794765861; x=1795370661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lxukKPljbLBMj2KQ1RVi2fh6LR+mPswpZnw+yWTHXAg=;
        b=DOC6fRFxtVO3+ChQZzvIui929ReJBuZRd50VNbS4+FpLPzHiYUk0WUdqprK6YJ0H9P
         stgxUdPJV/firlryJZiPgcjbYfkVubXUmYUllYeWbRbQj0/cU5mkXT5om3kdyMQmazN9
         rSzbjQkUbitjYgmgKsWufTocTnMfvmkDAI3Oxgjdc/MAagWI/qQz5Ra6UjVwmcaHZeVm
         RH2isjXoghK2pAMewo3C0p+jKCU0hHuAnA5pmR6eYCj9i2rADSzBqE9st7UzJZGd+ArT
         tNWRMhr+eF01OpI7T/wIq6nvVSPeZcy8RRet4KfN8DcM1geWKJD9t7OMvDUoWoupSPqc
         /XLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794765861; x=1795370661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lxukKPljbLBMj2KQ1RVi2fh6LR+mPswpZnw+yWTHXAg=;
        b=VmNoLPlMyC7N1BVbbPGI3LbERcAwDlX36BXsMymRnjVky56a5+JdHfaqpFrAHy3LGP
         9Iw3j5NNN4Pp8FlYMMr44Y34o/TKGIdtXYXfryV7oDwFnxOvsNaNlIWYbJwJxVTsF+uc
         1eZ1xrA552ebmImZ8Uk5Clpi58uoOIpGShiMgHE2wZdVlJB4mYheoehNmHVHLWJ3es51
         UQ8MNY9lC5g36dQ5KFY1TThctDTTnxAyGvDSlPPIg7QzksxwKh/dcoxHHQadKtJaNEpQ
         d9HOmv6sgmYJYgoBPIKZqiTje15F4cNHW33O5cbR6Otl6SHo67gEqU4fwhGLFEQ0iNwH
         uXGw==
X-Forwarded-Encrypted: i=1; AL+hErHxayyCnLzj+aPEMvhYc3a0M/S/QiUq0e0sDOQmEMcw9z4YtDZSqquj7AtIlU/rmuA1aVmT3Fnwzss=@vger.kernel.org
X-Gm-Message-State: APuU4Z9eMxen1imqzjSI+j34oJPmvYiURhhnwMmaD7QPi0r4vcT3LZd2
	/C10M+1Iyhzfaf/H2tW+pQp/p6KTRwjxx4S+gC019KuFrqR3tqOdvDV7
X-Gm-Gg: AYBFou1gZ7e+5N8Q0AZg7Vg3H5/wGGX6k0nUYCYDZd3chi43ArzddshhDsX7gh8+1MV
	EHvARTK3PaGTI8+G3guQbiepIbQVTqVX1BLhdRDIcZavB2nwArVEWCNbL4c9KkHYdhJoY8eMxgM
	cMqGTM6TB2+GTGXEAxBQyZ7t2PwcptNw7V4L4G52H6hRUcArEQwRZjK2hS9uxTOcGJ32NF7/wXt
	Rz0kHULIWRgAyQZCf+A3YpEGtXUs/7/jJYpUF8+8nALNAxbd6CxzN68kvGWPFU7zf+4Q95VKZXX
	ygLADgH76D8/SXw7DDI9pdYEvF24lg0GVdHmmQqzSYKOJ+tkFAQTki4VSo5D69iU2zwXF2pUsmG
	Yv8Dr6zREfPh1uwx0LOqQgcLZZkTJkedRwUzjl1SvTobsWXALaYmzloxInIyq6b+ludVKmMioGV
	AHqgqaAd+baRU4Nid0jU/QCxM7o0mMF4SasAU9oHXUjTl6RdYW6h1E4mjYWIsIHDA9fJlAP4p29
	Txpi7200TFVrIiTL1cE7LRALSC+PkyyrHCK0nzkzThn2XVRAh5JlwV1mH6v2FWgtf25DKVK8KDF
	1gxcJUDqFXIFubxOyQNDAEpM/UBGHiE2VRLuaQDnIywMaw==
X-Received: by 2002:a05:6000:461b:b0:48d:f7c0:97c0 with SMTP id ffacd0b85a97d-49c71b5c656mr18500790f8f.50.1794765861443;
        Sun, 15 Nov 2026 10:04:21 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm17980448f8f.58.2026.11.15.10.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 10:04:20 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Chris Mason <mason@kernel.org>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v4 10/10] cifs: add provenance time (ptime) and map it to SMB's CreationTime
Date: Sun, 15 Nov 2026 19:03:43 +0100
Message-ID: <20261115180343.576773-11-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115180343.576773-1-koray.fra@gmail.com>
References: <20261115180343.576773-1-koray.fra@gmail.com>
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

Implement provenance time (ptime) in cifs, as introduced in a
previous commit ("vfs: add provenance time (ptime)").

Map it to SMB's CreationTime, making it settable from userspace and
propagating it to the SMB server via FILE_BASIC_INFO.

Support reading ptime via statx(2) and fileattr_get() from the cached
CreationTime.

Update cifs_fileattr_set() to check xflags instead of only legacy flags
and add the cifs_set_file_crtime() helper to wrap the RPC call to the
SMB server.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/smb/client/cifsfs.c |   8 +++
 fs/smb/client/inode.c  |   7 ++-
 fs/smb/client/ioctl.c  | 109 ++++++++++++++++++++++++++++++-----------
 3 files changed, 94 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 8cff7857b450..c2f557e406d3 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1307,6 +1307,14 @@ int cifs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	if (READ_ONCE(CIFS_I(inode)->cifsAttrs) & ATTR_COMPRESSED)
 		fa->flags |= FS_COMPR_FL;
 
+	/* Report provenance time (ptime) to userspace */
+	if (CIFS_I(inode)->createtime) {
+		fa->fsx_xflags |= FS_XFLAG_PTIME;
+		fa->fsx_xflags_mask |= FS_XFLAG_PTIME;
+		fa->fsx_ptime =
+		      cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->createtime));
+	}
+
 	/*
 	 * FS_CASEFOLD_FL is defined by UAPI as a folder attribute,
 	 * and userspace tools (e.g., lsattr) display it only on
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 2647785ec1e4..f0b20a72b9c2 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -222,6 +222,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
 	cifs_i->reparse_tag = fattr->cf_cifstag;
+	cifs_i->createtime = fattr->cf_createtime;
 
 	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
 		cifs_i->time = 0;
@@ -2958,7 +2959,8 @@ int cifs_getattr(const struct mnt_idmap *idmap, const struct path *path,
 	 * We need to be sure that all dirty pages are written and the server
 	 * has actual ctime, mtime and file length.
 	 */
-	if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | STATX_BLOCKS)) &&
+	if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_PTIME
+			     | STATX_SIZE | STATX_BLOCKS)) &&
 	    !CIFS_CACHE_READ(CIFS_I(inode)) &&
 	    inode->i_mapping && inode->i_mapping->nrpages != 0) {
 		rc = filemap_fdatawait(inode->i_mapping);
@@ -2992,6 +2994,9 @@ int cifs_getattr(const struct mnt_idmap *idmap, const struct path *path,
 		stat->result_mask |= STATX_BTIME;
 		stat->btime =
 		      cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->createtime));
+		stat->result_mask |= STATX_PTIME;
+		stat->ptime =
+		      cifs_NTtimeToUnix(cpu_to_le64(CIFS_I(inode)->createtime));
 	}
 
 	stat->attributes_mask |= (STATX_ATTR_COMPRESSED | STATX_ATTR_ENCRYPTED);
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index bb8808289a46..19a9556d39b4 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -181,6 +181,41 @@ static int cifs_set_compression(unsigned int xid, struct dentry *dentry,
 					    compression_state);
 }
 
+static int cifs_set_file_crtime(unsigned int xid, struct dentry *dentry,
+				struct cifs_tcon *tcon, u64 crtime)
+{
+	struct inode *inode = d_inode(dentry);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	FILE_BASIC_INFO	info_buf = {};
+	const char *full_path;
+	void *page;
+	int rc;
+
+	if (!server->ops->set_file_info)
+		return -EOPNOTSUPP;
+
+	info_buf.CreationTime = cpu_to_le64(crtime);
+
+	page = alloc_dentry_path();
+	full_path = build_path_from_dentry(dentry, page);
+	if (IS_ERR(full_path)) {
+		rc = PTR_ERR(full_path);
+		goto out;
+	}
+
+	rc = server->ops->set_file_info(inode, full_path, &info_buf, xid);
+	if (rc == 0) {
+		CIFS_I(inode)->createtime = crtime;
+		CIFS_I(inode)->time = 0;
+		inode_set_ctime_current(inode);
+	}
+
+out:
+	free_dentry_path(page);
+	return rc;
+}
+
+#define CIFS_SUPPORTED_XFLAGS (FS_XFLAG_PTIME)
 int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 		      struct file_kattr *fa)
 {
@@ -193,49 +228,65 @@ int cifs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	bool enable_compression;
 	struct cifs_tcon *tcon;
 	unsigned int xid;
-	int rc;
+	int rc = 0;
 
-	if (!fa->flags_valid)
+	if (fileattr_has_fsx_mask(fa, CIFS_SUPPORTED_XFLAGS))
 		return -EOPNOTSUPP;
 
-	/*
-	 * chattr writes back all flags returned by fileattr_get(). Accept
-	 * FS_CASEFOLD_FL only when it reflects the share's casefold state.
-	 */
-	if (fa->flags & FS_CASEFOLD_FL) {
-		rc = cifs_fileattr_get(dentry, &current_fa);
-		if (rc)
-			return rc;
-		if (current_fa.flags & FS_CASEFOLD_FL)
-			allowed |= FS_CASEFOLD_FL;
-	}
-	if (fa->flags & ~allowed)
+	if (fa->fsx_xflags_mask & ~CIFS_SUPPORTED_XFLAGS)
 		return -EOPNOTSUPP;
 
-	enable_compression = fa->flags & FS_COMPR_FL;
-	compression_state = enable_compression ? COMPRESSION_FORMAT_DEFAULT :
-						 COMPRESSION_FORMAT_NONE;
+	if (fa->flags_valid) {
+		/*
+		 * chattr writes back all flags returned by fileattr_get(). Accept
+		 * FS_CASEFOLD_FL only when it reflects the share's casefold state.
+		 */
+		if (fa->flags & FS_CASEFOLD_FL) {
+			rc = cifs_fileattr_get(dentry, &current_fa);
+			if (rc)
+				return rc;
+			if (current_fa.flags & FS_CASEFOLD_FL)
+				allowed |= FS_CASEFOLD_FL;
+		}
+		if (fa->flags & ~allowed)
+			return -EOPNOTSUPP;
+	}
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
-
 	xid = get_xid();
-	rc = cifs_set_compression(xid, dentry, tcon, NULL, compression_state);
-	free_xid(xid);
-	cifs_put_tlink(tlink);
 
-	if (!rc) {
-		spin_lock(&inode->i_lock);
-		if (enable_compression)
-			CIFS_I(inode)->cifsAttrs |= FILE_ATTRIBUTE_COMPRESSED;
-		else
-			CIFS_I(inode)->cifsAttrs &= ~FILE_ATTRIBUTE_COMPRESSED;
-		spin_unlock(&inode->i_lock);
+	/* modern xflags */
+	if (fa->fsx_valid) {
+		if (fa->fsx_xflags_mask & FS_XFLAG_PTIME) {
+			rc = cifs_set_file_crtime(xid, dentry, tcon,
+						  cifs_UnixTimeToNT(fa->fsx_ptime));
+			if (rc)
+				goto out;
+		}
+	} else if (fa->flags_valid) { /* legacy flags */
+		enable_compression = fa->flags & FS_COMPR_FL;
+		compression_state = enable_compression ? COMPRESSION_FORMAT_DEFAULT :
+							 COMPRESSION_FORMAT_NONE;
+
+		rc = cifs_set_compression(xid, dentry, tcon, NULL, compression_state);
+
+		if (!rc) {
+			spin_lock(&inode->i_lock);
+			if (enable_compression)
+				CIFS_I(inode)->cifsAttrs |= FILE_ATTRIBUTE_COMPRESSED;
+			else
+				CIFS_I(inode)->cifsAttrs &= ~FILE_ATTRIBUTE_COMPRESSED;
+			spin_unlock(&inode->i_lock);
+		}
+		cifs_dbg(FYI, "set compress flag rc %d\n", rc);
 	}
 
-	cifs_dbg(FYI, "set compress flag rc %d\n", rc);
+out:
+	free_xid(xid);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
-- 
2.56.0

