From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 04/79] drm_mode.h: use __u32 and __u64 from linux/types.h
Date: Thu, 15 Oct 2015 07:55:42 +0200
Message-ID: <1444888618-4506-5-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

drm/drm_mode.h:472:2: error: unknown type name =E2=80=98uint32_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/drm_mode.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index 359107a..0ed8d9d 100644
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
2.5.0
