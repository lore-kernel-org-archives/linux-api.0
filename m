Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793498250;
	b=uE/cbaD0aGq7+WrTLugfoadGOwnCBybPxZxe7PVIlA5IY76kxm+hCe10wXg0lCHJyH9A
	 Va9rC4mkQ/U66Uv0FlfzdZbUVmXXD/WvPZR44mviH8T79Zzd3JHHdHbij2oJisapZPDga
	 wbqRdbose91r+O67rpjmKc8YDhPuVV85zArKRNfE2KrpaEZcOXJ27rC+pmDR7dYx+Rr9g
	 wcfkyuSbo+KKYaRw9iqb+bWjdWj30soR85orFau0MMpL3HCJFL1TVzOkli3eH27GdfRVs
	 d7eVclVoDsneR3VZDMelXm7lm1AQDLIiyI3oxcVCNf6E3Yl5NXBrCuHHqd/GUguEwxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793498250;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z5MG08yt3Dfb74iEQhSFMIkh2RLd3WaV8uSunF8a+30=;
	b=OBVxJdkbhcHnpgwROatnS/iw6nrS2fDS7oMz+Mm+g0F5LL5WsT2juD7eI6ZEuVEFohyS
	 NWKjLZhuh+HSMuE56M22nwRZL3JIsQl9p/OuskLYkCRWECp3wLPOFdB+uaipwIW9UOxZV
	 aYgHa6lJ7MVar7gpWP3QA5w85RP8l19oHmH4z3xaOmSWr2LH7NbRWg5vPVCsHfCaTvIwB
	 WF0qoeHkkOHv0Wgxa0Ju/xEmWw5pZUkxgp92r4F2vvwTnC8ID+rDJq7BSYy1rPYX50KP1
	 DcVSO1Vkf7d16dNe9JR6LHpXT2z8hN5xHdoJqaI/79Bn4a666KvKkIVxAbXQYHzStdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="BsuMTcX/";
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FB160A3801
	for <linux-api@vger.kernel.org>; Sun,  1 Nov 2026 01:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7FB160A3801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BsuMTcX/
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so19809035e9.3
        for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 18:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793498248; x=1794103048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z5MG08yt3Dfb74iEQhSFMIkh2RLd3WaV8uSunF8a+30=;
        b=BsuMTcX/BjdxIN1q3x96RSbSUJhcQimg9AITR+6CL0Jk0S52NUmp2phDSjd9arPfrG
         SyC/+LPuBtqBdhxAhqypEFo1DMutXeqtJVZIrB36WKs+5+A2aT3QmuRxQn7GWMdYnit0
         UIkhudzFiZjSp/8PytPE0qRP/nQv/GeMwXqNfCfDidbW/TSEyMc8NpHF3IILfV0IxPYj
         /LAfNVTcTLQMV3z3wsdEuTHMkFY4Bqk9Co8VRDbXglFKwGY6NZDIEwQnOsotnkrFEJ4/
         WivLN1GoM1uxHzydbRxByfB5XEoIG3GmEOw8gh1zOXULD+II7ZwqSRJT4VNoINdioqDH
         LTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793498248; x=1794103048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z5MG08yt3Dfb74iEQhSFMIkh2RLd3WaV8uSunF8a+30=;
        b=fvc4aJKKPmbV5ndM6oIsnGmroa8yNbtVY2WRYU3MbizBBHEecL/tAMDadPMbZ2l9kN
         mDzLyuYWNbEb01jl44bKLUnkCuDYcufXcbl02pYSTJdNLXg3DK+LuUyM8MMc7E99fYb2
         PTqIo4GeeAC1Zn3LQsDC5dSkipZUDKLheuCrsfgLg5SvrVyeZohHDyQb4UC6t2Dp2R+U
         OB2iUyD7WSfpcWD/60ZY9jLzKRHVraQMdEEze/46gN9zIK970PR7qvA08LFKgOflKBx5
         7SkTSixJOq8fz0udBsT+vokZKohv6ZiWBQAIoKDIiGIaTu+h0P8Cge/9LtfTKx/nxxir
         G8rA==
X-Forwarded-Encrypted: i=1; AKwUvBzCNWpOdhqsfbLWshJc8mWT2GPPNUrY/bPqbf5t23J2eQkZx0u8ID0COocUGl51vHK+BRLWNoIQa9Y=@vger.kernel.org
X-Gm-Message-State: AFq9FYJOhrXY1su+2ONW2k1DaMwZPAIr8k0cLPWxwZUSipBguHVXBJnP
	kwqubQeEyKN/snANO/2cBfly+ysHJZyvrWTnzVT23FsdF8lKA91g+ZRp
