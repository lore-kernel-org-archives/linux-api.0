From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH] [media] uapi/media.h: Use u32 for the number of graph objects
Date: Thu, 17 Dec 2015 09:09:21 -0200
Message-ID: <40e950dbb6a3b7f73da52e147fa51441b762131a.1450350558.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

While we need to keep a u64 alignment to avoid compat32 issues,
having the number of entities/pads/links/interfaces represented
by an u64 is incoherent with the ID number, with is an u32.

In order to make it coherent, change those quantities to u32.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---
 include/uapi/linux/media.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index cacfceb0d81d..5dbb208e5451 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -330,16 +330,20 @@ struct media_v2_link {
 struct media_v2_topology {
 	__u64 topology_version;
 
-	__u64 num_entities;
+	__u32 num_entities;
+	__u32 reserved1;
 	__u64 ptr_entities;
 
-	__u64 num_interfaces;
+	__u32 num_interfaces;
+	__u32 reserved2;
 	__u64 ptr_interfaces;
 
-	__u64 num_pads;
+	__u32 num_pads;
+	__u32 reserved3;
 	__u64 ptr_pads;
 
-	__u64 num_links;
+	__u32 num_links;
+	__u32 reserved4;
 	__u64 ptr_links;
 };
 
-- 
2.5.0
