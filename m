Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765850;
	b=HCf777+LjRJOhF1aGUJdNfQUahA56W/aRbh4z4EUkzMXQhc3qRWl7Vwd2GF4qCL10QQ/
	 SES38xTQYbNepIRc7KrV4xesJkm+2z6Hwm4BIH/OQ/BlQX59GCwoNcVmbIR+hJZdXgP3a
	 mGumjXpiMsIgBsAloRplnaJSAn2RNfORA1lGjey/j3CR4GwcErR+2C4EtDqgXoFh6900P
	 Hl5HKQ8l1iaXsYmZM9Op40wi331pxWHgbZJz2m5zwmZluBrpCYlL4lAwjYaLdEaiw3AUt
	 jAzX/Hx0sUQQ8YW6sLlnXJHy9/hoSyh7AIg7XhPSzPA6bTjcAV2sbUjXKOWXKXvUQPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765850;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UA38+n7c+RqbQlIN4Q8phpqWE0RWPQHALE9HzRQmyvE=;
	b=lb9KG/xjWRKTL3F/EwDENN/QYc9L+NHVtHbQMjg/DGPzgurPo1Eq/n9U1P/MDibJ6hB/
	 gbMhVwI3gEVMwy+Zs5uZflkHkVip3a4kXczJalrXHP93V2ttAiEa3u9i9d9Xv6IuadZ4q
	 HaYXB0XtSnabqBP9sztgCKjri0n/MwPyU2mwnDkY3qY3QQxGey+SLDT2BidBFDcjdB9ta
	 RN5UEN1h444r237nSf3dA2WibkShdKothZcpQA4AY1zNXWJ3EuE5rUr8TSecKFhZU+ZCZ
	 SSgM4WkTISa8iVI/zpdQBSRluPGNqfrALL1A9EpA1QPxSiIO9FUti2DTU8Jss0VvISA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vWsT5qNH;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB0760A263F
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 18:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFB0760A263F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vWsT5qNH
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so1332820f8f.3
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 10:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794765848; x=1795370648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UA38+n7c+RqbQlIN4Q8phpqWE0RWPQHALE9HzRQmyvE=;
        b=vWsT5qNHBHS1DVwii+PWCaUBbHAppQCmj2gOj682zzeHiV/k+DiOVZTV4Zl2ufwliV
         XcMy5JwYQTOOTrflDWHklMKFP0ooIAzTXmcrljZcbXEBcGgQJ8AuhPrA2Kdo4FY+A5sq
         RFhUdhdmB/HnkpDHfaoEqGopcQTyaUw/BkwbFNx/miBcx95zanVxTEo04YAIEeC/HESP
         VTbUAbTYu4JhjZfi4+Q1P2yCrswvDMacYAFanAg5eyigD2bOBBTTJke+hK+xYQgFlnL9
         BoGEzGfJ3RScREWw+h4ers02dYcW83csAclxW+91LVfFDsMDpf8UySKYC2UjgIBdPzYJ
         P8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794765848; x=1795370648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UA38+n7c+RqbQlIN4Q8phpqWE0RWPQHALE9HzRQmyvE=;
        b=oyivYKx3Abb9Atqr8PpZyQpsqOTuyoMAWoA7W00C3XcLK5gI9r6AGlsWsRcPCdhCIL
         ZdsKegmDO3fhFT8LMuiHwLl71Np/O6fb9oT1CQ9UfbanIRu7Lg1CusP5R/S7rpTJsAJU
         A/AM8KJ50+JhPDiashbf325CVljxAVU/s7c0G+2ZmcE3IuuJLTRugfmmZl/sf4jpkRxH
         XYbRqykXST5oGplOEnxiMBYMuAWyqV5Wh4iwWHF1ynqYa9Z5spaygesQDjKv7wCDdjw1
         q7lqXY29VrVTY9BJpX8Ucy50FYa1OkGv+8ksU2TJtbY02GJlPqdy8cfKOckXuRJVwwcb
         CArA==
X-Forwarded-Encrypted: i=1; AL+hErE8KD4V6gTbI2v5XUokOV/9aTGUUnflnDjK88KKthOLHM9zX3Xd5Rqsr5cNZ6dkQqfJ9cQjRXdX4bM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8DqBJoeOzvnZVL9kfTswmNYJpC7N2W2NM4aT5XtUwudMqoZf0E
	WXImn4IPkUulKPcjFXMIPbv00I2vV3Vv8kyAFqCVqAfdhWnaG4R2Nu6g
