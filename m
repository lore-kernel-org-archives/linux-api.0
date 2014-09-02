From: Zhuang Jin Can <jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] usb: gadget: f_fs: add usb_functionfs_descs_head_v2
Date: Tue, 2 Sep 2014 14:58:36 +0800
Message-ID: <20140902065836.GA23094@intel.com>
Reply-To: jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org, balbi-l0cyMroinI0@public.gmane.org, mgautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org
Cc: jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david.a.cohen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hang.yuan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add usb_functionfs_descs_head_v2 structure for the new layout of
descriptors.

Signed-off-by: Zhuang Jin Can <jin.can.zhuang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/uapi/linux/usb/functionfs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 0154b28..0b3f9fc 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -32,6 +32,15 @@ struct usb_endpoint_descriptor_no_audio {
 	__u8  bInterval;
 } __attribute__((packed));
 
+struct usb_functionfs_descs_head_v2 {
+	__le32 magic;
+	__le32 length;
+	__le32 flags;
+	__le32 fs_count;
+	__le32 hs_count;
+	__le32 ss_count;
+} __attribute__((packed));
+
 /* Legacy format, deprecated as of 3.14. */
 struct usb_functionfs_descs_head {
 	__le32 magic;
-- 
1.7.9.5
