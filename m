From: Kevin Tsai <ktsai-GubuWUlQtMwciDkP5Hr2oA@public.gmane.org>
Subject: [PATCH 1/1] iio: Add iio_mod_light_uva, iio_mod_light_uvb, and iio_mod_light_uvc.
Date: Fri, 29 May 2015 01:04:43 -0700
Message-ID: <1432886683-7467-1-git-send-email-ktsai@capellamicro.com>
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Reyad Attiyat <reyad.attiyat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kevin Tsai <ktsai-GubuWUlQtMwciDkP5Hr2oA@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add Ultraviolet(UV) support:
UVA: 315 ~ 400 nm
UVB: 280 ~ 315 nm
UVC: 100 ~ 280 nm

Signed-off-by: Kevin Tsai <ktsai-GubuWUlQtMwciDkP5Hr2oA@public.gmane.org>
---
 drivers/iio/industrialio-core.c | 3 +++
 include/uapi/linux/iio/types.h  | 3 +++
 tools/iio/iio_event_monitor.c   | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 3524b0d..ecbdd1e 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -89,6 +89,9 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_LIGHT_RED] = "red",
 	[IIO_MOD_LIGHT_GREEN] = "green",
 	[IIO_MOD_LIGHT_BLUE] = "blue",
+	[IIO_MOD_LIGHT_UVA] = "uva",
+	[IIO_MOD_LIGHT_UVB] = "uvb",
+	[IIO_MOD_LIGHT_UVC] = "uvc",
 	[IIO_MOD_QUATERNION] = "quaternion",
 	[IIO_MOD_TEMP_AMBIENT] = "ambient",
 	[IIO_MOD_TEMP_OBJECT] = "object",
diff --git a/include/uapi/linux/iio/types.h b/include/uapi/linux/iio/types.h
index 2f8b117..5c99090 100644
--- a/include/uapi/linux/iio/types.h
+++ b/include/uapi/linux/iio/types.h
@@ -72,6 +72,9 @@ enum iio_modifier {
 	IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z,
 	IIO_MOD_I,
 	IIO_MOD_Q,
+	IIO_MOD_LIGHT_UVA,
+	IIO_MOD_LIGHT_UVB,
+	IIO_MOD_LIGHT_UVC,
 };
 
 enum iio_event_type {
diff --git a/tools/iio/iio_event_monitor.c b/tools/iio/iio_event_monitor.c
index 427c271..46dd27f 100644
--- a/tools/iio/iio_event_monitor.c
+++ b/tools/iio/iio_event_monitor.c
@@ -88,6 +88,9 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_LIGHT_RED] = "red",
 	[IIO_MOD_LIGHT_GREEN] = "green",
 	[IIO_MOD_LIGHT_BLUE] = "blue",
+	[IIO_MOD_LIGHT_UVA] = "uva",
+	[IIO_MOD_LIGHT_UVB] = "uvb",
+	[IIO_MOD_LIGHT_UVC] = "uvc",
 	[IIO_MOD_QUATERNION] = "quaternion",
 	[IIO_MOD_TEMP_AMBIENT] = "ambient",
 	[IIO_MOD_TEMP_OBJECT] = "object",
@@ -156,6 +159,9 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_MOD_LIGHT_RED:
 	case IIO_MOD_LIGHT_GREEN:
 	case IIO_MOD_LIGHT_BLUE:
+	case IIO_MOD_LIGHT_UVA:
+	case IIO_MOD_LIGHT_UVB:
+	case IIO_MOD_LIGHT_UVC:
 	case IIO_MOD_QUATERNION:
 	case IIO_MOD_TEMP_AMBIENT:
 	case IIO_MOD_TEMP_OBJECT:
-- 
1.8.3.1
