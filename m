From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 40/45] include/uapi/sound/emu10k1.h: include sound/asound.h
Date: Tue, 17 Feb 2015 00:05:43 +0100
Message-ID: <1424127948-22484-41-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation errors like:
error: field =E2=80=98id=E2=80=99 has incomplete type
struct snd_ctl_elem_id id;  /* full control ID definition */

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/sound/emu10k1.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/uapi/sound/emu10k1.h b/include/uapi/sound/emu10k1.=
h
index d1bbaf7..ec1535b 100644
--- a/include/uapi/sound/emu10k1.h
+++ b/include/uapi/sound/emu10k1.h
@@ -23,8 +23,7 @@
 #define _UAPI__SOUND_EMU10K1_H
=20
 #include <linux/types.h>
-
-
+#include <sound/asound.h>
=20
 /*
  * ---- FX8010 ----
--=20
2.1.4
