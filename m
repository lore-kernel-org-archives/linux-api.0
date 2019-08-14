From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] tracefs: Fix NULL pointer dereference when no lockdown is
 used
Date: Wed, 14 Aug 2019 08:12:37 +0200
Message-ID: <20190814061237.17406-1-m.szyprowski@samsung.com>
References: <3028ed35-3b6d-459f-f3c8-103c5636fe95@samsung.com>
        <CGME20190814061246eucas1p128cae99a14f27bc79fa2aa72084a0413@eucas1p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3028ed35-3b6d-459f-f3c8-103c5636fe95@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Matthew Garrett <mjg59@google.com>, Steven Rostedt <rostedt@goodmis.org>, James Morris <jmorris@namei.org>, Krzysztof Kozlowski <krzk@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Matthew Garrett <matthewgarrett@google.com>
List-Id: linux-api@vger.kernel.org

Commit 757ff7244358 ("tracefs: Restrict tracefs when the kernel is locked
down") added infrastructure for restricting tracefs access when lockdown
is enabled. It however broke tracefs operation when no lockdown is used.
Fix this issue by adding missing check for a NULL ->open() callback.

Fixes: 757ff7244358 ("tracefs: Restrict tracefs when the kernel is locked down")
Reported-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 fs/tracefs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 12a325fb4cbd..8efff7603032 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -43,7 +43,7 @@ static int default_open_file(struct inode *inode, struct file *filp)
 		return ret;
 
 	real_fops = dentry->d_fsdata;
-	return real_fops->open(inode, filp);
+	return real_fops->open ? real_fops->open(inode, filp) : 0;
 }
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
-- 
2.17.1
