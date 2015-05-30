From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 03/98] drm.h: use __kernel_size_t instead of size_t
Date: Sat, 30 May 2015 17:37:55 +0200
Message-ID: <1433000370-19509-4-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

drm/drm.h:132:2: error: unknown type name =E2=80=98size_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/drm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index ff6ef62..b197650 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -129,11 +129,11 @@ struct drm_version {
 	int version_major;	  /**< Major version */
 	int version_minor;	  /**< Minor version */
 	int version_patchlevel;	  /**< Patch level */
-	size_t name_len;	  /**< Length of name buffer */
+	__kernel_size_t name_len;	  /**< Length of name buffer */
 	char __user *name;	  /**< Name of driver */
-	size_t date_len;	  /**< Length of date buffer */
+	__kernel_size_t date_len;	  /**< Length of date buffer */
 	char __user *date;	  /**< User-space buffer to hold date */
-	size_t desc_len;	  /**< Length of desc buffer */
+	__kernel_size_t desc_len;	  /**< Length of desc buffer */
 	char __user *desc;	  /**< User-space buffer to hold desc */
 };
=20
@@ -143,7 +143,7 @@ struct drm_version {
  * \sa drmGetBusid() and drmSetBusId().
  */
 struct drm_unique {
-	size_t unique_len;	  /**< Length of unique */
+	__kernel_size_t unique_len;	  /**< Length of unique */
 	char __user *unique;	  /**< Unique name for driver instantiation */
 };
=20
--=20
2.1.4
