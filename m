Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBBD4E06C9
	for <linux-api@vger.kernel.org>; Fri, 16 Oct 2026 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161459; cv=none; b=pzx0QFDcHuYklcKMMTPC6MYyaGpolkMKc7iUSuJmN+xd1Dwhf0KvKsOJ1vDgQKQipZZ0+nmqXrAUn9cLZBDjdMZj2qsnWBegwVwV17AOIJcbCE0OcZKKfRkBMi7gSJTg3dmXdailc0QWtA1NowLDklcXI45lq4XAq+5v0ePvz5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161459; c=relaxed/simple;
	bh=XVEq9w0VLAg9zMkBd9PDY5Fg+M5rmhua9Ob8KJ3Bo30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGJpDLiGqMavfVkSe04BkIgWHU53nuonrdJR+4umWcRUWHqXrxhAc92AQn5hbwMCGmqStgdln4/rSdwrhuFAprxRZ6KUDjZCdOfPkUWGWeYIzzRkZHmZ39V1wGFeqsZmhSNT4LI4hcmLUg3Eg0U9BUIDOGOFQaPuGoMxohonqv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=vLRMyPgt; arc=none smtp.client-ip=195.121.94.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="vLRMyPgt"
X-KPN-MessageId: 1ddfaa5e-c96f-11f1-bfc1-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 1ddfaa5e-c96f-11f1-bfc1-00505699b430;
	Fri, 16 Oct 2026 16:37:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=gsunsS3wiXjJim72FGVFP8xzpuphaMxK4G2dkef44Ws=;
	b=vLRMyPgt2D4BxAceyRQj6RXVdVYGM5HRT1uUX5QibCsphP0XitaeVJ8HMRchU7kVvKfWcbOkzLBqy
	 gu3Yd+eJ0J7mI9YxgiC2bVDF05F+NukP/9DGZyzxNZL84wnQMtacWIwXKmYsXmXCbAK+TPwhL9Qu6a
	 S6GGbxyPoG4v2arcJWRpNj7EBkcTClqwXGPexEJ3Fome4RYdXIH4NLxg0yIoaVD0wlWnSSKhMBCX7I
	 mu7aeDGAtGwE4b6XanzULm/uO91/9o4DrC9NU2BVMIKt03x9O8NTCyWff/JSoGBLQfrjCoE+kUKXJo
	 I/f0PAwyut9kG5x+QdlTgbgWUHTFteQ==
X-KPN-MID: 33|eNmD9ihrgpPbLZN0P4y5ZU4YddTIInjSwlhyKjsFBzTup3x58f32PoCnFQvJdFZ
 xMrRqPrdOiKBmseKJLUFFCWv92gcElEFh2sh9iB3x4DQ=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|MRWIH+eF+kaNCuSEThzcuq1B75pmb0Yq2cjZT2NM0+GXPts+l7n8uIUkXumaa1N
 GcZAOSo6HIxushVf+7vRQnQ==
Received: from daedalus.home (unknown [178.228.137.172])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 1d9f7ad8-c96f-11f1-a202-00505699b758;
	Fri, 16 Oct 2026 16:37:30 +0200 (CEST)
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
Subject: [PATCH v7 11/12] vfs: change ->create/->mkdir operations unavailable errno
Date: Fri, 16 Oct 2026 16:38:05 +0200
Message-ID: <20261016143806.2946578-12-jkoolstra@xs4all.nl>
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

Currently filesystems return -EACCES for missing ->create and -EPERM for
missing ->mkdir in vfs_create/vfs_mkdir. Instead of duplicating these
dubious and inconsistent error codes to lookup_open(), change all to
-EOPNOTSUPP.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 arch/alpha/include/uapi/asm/errno.h  |  2 +-
 arch/mips/include/uapi/asm/errno.h   |  2 +-
 arch/parisc/include/uapi/asm/errno.h |  2 +-
 arch/sparc/include/uapi/asm/errno.h  |  2 +-
 fs/namei.c                           | 14 +++++---------
 include/uapi/asm-generic/errno.h     |  2 +-
 6 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/errno.h b/arch/alpha/include/uapi/asm/errno.h
index 1a99f38813c7..0384f6998974 100644
--- a/arch/alpha/include/uapi/asm/errno.h
+++ b/arch/alpha/include/uapi/asm/errno.h
@@ -19,7 +19,7 @@
 #define	ENOPROTOOPT	42	/* Protocol not available */
 #define	EPROTONOSUPPORT	43	/* Protocol not supported */
 #define	ESOCKTNOSUPPORT	44	/* Socket type not supported */
-#define	EOPNOTSUPP	45	/* Operation not supported on transport endpoint */
+#define	EOPNOTSUPP	45	/* Operation not supported */
 #define	EPFNOSUPPORT	46	/* Protocol family not supported */
 #define	EAFNOSUPPORT	47	/* Address family not supported by protocol */
 #define	EADDRINUSE	48	/* Address already in use */
