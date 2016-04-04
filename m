From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 4/8] lib/uuid: remove FSF address
Date: Mon,  4 Apr 2016 16:30:06 +0300
Message-ID: <1459776610-68469-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1459776610-68469-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459776610-68469-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

There is no point to keep an address in the file since it's a subject to
change.

While here, update Intel Copyright years.

Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/uuid.h      | 6 +-----
 include/uapi/linux/uuid.h | 4 ----
 lib/uuid.c                | 6 +-----
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 616347f..115d04b 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -1,7 +1,7 @@
 /*
  * UUID/GUID definition
  *
- * Copyright (C) 2010, Intel Corp.
+ * Copyright (C) 2010, 2016 Intel Corp.
  *	Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
  *
  * This program is free software; you can redistribute it and/or
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #ifndef _LINUX_UUID_H_
 #define _LINUX_UUID_H_
diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 786f077..3738e5f 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #ifndef _UAPI_LINUX_UUID_H_
diff --git a/lib/uuid.c b/lib/uuid.c
index 995865c..0918232 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -1,7 +1,7 @@
 /*
  * Unified UUID/GUID definition
  *
- * Copyright (C) 2009, Intel Corp.
+ * Copyright (C) 2009, 2015 Intel Corp.
  *	Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
  *
  * This program is free software; you can redistribute it and/or
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
 #include <linux/kernel.h>
-- 
2.8.0.rc3
