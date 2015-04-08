From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: [PATCH 1/5] fs: configfs: Fix typo in comment
Date: Wed, 08 Apr 2015 13:28:44 +0200
Message-ID: <1428492528-11993-2-git-send-email-k.opasiak@samsung.com>
References: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1428492528-11993-1-git-send-email-k.opasiak@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com, gregkh@linuxfoundation.org, jlbec@evilplan.org
Cc: andrzej.p@samsung.com, m.szyprowski@samsung.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Krzysztof Opasiak <k.opasiak@samsung.com>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
---
 fs/configfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index cf0db00..dee1cb5 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -325,7 +325,7 @@ static void configfs_dir_set_ready(struct configfs_dirent *sd)
  * attached and not validated yet.
  * @sd		configfs_dirent of the directory to check
  *
- * @return	non-zero iff the directory was validated
+ * @return	non-zero if the directory was validated
  *
  * Note: takes configfs_dirent_lock, so the result may change from false to true
  * in two consecutive calls, but never from true to false.
-- 
1.7.9.5
