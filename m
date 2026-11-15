Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765848;
	b=fLxKKs+788+P8jfQ5IU0faCdcL1F13wxL8ImGevWmWnP624VDZTB45Nhvd3ZV5iYiSN6
	 Pp5oPaZBHZIDZFQqrgWqs5Wk9G9J5iZ0XTCh1KI1UnT5v5+4KHe8ez6KLMAMdWGieU/6+
	 Jiy2URpbuyGu5bFd3Y54qIR72mRFM3UXIilgReq6/i+ixoNB+Vv8HZDQDuT3m1pnP2tB5
	 Qxg/q75NOv74Cja92ibzXsmKSoDK6QlZ6LfMBvwdcVfWkPIe3K4EpGTM+j+nPCIGRjGM0
	 3DB7PV69k5F2EaZBgowl8+Tngr7m3ffp439xxYvUep8Y+RIJPBooJubIAwDc/0Z/APQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765848;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ER6/NO7zpzo2Xjo4XaIJ1M2igxcKQmZBMoJ1KN6Ri4=;
	b=oyFKUYchJ91oNyCQG3OR2HoUw1hDS+AIk4kr2jWCJvsx1f3zZvTUIB18r3ftgCkNjgpn
	 csnCgMRdkn07kNxJHM425GtGlvq3tYmydnzP5R40Z+YA0uFILoo3dOf6D7HUX7fOFeFdx
	 l5AmC4a+si1fqY2wPIIRJiTpnB60E1czR3fbE3I/zA5+8mr03wZ8W36B7v7MlaXBoEVCz
	 hHNQFB9e4qBdhIgKrRnYwFtquhqK2UWrw99IBM/pV1uLG35sP1OrX9XX8Kk4P+hsBbCzR
	 e6w8mtk9SOk9xRbCoWljRAZqYXktzaVQs+U8tHRWP02P+KcxxkpnZgFgd4toCLd2uBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DaS9K5UI;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D9F60A2616
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 18:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4D9F60A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DaS9K5UI
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-49134c8509fso2749974f8f.1
        for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 10:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794765846; x=1795370646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ER6/NO7zpzo2Xjo4XaIJ1M2igxcKQmZBMoJ1KN6Ri4=;
        b=DaS9K5UI5vQ6cDAdOmD7Qt3vqAgjmmAL4TB7Qob7Ng6lFn86kSu0BmRP5k0gSrPuzh
         AT8oBolUXoZcsBs5Is3ZCZ1j+CoUO4AunmNzyKR8loHZYVnNt778jycfOpIPt7Uh1pH6
         u3pf5xD9Q7+GgA5uziBNNrwaX6hOcWbglNJ+6upcxAua3CvwaNDG2ypPTlu9IUXH/qs8
         STMRY09KkjIKkcMndQZ9bo8+h0BzzdH2NS486mWjKnNoAtq1VanBD5+yuk3zIGmO8Fjh
         f/Z5bO08dOxs1qXW64JZbnwNHneAHab7ml/o6RGA5F2zOt/0d4xpWgMDucuXBXmHYpof
         ZXXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794765846; x=1795370646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ER6/NO7zpzo2Xjo4XaIJ1M2igxcKQmZBMoJ1KN6Ri4=;
        b=KujqVU/e0MKcnMK97b4hVWsHWbyUcQJGJP+KmMRh7nNZSNI6Jd2Ik6vAdM1TcQhwkY
         vazVxIcv62Tp2rw4jmIxEMoJh2BEsKA1CxZswKcKn+wwLbp65h2T0gBpo3iRtZFlVTO0
         tJeH9CiHTHppY9i98uQMa4GU1iGAOWGFAjnaODcDFymNT8CWYpbqMhUb/vMdQ9I32LUv
         e9IoMHL4KCzc0bU4HwF9MOH/9NylKWYs/Fh8kvpXHJbzCQPSI4h978lCJ6HILz9oSHdx
         hq5M4DmJuFKTDGM7ecRhljeWkQOWmvRya3kSc36mOqQj6bMmTt9V3n1I2/rglKnYaa2L
         WrAA==
X-Forwarded-Encrypted: i=1; AL+hErEr8YBIyimzN2rmfDby3pS4CQ0emKGWjn3gNMRlWWhuYduhiQyFHsM8mgdqeCPh2A1UPfmEMLaHOlI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8FnBodLEowNrMvch+wICLSgpvuuTbVzFbUkRSmtSuX5HRUbQfN
	USGu/PxREafWVYySy6TUPvdiS0JI77MkbUHhEBUGe/7oWFNXzPobCzzX
