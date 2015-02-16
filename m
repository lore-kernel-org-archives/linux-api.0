From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 39/45] include/uapi/sound/asequencer.h: include sound/asound.h
Date: Tue, 17 Feb 2015 00:05:42 +0100
Message-ID: <1424127948-22484-40-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:
error: unknown type name =E2=80=98snd_seq_client_type_t=E2=80=99
snd_seq_client_type_t type; /* client type */

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/sound/asequencer.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/sound/asequencer.h b/include/uapi/sound/asequ=
encer.h
index 09c8a00..5a5fa49 100644
--- a/include/uapi/sound/asequencer.h
+++ b/include/uapi/sound/asequencer.h
@@ -22,6 +22,7 @@
 #ifndef _UAPI__SOUND_ASEQUENCER_H
 #define _UAPI__SOUND_ASEQUENCER_H
=20
+#include <sound/asound.h>
=20
 /** version of the sequencer */
 #define SNDRV_SEQ_VERSION SNDRV_PROTOCOL_VERSION (1, 0, 1)
--=20
2.1.4
