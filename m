From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] fs: reject unknown open flags
Date: Thu, 30 Mar 2017 18:33:27 +0200
Message-ID: <20170330163327.23920-3-hch@lst.de>
References: <20170330163327.23920-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170330163327.23920-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

This way userspace can probe for actually supported flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/open.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 949cef29c3bb..9106ed7310f0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -900,6 +900,9 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 	int lookup_flags = 0;
 	int acc_mode = ACC_MODE(flags);
 
+	if (flags & ~VALID_OPEN_FLAGS)
+		return -EINVAL;
+
 	if (flags & (O_CREAT | __O_TMPFILE))
 		op->mode = (mode & S_IALLUGO) | S_IFREG;
 	else
-- 
2.11.0