X-Gm-Gg: AYBFou2veBYLwIXLR4NncaMUXTgfUQdQBCQIcYoyIV6if4AekWiDiKjbTfRrkytjv4I
	y5rOKalVS4cBBf/MJgIJAl/E9romecnYNiCLNAYIOOn4ItKrmbyhoSCdwEgTTpZBTB5uthvvWn/
	pjO3T28QKzZkqzj9Iil0Tncbuu3iqI4s7sAHups7Cv/vyj1OFeWh8JDey3hohe0YX3TIxEaGFLY
	KskAZP/b3QFvoY6qtsn5PSaGtPg7iGAPm6WY9rUgCIrinbPNGhxZ4iZ5fBeHzwlAgBJAomHrzm/
	jkLVD/FW20fZy5W6ba/VvMTl+FKYnrUBpxHh7wri8jaI5EhPWBwPe8j6g1ghr60d4E6ZIpYw05H
	V9+eZvON6YWV6w54wY4hN0tBoBz8FlxbXjqu59JZJ42BF+yQ2SDzbHLqG28SZa3hvDG5bh1mQNS
	8cSRdsVrvFDRyIqcd5wspFY6qRg6s0uj+dOfN5aikRUkEpOk/jBnyGKRYcEFRCkRYqRSyl5jOzD
	qQANc2tBnnvL37jKOOk08f1X9z4g1S3Yvi8gH3Lu4JPdwxcVxfKSYnXNXmG6ZL8gQcsZ1GU4wls
	SflRpQkfpfG4ZHSfpTv+F+xR
X-Received: by 2002:a5d:5d88:0:b0:48b:1296:52ec with SMTP id ffacd0b85a97d-49c70ed8eaamr19692466f8f.18.1794765845937;
        Sun, 15 Nov 2026 10:04:05 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm17980448f8f.58.2026.11.15.10.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 10:04:05 -0800 (PST)
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
Subject: [RFC PATCH v4 03/10] ntfs3: make crtime user-settable using ptime
Date: Sun, 15 Nov 2026 19:03:36 +0100
Message-ID: <20261115180343.576773-4-koray.fra@gmail.com>
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
 fs/ntfs3/file.c    | 20 ++++++++++++++++++--
 fs/ntfs3/frecord.c |  8 +++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 6c84a3e1c7fe..1a9301006154 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -90,6 +90,8 @@ static int ntfs_ioctl_fitrim(struct ntfs_sb_info *sbi, unsigned long arg)
 	return 0;
 }
 
+#define NTFS_SUPPORTED_XFLAGS		(FS_XFLAG_PTIME)
+
 /*
  * ntfs_fileattr_get - inode_operations::fileattr_get
  */
@@ -124,6 +126,11 @@ int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 
 	fileattr_fill_flags(fa, flags);
 
+	fa->fsx_ptime.tv_sec = ni->i_crtime.tv_sec;
+	fa->fsx_ptime.tv_nsec = ni->i_crtime.tv_nsec;
+	fa->fsx_xflags |= FS_XFLAG_PTIME;
+	fa->fsx_xflags_mask |= FS_XFLAG_PTIME;
+
 	return 0;
 }
 
@@ -142,7 +149,10 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (unlikely(is_bad_ni(ni)))
 		return -EINVAL;
 
-	if (fileattr_has_fsx(fa))
+	if (fileattr_has_fsx_mask(fa, NTFS_SUPPORTED_XFLAGS))
+		return -EOPNOTSUPP;
+
+	if (fa->fsx_xflags_mask & ~NTFS_SUPPORTED_XFLAGS)
 		return -EOPNOTSUPP;
 
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL))
@@ -154,6 +164,11 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (flags & FS_APPEND_FL)
 		new_fl |= S_APPEND;
 
+	if (fa->fsx_xflags_mask & FS_XFLAG_PTIME) {
+		ni->i_crtime.tv_sec = fa->fsx_ptime.tv_sec;
+		ni->i_crtime.tv_nsec = fa->fsx_ptime.tv_nsec;
+	}
+
 	inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
 
 	/* Save nodump flag to return in ntfs_getattr. */
@@ -275,8 +290,9 @@ int ntfs_getattr(const struct mnt_idmap *idmap, const struct path *path,
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

