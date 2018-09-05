From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/11] UAPI: virtio_net: Fix use of C++ keywords as
 structural members
Date: Wed, 05 Sep 2018 16:54:55 +0100
Message-ID: <153616289529.23468.7498785670556620808.stgit@warthog.procyon.org.uk>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-api@vger.kernel.org

The virtio_net_ctrl_hdr struct uses a C++ keyword as structural members.  Fix
this by inserting an anonymous union that provides an alternative name and
then hide the reserved name in C++.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>
cc: Jason Wang <jasowang@redhat.com>
cc: virtualization@lists.linux-foundation.org
---

 include/uapi/linux/virtio_net.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index a3715a3224c1..967142bc0e05 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -150,7 +150,12 @@ struct virtio_net_hdr_mrg_rxbuf {
  * command goes in between.
  */
 struct virtio_net_ctrl_hdr {
-	__u8 class;
+	union {
+#ifndef __cplusplus
+		__u8 class;
+#endif
+		__u8 _class;
+	};
 	__u8 cmd;
 } __attribute__((packed));
 
