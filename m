From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 35/45] include/uapi/sound/asound.h: include stdlib.h in userspace
Date: Tue, 17 Feb 2015 00:05:38 +0100
Message-ID: <1424127948-22484-36-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compiler errors like:
error: field =E2=80=98trigger_tstamp=E2=80=99 has incomplete type
error: invalid application of =E2=80=98sizeof=E2=80=99 to incomplete t
ype =E2=80=98struct timespec=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/sound/asound.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index 941d32f..af156b0 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -25,6 +25,9 @@
=20
 #include <linux/types.h>
=20
+#ifndef __KERNEL__
+#include <stdlib.h>
+#endif
=20
 /*
  *  protocol version
--=20
2.1.4
