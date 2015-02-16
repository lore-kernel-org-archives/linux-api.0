From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 14/45] sis_drm.h: hide sis_file_private in userspace
Date: Tue, 17 Feb 2015 00:05:17 +0100
Message-ID: <1424127948-22484-15-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compiler error:

drm/sis_drm.h:68:19: error: field =E2=80=98obj_list=E2=80=99 has incomp=
lete type
  struct list_head obj_list;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/sis_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/sis_drm.h b/include/uapi/drm/sis_drm.h
index df37632..3d0903f 100644
--- a/include/uapi/drm/sis_drm.h
+++ b/include/uapi/drm/sis_drm.h
@@ -64,8 +64,10 @@ typedef struct {
 	unsigned long offset, size;
 } drm_sis_fb_t;
=20
+#ifdef __KERNEL__
 struct sis_file_private {
 	struct list_head obj_list;
 };
+#endif
=20
 #endif				/* __SIS_DRM_H__ */
--=20
2.1.4
