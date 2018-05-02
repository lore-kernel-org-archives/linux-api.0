From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/7] aio: don't print the page size at boot time
Date: Wed,  2 May 2018 23:14:42 +0200
Message-ID: <20180502211448.18276-2-hch@lst.de>
References: <20180502211448.18276-1-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502211448.18276-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The page size is in no way related to the aio code, and printing it in
the (debug) dmesg at every boot serves no purpose.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/aio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 88d7927ffbc6..add46b06be86 100644
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
2.17.0
