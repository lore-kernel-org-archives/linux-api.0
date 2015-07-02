From: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RESEND] virtio: Fix typecast of pointer in vring_init()
Date: Thu,  2 Jul 2015 09:21:22 +0200
Message-ID: <1435821682-1809-1-git-send-email-thuth@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The virtio_ring.h header is used in userspace programs (ie. QEMU),
too. Here we can not assume that sizeof(pointer) is the same as
sizeof(long), e.g. when compiling for Windows, so the typecast in
vring_init() should be done with (uintptr_t) instead of (unsigned long).

Signed-off-by: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/uapi/linux/virtio_ring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index 915980a..8682551 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -143,7 +143,7 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + sizeof(__virtio16)
+	vr->used = (void *)(((uintptr_t)&vr->avail->ring[num] + sizeof(__virtio16)
 		+ align-1) & ~(align - 1));
 }
 
-- 
1.8.3.1
