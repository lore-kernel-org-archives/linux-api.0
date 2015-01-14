From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 01/16] virtio_pci: drop virtio_config dependency
Date: Wed, 14 Jan 2015 19:27:24 +0200
Message-ID: <1421256142-11512-2-git-send-email-mst@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1421256142-11512-1-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

virtio_pci does not depend on virtio_config:
let's not include it, users can pull it in as necessary.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_pci.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 35b552c..509d630 100644
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
