From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 7/9] HSI: cmt_speech: Move cs-protocol.h to include/uapi/linux/hsi
Date: Mon,  2 Mar 2015 05:38:57 +0100
Message-ID: <1425271139-24715-8-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Move cs-protocol.h to include/uapi/linux/hsi, since it
describes a userspace API.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c                | 2 +-
 include/uapi/linux/hsi/Kbuild                   | 2 +-
 include/{linux => uapi/linux/hsi}/cs-protocol.h | 5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)
 rename include/{linux => uapi/linux/hsi}/cs-protocol.h (96%)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 52001ed..69dc37f 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -37,7 +37,7 @@
 #include <linux/pm_qos.h>
 #include <linux/hsi/hsi.h>
 #include <linux/hsi/ssi_protocol.h>
-#include <linux/cs-protocol.h>
+#include <linux/hsi/cs-protocol.h>
 
 #define CS_MMAP_SIZE	PAGE_SIZE
 
diff --git a/include/uapi/linux/hsi/Kbuild b/include/uapi/linux/hsi/Kbuild
index 30ab3cd..a16a005 100644
--- a/include/uapi/linux/hsi/Kbuild
+++ b/include/uapi/linux/hsi/Kbuild
@@ -1,2 +1,2 @@
 # UAPI Header export list
-header-y += hsi_char.h
+header-y += hsi_char.h cs-protocol.h
diff --git a/include/linux/cs-protocol.h b/include/uapi/linux/hsi/cs-protocol.h
similarity index 96%
rename from include/linux/cs-protocol.h
rename to include/uapi/linux/hsi/cs-protocol.h
index 0d3d584..4957bba 100644
--- a/include/linux/cs-protocol.h
+++ b/include/uapi/linux/hsi/cs-protocol.h
@@ -1,8 +1,5 @@
 /*
- * include/linux/cs-protocol.h - cmt_speech interface definitions
- *
- * Implemented by:
- * - drivers/misc/cmt-speech/
+ * cmt-speech interface definitions
  *
  * Copyright (C) 2008,2009,2010 Nokia Corporation. All rights reserved.
  *
-- 
2.1.4
