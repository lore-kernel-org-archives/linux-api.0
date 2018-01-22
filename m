From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/36] aio: don't print the page size at boot time
Date: Mon, 22 Jan 2018 21:12:08 +0100
Message-ID: <20180122201243.31610-2-hch@lst.de>
References: <20180122201243.31610-1-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122201243.31610-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The page size is in no way related to the aio code, and printing it in
the (debug) dmesg at every boot serves no purpose.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/aio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index a062d75109cb..03d59593912d 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -264,9 +264,6 @@ static int __init aio_setup(void)
 
 	kiocb_cachep = KMEM_CACHE(aio_kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
-
-	pr_debug("sizeof(struct page) = %zu\n", sizeof(struct page));
-
 	return 0;
 }
 __initcall(aio_setup);
-- 
2.14.2
