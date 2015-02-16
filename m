From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 24/45] hdspm.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:27 +0100
Message-ID: <1424127948-22484-25-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes compilation error:

sound/hdspm.h:43:2: error: unknown type name =E2=80=98uint32_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/sound/hdspm.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/sound/hdspm.h b/include/uapi/sound/hdspm.h
index d956c35..f799828 100644
--- a/include/uapi/sound/hdspm.h
+++ b/include/uapi/sound/hdspm.h
@@ -20,6 +20,12 @@
  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 /* Maximum channels is 64 even on 56Mode you have 64playbacks to matri=
x */
 #define HDSPM_MAX_CHANNELS      64
=20
--=20
2.1.4
