From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v8 13/55] [media] uapi/media.h: Declare interface types for V4L2 and DVB
Date: Sun, 30 Aug 2015 00:06:24 -0300
Message-ID: <4bf60081a6756f559407052aa92e343456697a08.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Declare the interface types that will be used by the new
G_TOPOLOGY ioctl that will be defined latter on.

For now, we need those types, as they'll be used on the
internal structs associated with the new media_interface
graph object defined on the next patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 4e816be3de39..3ad3d6be293f 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -167,6 +167,27 @@ struct media_links_enum {
 	__u32 reserved[4];
 };
 
+/* Interface type ranges */
+
+#define MEDIA_INTF_T_DVB_BASE	0x00000100
+#define MEDIA_INTF_T_V4L_BASE	0x00000200
+
+/* Interface types */
+
+#define MEDIA_INTF_T_DVB_FE    	(MEDIA_INTF_T_DVB_BASE)
+#define MEDIA_INTF_T_DVB_DEMUX  (MEDIA_INTF_T_DVB_BASE + 1)
+#define MEDIA_INTF_T_DVB_DVR    (MEDIA_INTF_T_DVB_BASE + 2)
+#define MEDIA_INTF_T_DVB_CA     (MEDIA_INTF_T_DVB_BASE + 3)
+#define MEDIA_INTF_T_DVB_NET    (MEDIA_INTF_T_DVB_BASE + 4)
+
+#define MEDIA_INTF_T_V4L_VIDEO  (MEDIA_INTF_T_V4L_BASE)
+#define MEDIA_INTF_T_V4L_VBI    (MEDIA_INTF_T_V4L_BASE + 1)
+#define MEDIA_INTF_T_V4L_RADIO  (MEDIA_INTF_T_V4L_BASE + 2)
+#define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
+#define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
+
+/* TBD: declare the structs needed for the new G_TOPOLOGY ioctl */
+
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
-- 
2.4.3
