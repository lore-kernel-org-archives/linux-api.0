From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 12/79] include/uapi/drm/sis_drm.h: move sis_file_private to drivers/gpu/drm/sis/sis_drv.h
Date: Thu, 15 Oct 2015 07:55:50 +0200
Message-ID: <1444888618-4506-13-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile error:

drm/sis_drm.h:68:19: error: field =E2=80=98obj_list=E2=80=99 has incomp=
lete type
  struct list_head obj_list;

Suggested by Emil Velikov <emil.l.velikov@gmail.com> at
https://lkml.org/lkml/2015/6/3/792

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 drivers/gpu/drm/sis/sis_drv.h | 4 ++++
 include/uapi/drm/sis_drm.h    | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/sis/sis_drv.h b/drivers/gpu/drm/sis/sis_dr=
v.h
index 16f972b..328f8a7 100644
--- a/drivers/gpu/drm/sis/sis_drv.h
+++ b/drivers/gpu/drm/sis/sis_drv.h
@@ -67,6 +67,10 @@ typedef struct drm_sis_private {
 	struct idr object_idr;
 } drm_sis_private_t;
=20
+struct sis_file_private {
+	struct list_head obj_list;
+};
+
 extern int sis_idle(struct drm_device *dev);
 extern void sis_reclaim_buffers_locked(struct drm_device *dev,
 				       struct drm_file *file_priv);
diff --git a/include/uapi/drm/sis_drm.h b/include/uapi/drm/sis_drm.h
index df37632..374858c 100644
--- a/include/uapi/drm/sis_drm.h
+++ b/include/uapi/drm/sis_drm.h
@@ -64,8 +64,4 @@ typedef struct {
 	unsigned long offset, size;
 } drm_sis_fb_t;
=20
-struct sis_file_private {
-	struct list_head obj_list;
-};
-
 #endif				/* __SIS_DRM_H__ */
--=20
2.5.0
