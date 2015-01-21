From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH pre-squash 03/14] fixup! virtio-pci: define layout for virtio
 1.0
Date: Wed, 21 Jan 2015 17:00:13 +0200
Message-ID: <1421852375-22604-4-git-send-email-mst@redhat.com>
References: <1421852375-22604-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421852375-22604-1-git-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

virtio-pci: fix up virtio 1.0 vendor capability

Gerd Hoffmann noticed that we implemented
capability layout from an old draft.
Unfortunately the code was copied to host as well,
so we didn't notice.

Luckily we caught this in time.

This fixes commit "virtio-pci: define layout for virtio 1.0"
and should be smashed with it.

Reported-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/virtio_pci.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 4e05423..a2b2e13 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -117,10 +117,11 @@ struct virtio_pci_cap {
 	__u8 cap_vndr;		/* Generic PCI field: PCI_CAP_ID_VNDR */
 	__u8 cap_next;		/* Generic PCI field: next ptr. */
 	__u8 cap_len;		/* Generic PCI field: capability length */
-	__u8 type_and_bar;	/* Upper 3 bits: bar.
-				 * Lower 3 is VIRTIO_PCI_CAP_*_CFG. */
+	__u8 cfg_type;		/* Identifies the structure. */
+	__u8 bar;		/* Where to find it. */
+	__u8 padding[3];	/* Pad to full dword. */
 	__le32 offset;		/* Offset within bar. */
-	__le32 length;		/* Length. */
+	__le32 length;		/* Length of the structure, in bytes. */
 };
 
 #define VIRTIO_PCI_CAP_BAR_SHIFT	5
-- 
MST
