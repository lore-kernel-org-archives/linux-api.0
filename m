From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v8 47/50] virtio_console: virtio 1.0 support
Date: Mon, 1 Dec 2014 18:06:45 +0200
Message-ID: <1417449619-24896-48-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
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
Cc: thuth@linux.vnet.ibm.com, Arnd Bergmann <arnd@arndb.de>, rusty@au1.ibm.com, Amit Shah <amit.shah@redhat.com>, virtualization@lists.linux-foundation.org, dahi@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pbonzini@redhat.com, linux-api@vger.kernel.org, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

Pretty straight-forward, just use accessors for all fields.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_console.h |  7 ++++---
 drivers/char/virtio_console.c       | 29 +++++++++++++++++------------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/virtio_console.h b/include/uapi/linux/virtio_console.h
index ba260dd..b7fb108 100644
--- a/include/uapi/linux/virtio_console.h
+++ b/include/uapi/linux/virtio_console.h
@@ -32,6 +32,7 @@
 #ifndef _UAPI_LINUX_VIRTIO_CONSOLE_H
 #define _UAPI_LINUX_VIRTIO_CONSOLE_H
 #include <linux/types.h>
+#include <linux/virtio_types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
@@ -58,9 +59,9 @@ struct virtio_console_config {
  * particular port.
  */
 struct virtio_console_control {
-	__u32 id;		/* Port number */
-	__u16 event;		/* The kind of control event (see below) */
-	__u16 value;		/* Extra information for the key */
+	__virtio32 id;		/* Port number */
+	__virtio16 event;	/* The kind of control event (see below) */
+	__virtio16 value;	/* Extra information for the key */
 };
 
 /* Some events for control messages */
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 8d00aa7..775c898 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -566,9 +566,9 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
 	if (!use_multiport(portdev))
 		return 0;
 
-	cpkt.id = port_id;
-	cpkt.event = event;
-	cpkt.value = value;
+	cpkt.id = cpu_to_virtio32(portdev->vdev, port_id);
+	cpkt.event = cpu_to_virtio16(portdev->vdev, event);
+	cpkt.value = cpu_to_virtio16(portdev->vdev, value);
 
 	vq = portdev->c_ovq;
 
@@ -1602,7 +1602,8 @@ static void unplug_port(struct port *port)
 }
 
 /* Any private messages that the Host and Guest want to share */
-static void handle_control_message(struct ports_device *portdev,
+static void handle_control_message(struct virtio_device *vdev,
+				   struct ports_device *portdev,
 				   struct port_buffer *buf)
 {
 	struct virtio_console_control *cpkt;
@@ -1612,15 +1613,16 @@ static void handle_control_message(struct ports_device *portdev,
 
 	cpkt = (struct virtio_console_control *)(buf->buf + buf->offset);
 
-	port = find_port_by_id(portdev, cpkt->id);
-	if (!port && cpkt->event != VIRTIO_CONSOLE_PORT_ADD) {
+	port = find_port_by_id(portdev, virtio32_to_cpu(vdev, cpkt->id));
+	if (!port &&
+	    cpkt->event != cpu_to_virtio16(vdev, VIRTIO_CONSOLE_PORT_ADD)) {
 		/* No valid header at start of buffer.  Drop it. */
 		dev_dbg(&portdev->vdev->dev,
 			"Invalid index %u in control packet\n", cpkt->id);
 		return;
 	}
 
-	switch (cpkt->event) {
+	switch (virtio16_to_cpu(vdev, cpkt->event)) {
 	case VIRTIO_CONSOLE_PORT_ADD:
 		if (port) {
 			dev_dbg(&portdev->vdev->dev,
@@ -1628,13 +1630,15 @@ static void handle_control_message(struct ports_device *portdev,
 			send_control_msg(port, VIRTIO_CONSOLE_PORT_READY, 1);
 			break;
 		}
-		if (cpkt->id >= portdev->config.max_nr_ports) {
+		if (virtio32_to_cpu(vdev, cpkt->id) >=
+		    portdev->config.max_nr_ports) {
 			dev_warn(&portdev->vdev->dev,
-				"Request for adding port with out-of-bound id %u, max. supported id: %u\n",
+				"Request for adding port with "
+				"out-of-bound id %u, max. supported id: %u\n",
 				cpkt->id, portdev->config.max_nr_ports - 1);
 			break;
 		}
-		add_port(portdev, cpkt->id);
+		add_port(portdev, virtio32_to_cpu(vdev, cpkt->id));
 		break;
 	case VIRTIO_CONSOLE_PORT_REMOVE:
 		unplug_port(port);
@@ -1670,7 +1674,7 @@ static void handle_control_message(struct ports_device *portdev,
 		break;
 	}
 	case VIRTIO_CONSOLE_PORT_OPEN:
-		port->host_connected = cpkt->value;
+		port->host_connected = virtio16_to_cpu(vdev, cpkt->value);
 		wake_up_interruptible(&port->waitqueue);
 		/*
 		 * If the host port got closed and the host had any
@@ -1752,7 +1756,7 @@ static void control_work_handler(struct work_struct *work)
 		buf->len = len;
 		buf->offset = 0;
 
-		handle_control_message(portdev, buf);
+		handle_control_message(vq->vdev, portdev, buf);
 
 		spin_lock(&portdev->c_ivq_lock);
 		if (add_inbuf(portdev->c_ivq, buf) < 0) {
@@ -2126,6 +2130,7 @@ static struct virtio_device_id id_table[] = {
 static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
 	VIRTIO_CONSOLE_F_MULTIPORT,
+	VIRTIO_F_VERSION_1,
 };
 
 static struct virtio_device_id rproc_serial_id_table[] = {
-- 
MST
