Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12D73932F7;
	Mon, 12 Oct 2026 18:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791830831; cv=none; b=dVBzBXcPE4+9VIbZJN8m1yPx+VhHVgAkwYbZ98JTwGnsLREA9wLESo+mkjdJLUQaTH0TDETLGOIphnwFVG3k7BFvr6F4jo9otkCujS+UdldfoTHflihSqYPHkloDoyOsKV6QVj6u6mDI2Imf8tk81ilLCibBGdD48+WwEiDP4Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791830831; c=relaxed/simple;
	bh=9RZm/CwGW9+O0CItM/ov6oKoaq82uM5RDC3NSRttRR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ljWZ01X7cf9Jz4xjo6YfwTLRhaY+Ms8l7NVgaiiYPc1wXfQZTm0e+hjBQU1Cx5Gy2N3jCo9xogveaLl/J57EH362gA4d+TiJv5bBoK036KX8mpCIvvxw/bQ6cTM5vQtYkd9dTjDMbaTpU3AelRfLfOy8m03jjR1vm2ja6cP9+fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=a3FHqesN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="a3FHqesN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=PbzpHddRgwUHkHtoUFDezWwH1DUtK44tX+LY/8eTDfw=; b=a3FHqesNH4EDunY4Jp/QBTRjyd
	6WzoGWPIDi4GdnrEnqGL5BF12kXdy5QtUc7e4Zzi4kzkb5u7SqET+3lNJmRu2fuKblsEoNicWVRHD
	PrxQ8lMyp3aKxjjTMF5dw9O8gsq3Ivo/wZPynNYGw+szLJrVElrZY6n3yZxbcd1uCQCPLdTcQG6Pp
	KBLSGLv9wKxe+99xPbXIfIHv0G1b07GFgL0R23Pq6QMDxnx7/F69bFElbkH6ULXzUGnnuKZMSufuv
	9LZ29qV5+tYkyVtH3mpO9a6OG5Io/z1uNvtRIhMKkbK4mhpC9+M5hAFofKQnKEZk5nwGSzso2El32
	nw7LiGPkmgdNvnwtqy/cmLfkpt9ZLAIuWBMvSUwZ5Rb6PA2ghVMGDg6ZsR7vz3lpsXQJOr1LG7gnp
	s3Cpg9xasg0/llRmuZXljOMWDEZeIUDFddIyyc7Shdua3+SR46eipzjHz9XWp4n8gEkndZ5nQ/S1b
	ABX3PXf1hNvnyfzbPlrg4M8r;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xGL3A-00000001M3P-0RxE;
	Mon, 12 Oct 2026 18:47:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-fsdevel@vger.kernel.org
Cc: metze@samba.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	io-uring@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [PATCH] fs: add RWF_DIRECT for preadv2/pwritev2/io_uring to set IOCB_DIRECT per io
Date: Mon, 12 Oct 2026 20:46:42 +0200
Message-ID: <20261012184642.558349-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's useful to control this per io request instead of using O_DIRECT
for the file descriptor.

E.g. the SMB2_READFLAG_READ_UNBUFFERED and SMB2_WRITEFLAG_WRITE_UNBUFFERED
are also available per io request and this allows Samba to map then
to RWF_DIRECT.

kiocb_set_rw_flags() requires FMODE_CAN_ODIRECT (same check open()
does for O_DIRECT) and returns -EOPNOTSUPP otherwise, matching the
convention already used by RWF_NOWAIT/RWF_ATOMIC/RWF_DONTCACHE just
above it in the same function for "this flag isn't supported on this file".

IOCB_DIRECT predates RWF_DIRECT used a kernel-internal value,
but now IOCB_DIRECT is aligned with RWF_DIRECT the same way
commit ce71bfea207b ("fs: align IOCB_* flags with RWF_* flags")
already aligned the other shared flags.

The man-page.git will get something like this for man/man2/readv.2:

  RWF_DIRECT (since Linux XXX)
    Provide  a  per-I/O equivalent of the O_DIRECT open(2) flag.
    This allows a single preadv2() or pwritev2() call to bypass the
    page cache without the file descriptor having been opened with
    O_DIRECT.  Unlike enabling O_DIRECT with the fcntl(2) F_SETFL
    operation, this does not change the file status flags of
    the open file description, so other I/O on the same file
    descriptor, or on any file descriptor referring to the same
    open file description (see dup(2)), is not affected.
    If the underlying file or block device does not support
    O_DIRECT, the call fails; see ERRORS.  As with O_DIRECT open(2),
    the memory buffer, the file offset, and the I/O length
    generally need to be aligned to the logical block size of
    the underlying storage.

man/man2/io_submit.2 will also get updated and liburing
in man/io_uring_prep_readv2.3 and man/io_uring_prep_writev2.3

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Cc: io-uring@vger.kernel.org
Cc: linux-api@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/linux/fs.h      | 10 ++++++++--
 include/uapi/linux/fs.h |  5 ++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 83d41d9f1130..40d013a49378 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -344,10 +344,11 @@ struct readahead_control;
 #define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
 #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
+#define IOCB_DIRECT		(__force int) RWF_DIRECT
 
 /* non-RWF related bits - start at 16 */
+#define IOCB_NON_RWF_MASK	(~0xffff)
 #define IOCB_EVENTFD		(1 << 16)
-#define IOCB_DIRECT		(1 << 17)
 #define IOCB_WRITE		(1 << 18)
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 19)
@@ -3453,7 +3454,7 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
 	int kiocb_flags = 0;
 
 	/* make sure there's no overlap between RWF and private IOCB flags */
-	BUILD_BUG_ON((__force int) RWF_SUPPORTED & IOCB_EVENTFD);
+	BUILD_BUG_ON((__force int) RWF_SUPPORTED & IOCB_NON_RWF_MASK);
 
 	if (!flags)
 		return 0;
@@ -3480,6 +3481,11 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
 		if (IS_DAX(ki->ki_filp->f_mapping->host))
 			return -EOPNOTSUPP;
 	}
+	if (flags & RWF_DIRECT) {
+		/* file system must support it, same as O_DIRECT */
+		if (!(ki->ki_filp->f_mode & FMODE_CAN_ODIRECT))
+			return -EOPNOTSUPP;
+	}
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a46c33692aa2..3aa5fd73d391 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -451,10 +451,13 @@ typedef int __bitwise __kernel_rwf_t;
 /* prevent pipe and socket writes from raising SIGPIPE */
 #define RWF_NOSIGNAL	((__force __kernel_rwf_t)0x00000100)
 
+/* per-IO O_DIRECT */
+#define RWF_DIRECT	((__force __kernel_rwf_t)0x00000200)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
-			 RWF_DONTCACHE | RWF_NOSIGNAL)
+			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_DIRECT)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
-- 
2.43.0