X-Gm-Gg: AYBFou0M08vu65ccYlsEB6lodCeHrz/9GucCgPTmoKotUa2sqSBvRfNRoIBH9gM3os0
	o2KCauBbiaWfCKRBWItXSfg+dCE+iiIoebe5UKXk3IkpyBXNoLd1ncS5h7jxJaxuA9q1Un5pUTJ
	djIgae1d7FoE+ToieCh6mcFqdqSPojm9FkBUICj6KVtiEDGv2MMiWxyflrNaEc9v2sAx8osyx0+
	IKp0a64MFqPCQfSA0G7a5DxTDpAi93bqIJnWknejD3uUnS/t0eTfhm7Bc6VaptPQkAid+i2rhEo
	6WrsNo0cJ6GtOxonGrMSLEiET3C71BXZwePfSYnDqqVxcdWKFYInLP9TSRct6dG/Fkmog9BauAy
	E1SVmYeF+ginUN0NsRvS2QUmHFqO3eFntEz1CPFVDZyMNTv5R1Lv6eDHCuOP8yV610jCcKfvqTC
	AlL3e4QXKvcUrxoYzNrb0TuCg65X4h0SbpR3ipO51m6WTmnW/QnASpPffTGJ7aTsGjFaf4lgmD5
	oPQXfqH6lo3dWTUTuVed46Jv0yBHE6qrl8RFRwkRTV5zh+ztI64k+AYR4TkAcYiP+SN4HPZf8Za
	6zv2qgFG0u7J2fuFZVTbYF8E
X-Received: by 2002:a05:600c:46d1:b0:4a3:59c9:a754 with SMTP id 5b1f17b1804b1-4ac187a72f4mr145723175e9.22.1793498247899;
        Sat, 31 Oct 2026 18:57:27 -0700 (PDT)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm273532835e9.11.2026.10.31.18.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:57:26 -0700 (PDT)
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
Subject: [RFC PATCH v3 3/5] ntfs3: make crtime user-settable using ptime
Date: Sun,  1 Nov 2026 02:55:49 +0100
Message-ID: <20261101015551.786044-4-koray.fra@gmail.com>
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

Since NTFS supports user-settable file creation timestamps, map
provenance time (ptime) to NTFS file creation time (crtime) by using the
newly introduced ptime API (in commit "vfs: add provenance time
(ptime)").

To do this, update ntfs_fileattr_[gs]et(), ntfs_getattr() and make it
persist to disk in ni_write_inode().

The timestamp is now retrievable by using file_getattr() or statx(), and
is settable by using file_setattr() with the FS_XFLAG_PTIME flag.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/ntfs3/file.c    | 14 ++++++++++++--
 fs/ntfs3/frecord.c |  8 +++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 1624f9b014e0..b334449e9beb 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -124,6 +124,10 @@ int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 
 	fileattr_fill_flags(fa, flags);
 
+	fa->fsx_ptime.tv_sec = ni->i_crtime.tv_sec;
+	fa->fsx_ptime.tv_nsec = ni->i_crtime.tv_nsec;
+	fa->fsx_xflags |= FS_XFLAG_PTIME;
+
 	return 0;
 }
 
@@ -142,7 +146,7 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (unlikely(is_bad_ni(ni)))
 		return -EINVAL;
 
-	if (fileattr_has_fsx(fa))
+	if (fileattr_has_fsx_mask(fa, FS_XFLAG_PTIME))
 		return -EOPNOTSUPP;
 
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL))
@@ -154,6 +158,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (flags & FS_APPEND_FL)
 		new_fl |= S_APPEND;
 
+	if (fa->fsx_xflags & FS_XFLAG_PTIME) {
+		ni->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
+		ni->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
+	}
+
 	inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
 
 	/* Save nodump flag to return in ntfs_getattr. */
@@ -275,8 +284,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
 	if (unlikely(is_bad_ni(ni)))
 		return -EINVAL;
 
-	stat->result_mask |= STATX_BTIME;
+	stat->result_mask |= (STATX_BTIME | STATX_PTIME);
 	stat->btime = ni->i_crtime;
+	stat->ptime = ni->i_crtime;
 	stat->blksize = ni->mi.sbi->cluster_size; /* 512, 1K, ..., 2M */
 
 	if (inode->i_flags & S_IMMUTABLE)
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 16ac847de48d..5e4f743a5930 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -3215,6 +3215,13 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint)
 		}
 
 		/* Update the access times if they have changed. */
+		ts = ni->i_crtime;
+		dup.cr_time = kernel2nt(&ts);
+		if (std->cr_time != dup.cr_time) {
+			std->cr_time = dup.cr_time;
+			modified = true;
+		}
+
 		ts = inode_get_mtime(inode);
 		dup.m_time = kernel2nt(&ts);
 		if (std->m_time != dup.m_time) {
@@ -3250,7 +3257,6 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint)
 		    (modified || (ni->ni_flags & NI_FLAG_UPDATE_PARENT))
 		    /* Avoid __wait_on_freeing_inode(inode). */
 		    && (sb->s_flags & SB_ACTIVE)) {
-			dup.cr_time = std->cr_time;
 			/* Not critical if this function fail. */
 			re_dirty = ni_update_parent(ni, &dup, sync);
 
-- 
2.56.0