diff --git a/arch/mips/include/uapi/asm/errno.h b/arch/mips/include/uapi/asm/errno.h
index 1835a50b69ce..2b6813715d1e 100644
--- a/arch/mips/include/uapi/asm/errno.h
+++ b/arch/mips/include/uapi/asm/errno.h
@@ -75,7 +75,7 @@
 #define ENOPROTOOPT	99	/* Protocol not available */
 #define EPROTONOSUPPORT 120	/* Protocol not supported */
 #define ESOCKTNOSUPPORT 121	/* Socket type not supported */
-#define EOPNOTSUPP	122	/* Operation not supported on transport endpoint */
+#define EOPNOTSUPP	122	/* Operation not supported */
 #define EPFNOSUPPORT	123	/* Protocol family not supported */
 #define EAFNOSUPPORT	124	/* Address family not supported by protocol */
 #define EADDRINUSE	125	/* Address already in use */
diff --git a/arch/parisc/include/uapi/asm/errno.h b/arch/parisc/include/uapi/asm/errno.h
index 93194fbb0a80..74bd65d79145 100644
--- a/arch/parisc/include/uapi/asm/errno.h
+++ b/arch/parisc/include/uapi/asm/errno.h
@@ -84,7 +84,7 @@
 #define	ENOPROTOOPT	220	/* Protocol not available */
 #define	EPROTONOSUPPORT	221	/* Protocol not supported */
 #define	ESOCKTNOSUPPORT	222	/* Socket type not supported */
-#define	EOPNOTSUPP	223	/* Operation not supported on transport endpoint */
+#define	EOPNOTSUPP	223	/* Operation not supported */
 #define	EPFNOSUPPORT	224	/* Protocol family not supported */
 #define	EAFNOSUPPORT	225	/* Address family not supported by protocol */
 #define	EADDRINUSE	226	/* Address already in use */
diff --git a/arch/sparc/include/uapi/asm/errno.h b/arch/sparc/include/uapi/asm/errno.h
index 71940ec9130b..699f648e1a35 100644
--- a/arch/sparc/include/uapi/asm/errno.h
+++ b/arch/sparc/include/uapi/asm/errno.h
@@ -16,7 +16,7 @@
 #define	ENOPROTOOPT	42	/* Protocol not available */
 #define	EPROTONOSUPPORT	43	/* Protocol not supported */
 #define	ESOCKTNOSUPPORT	44	/* Socket type not supported */
-#define	EOPNOTSUPP	45	/* Op not supported on transport endpoint */
+#define	EOPNOTSUPP	45	/* Operation not supported */
 #define	EPFNOSUPPORT	46	/* Protocol family not supported */
 #define	EAFNOSUPPORT	47	/* Address family not supported by protocol */
 #define	EADDRINUSE	48	/* Address already in use */
diff --git a/fs/namei.c b/fs/namei.c
index e7d3d28f3fd7..f21cd1028a8a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4254,7 +4254,7 @@ int vfs_create(struct mnt_idmap *idmap, struct dentry *dentry, umode_t mode,
 		return error;
 
 	if (!dir->i_op->create)
-		return -EACCES;	/* shouldn't it be ENOSYS? */
+		return -EOPNOTSUPP;
 
 	mode = vfs_prepare_mode(idmap, dir, mode, S_IALLUGO, S_IFREG);
 	error = security_inode_create(dir, dentry, mode);
@@ -4650,13 +4650,9 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 		goto out_dput;
 	}
 
-	/* mimic operation missing errnos of vfs_mkdir/vfs_create */
-	if (create_dir && !dir_inode->i_op->mkdir) {
-		error = -EPERM;
-		goto out_dput;
-	}
-	if (!create_dir && !dir_inode->i_op->create) {
-		error = -EACCES;
+	if ((create_dir && !dir_inode->i_op->mkdir)
+		|| (!create_dir && !dir_inode->i_op->create)) {
+		error = -EOPNOTSUPP;
 		goto out_dput;
 	}
 
@@ -5518,7 +5514,7 @@ struct dentry *vfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	if (error)
 		goto err;
 
-	error = -EPERM;
+	error = -EOPNOTSUPP;
 	if (!dir->i_op->mkdir)
 		goto err;
 
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index bd78e69e0a43..c84ebf89c8b6 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -76,7 +76,7 @@
 #define	ENOPROTOOPT	92	/* Protocol not available */
 #define	EPROTONOSUPPORT	93	/* Protocol not supported */
 #define	ESOCKTNOSUPPORT	94	/* Socket type not supported */
-#define	EOPNOTSUPP	95	/* Operation not supported on transport endpoint */
+#define	EOPNOTSUPP	95	/* Operation not supported */
 #define	EPFNOSUPPORT	96	/* Protocol family not supported */
 #define	EAFNOSUPPORT	97	/* Address family not supported by protocol */
 #define	EADDRINUSE	98	/* Address already in use */
-- 
2.56.0

