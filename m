From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH RFC] [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
Date: Mon, 28 Dec 2015 12:03:47 -0200
Message-ID: <d029047c76d6d3e5e6a531080ede83f6e063f7db.1451311244.git.mchehab@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Javier Martinez Canillas <javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Sakari Ailus <sakari.ailus-X3B1VOXEql0@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There are a few discussions left with regards to this ioctl:

1) the name of the new structs will contain _v2_ on it?
2) what's the best alternative to avoid compat32 issues?

Due to that, let's postpone the addition of this new ioctl to
the next Kernel version, to give people more time to discuss it.

Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
---

Resending the patch, as the first one were sent to the wrong ML. Also, add the
relevant parties to the Cc of thiis patch.

 Documentation/DocBook/media/v4l/media-ioc-g-topology.xml | 3 +++
 drivers/media/media-device.c                             | 5 ++++-
 include/uapi/linux/media.h                               | 6 +++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml b/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
index e0d49fa329f0..63152ab9efba 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-g-topology.xml
@@ -48,6 +48,9 @@
 
   <refsect1>
     <title>Description</title>
+
+    <para><emphasis role="bold">NOTE:</emphasis> This new ioctl is programmed to be added on Kernel 4.6. Its definition/arguments may change until its final version.</para>
+
     <para>The typical usage of this ioctl is to call it twice.
     On the first call, the structure defined at &media-v2-topology; should
     be zeroed. At return, if no errors happen, this ioctl will return the
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 4d1c13de494b..900124c04e9a 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -234,6 +234,7 @@ static long media_device_setup_link(struct media_device *mdev,
 	return ret;
 }
 
+#if 0 /* Let's postpone it to Kernel 4.6 */
 static long __media_device_get_topology(struct media_device *mdev,
 				      struct media_v2_topology *topo)
 {
@@ -389,6 +390,7 @@ static long media_device_get_topology(struct media_device *mdev,
 
 	return 0;
 }
+#endif
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
@@ -422,13 +424,14 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		mutex_unlock(&dev->graph_mutex);
 		break;
 
+#if 0 /* Let's postpone it to Kernel 4.6 */
 	case MEDIA_IOC_G_TOPOLOGY:
 		mutex_lock(&dev->graph_mutex);
 		ret = media_device_get_topology(dev,
 				(struct media_v2_topology __user *)arg);
 		mutex_unlock(&dev->graph_mutex);
 		break;
-
+#endif
 	default:
 		ret = -ENOIOCTLCMD;
 	}
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 5dbb208e5451..1e3c8cb43bd7 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -286,7 +286,7 @@ struct media_links_enum {
  *	  later, before the adding this API upstream.
  */
 
-
+#if 0 /* Let's postpone it to Kernel 4.6 */
 struct media_v2_entity {
 	__u32 id;
 	char name[64];		/* FIXME: move to a property? (RFC says so) */
@@ -351,6 +351,7 @@ static inline void __user *media_get_uptr(__u64 arg)
 {
 	return (void __user *)(uintptr_t)arg;
 }
+#endif
 
 /* ioctls */
 
@@ -358,6 +359,9 @@ static inline void __user *media_get_uptr(__u64 arg)
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
 #define MEDIA_IOC_SETUP_LINK		_IOWR('|', 0x03, struct media_link_desc)
+
+#if 0 /* Let's postpone it to Kernel 4.6 */
 #define MEDIA_IOC_G_TOPOLOGY		_IOWR('|', 0x04, struct media_v2_topology)
+#endif
 
 #endif /* __LINUX_MEDIA_H */
-- 
2.5.0
