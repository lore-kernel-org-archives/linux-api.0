From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 04/98] drm_mode.h: use __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:37:56 +0200
Message-ID: <1433000370-19509-5-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

drm/drm_mode.h:472:2: error: unknown type name =E2=80=98uint32_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/drm/drm_mode.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index dbeba94..03e4d75 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -508,14 +508,14 @@ struct drm_mode_crtc_page_flip {
=20
 /* create a dumb scanout buffer */
 struct drm_mode_create_dumb {
-	uint32_t height;
-	uint32_t width;
-	uint32_t bpp;
-	uint32_t flags;
+	__u32 height;
+	__u32 width;
+	__u32 bpp;
+	__u32 flags;
 	/* handle, pitch, size will be returned */
-	uint32_t handle;
-	uint32_t pitch;
-	uint64_t size;
+	__u32 handle;
+	__u32 pitch;
+	__u64 size;
 };
=20
 /* set up for mmap of a dumb scanout buffer */
@@ -532,7 +532,7 @@ struct drm_mode_map_dumb {
 };
=20
 struct drm_mode_destroy_dumb {
-	uint32_t handle;
+	__u32 handle;
 };
=20
 /* page-flip flags are valid, plus: */
--=20
2.1.4
