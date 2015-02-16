From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 09/45] radeon_drm.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:12 +0100
Message-ID: <1424127948-22484-10-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compiler error:

drm/radeon_drm.h:794:2: error: unknown type name =E2=80=98uint64_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/radeon_drm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/drm/radeon_drm.h b/include/uapi/drm/radeon_dr=
m.h
index 50d0fb4..4d8ed03 100644
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -33,6 +33,11 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
 #include <drm/drm.h>
=20
 /* WARNING: If you change any of these defines, make sure to change th=
e
--=20
2.1.4
