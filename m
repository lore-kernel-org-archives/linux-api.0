From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v5 06/45] virtio: add virtio 1.0 feature bit
Date: Thu, 27 Nov 2014 14:30:34 +0200
Message-ID: <1417091078-24611-7-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
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
Cc: thuth@linux.vnet.ibm.com, rusty@au1.ibm.com, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org, dahi@linux.vnet.ibm.com, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

Based on original patches by Rusty Russell, Thomas Huth
and Cornelia Huck.

Note: at this time, we do not negotiate this feature bit
in core, drivers have to declare VERSION_1 support explicitly.

For this reason we treat this bit as a device bit
and not as a transport bit for now.

After all drivers are converted, we will be able to
move VERSION_1 to core and drop it from all drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 include/uapi/linux/virtio_config.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3ce768c..80e7381 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -54,4 +54,7 @@
 /* Can the device handle any descriptor layout? */
 #define VIRTIO_F_ANY_LAYOUT		27
 
+/* v1.0 compliant. */
+#define VIRTIO_F_VERSION_1		32
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
MST