X-Gm-Gg: AYBFou1buNS5xPE+77vT3pEMERgGtAmeKqXISPjEWizu/M+ENL11G0FDefD4X9QkNjn
	sHIwYkgG7g/WPcBnA8dXXh6skv3AE6GLfI65uOBXhvZbn5g6ITFoCit22JmVadrCCHESuH9iTFU
	WObJSIf7GQIVIyEWpLw5CyAIi8aNqx7Em33EZySYjx5AsJ6fTQvSId+7cSP4mdd7XmgCcAEAYfA
	9blKQq2PB2eifScqo03DG4ViM5qP0wCfVAULXmlfjQ1F12bEIVpi5ExkICtYGoE9cRgJz5AdwD6
	PcVDSsySRcUUZWLf87R2GYXHkK3fR1rkMTnnzIUK6TwcXY3eNLRi5qgJuGMyHmjnEZT5inZkw8l
	0rAj5ETGGpFD28QvHUblp7VKrqvtaf84rPxm3I/Lm05IFRAOGBHnwk/VScIH0Gn5RLY+3OyvXXt
	FrXcl8VMBMZtQ1cAJZ3o7AiXgA1Bo8GUS1LO+W6+15Hi8cFs4PQbrwWI/6PzKB3kY1M3oIAT5oN
	K5l7hSMQoXeiaRvWIxermGUlGMAnbD2j/cIl7a2SGfgLay89uElFnpjjp7obo239Mn0bT19LZZL
	e+jXLmNyB3gD3GIfB3AqPqMK97hMOgvODJZmOo7jERyxsg==
X-Received: by 2002:a05:6000:455c:b0:48f:bcf0:2026 with SMTP id ffacd0b85a97d-49c73259e6bmr12985016f8f.13.1794765848134;
        Sun, 15 Nov 2026 10:04:08 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm17980448f8f.58.2026.11.15.10.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 10:04:07 -0800 (PST)
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
Subject: [RFC PATCH v4 04/10] exfat: make crtime user-settable using ptime
Date: Sun, 15 Nov 2026 19:03:37 +0100
Message-ID: <20261115180343.576773-5-koray.fra@gmail.com>
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
 fs/exfat/file.c     | 42 +++++++++++++++++++++++++++++++++++++++++-
 fs/exfat/namei.c    |  1 +
 3 files changed, 44 insertions(+), 1 deletion(-)

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
index 435bbef288b8..02390b03eecd 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -384,15 +384,22 @@ int exfat_getattr(const struct mnt_idmap *idmap, const struct path *path,
 
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
 
+#define EXFAT_SUPPORTED_XFLAGS		(FS_XFLAG_PTIME)
+
 int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
+	struct inode *inode = d_backing_inode(dentry);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+
 	/*
 	 * exFAT compares filenames through an upcase table, so lookup
 	 * is always case-insensitive. Long names are stored in UTF-16
@@ -400,6 +407,12 @@ int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	 */
 	fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
 	fa->flags |= FS_CASEFOLD_FL;
+
+	fa->fsx_ptime.tv_sec = ei->i_crtime.tv_sec;
+	fa->fsx_ptime.tv_nsec = ei->i_crtime.tv_nsec;
+	fa->fsx_xflags |= FS_XFLAG_PTIME;
+	fa->fsx_xflags_mask |= FS_XFLAG_PTIME;
+
 	return 0;
 }
 
@@ -485,6 +498,32 @@ int exfat_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	return error;
 }
 
+int exfat_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
+		      struct file_kattr *fa)
+{
+	struct inode *inode = d_backing_inode(dentry);
+	struct exfat_inode_info *ei = EXFAT_I(inode);
+
+	if (fileattr_has_fsx_mask(fa, EXFAT_SUPPORTED_XFLAGS))
+		return -EOPNOTSUPP;
+
+	if (fa->fsx_xflags_mask & ~EXFAT_SUPPORTED_XFLAGS)
+		return -EOPNOTSUPP;
+
+	if (fa->flags & ~FS_CASEFOLD_FL)
+		return -EOPNOTSUPP;
+
+	if (fa->fsx_xflags_mask & FS_XFLAG_PTIME) {
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
@@ -1110,4 +1149,5 @@ const struct inode_operations exfat_file_inode_operations = {
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

