From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 12/98] sis_drm.h: hide sis_file_private in userspace
Date: Sat, 30 May 2015 17:38:04 +0200
Message-ID: <1433000370-19509-13-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes compiler error:

drm/sis_drm.h:68:19: error: field =E2=80=98obj_list=E2=80=99 has incomp=
lete type
  struct list_head obj_list;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
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
