From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH RFC v2 7/7] virtio_pci: drop virtio_config dependency
Date: Tue, 30 Dec 2014 18:35:52 +0200
Message-ID: <1419957310-26009-8-git-send-email-mst@redhat.com>
References: <1419957310-26009-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1419957310-26009-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com, virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

virtio_pci does not depend on virtio_config:
let's not include it, users can pull it in as necessary.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 5d546c6..e841edd 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -39,7 +39,7 @@
 #ifndef _LINUX_VIRTIO_PCI_H
 #define _LINUX_VIRTIO_PCI_H
 
-#include <linux/virtio_config.h>
+#include <linux/types.h>
 
 #ifndef VIRTIO_PCI_NO_LEGACY
 
-- 
MST
