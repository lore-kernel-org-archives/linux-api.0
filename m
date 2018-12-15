From: Martin Hostettler <textshell@uchuujin.de>
Subject: [PATCH 3/4] vt: ignore csi sequences with intermediate characters.
Date: Sat, 15 Dec 2018 15:34:22 +0100
Message-ID: <20181215143423.4556-4-textshell@uchuujin.de>
References: <20181215143423.4556-1-textshell@uchuujin.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181215143423.4556-1-textshell@uchuujin.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>, Adam Borowski <kilobyte@angband.pl>, Egmont Koblinger <egmont@gmail.com>, Martin Hostettler <textshell@uchuujin.de>
List-Id: linux-api@vger.kernel.org

Various csi sequences contain intermediate characters between the
parameters and the final character. Introduce a additional state that
cleanly ignores these sequences.

This allows the vt to ignore these sequences used by more capable
terminal implementations such as "request mode", etc.

Signed-off-by: Martin Hostettler <textshell@uchuujin.de>
---
 drivers/tty/vt/vt.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 448b4f6be7d1..24cd0e9c037b 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2023,7 +2023,7 @@ static void restore_cur(struct vc_data *vc)
 }
 
 enum { ESnormal, ESesc, ESsquare, ESgetpars, ESfunckey,
-	EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
+	EShash, ESsetG0, ESsetG1, ESpercent, EScsiignore, ESnonstd,
 	ESpalette, ESosc };
 
 /* console_lock is held (except via vc_init()) */
@@ -2259,6 +2259,10 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_par[vc->vc_npar] += c - '0';
 			return;
 		}
+		if (c >= 0x20 && c <= 0x2f) {
+			vc->vc_state = EScsiignore;
+			return;
+		}
 		vc->vc_state = ESnormal;
 		switch(c) {
 		case 'h':
@@ -2421,6 +2425,11 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			return;
 		}
 		return;
+	case EScsiignore:
+		if (c >= 20 && c <= 0x3f)
+			return;
+		vc->vc_state = ESnormal;
+		return;
 	case ESpercent:
 		vc->vc_state = ESnormal;
 		switch (c) {
-- 
2.11.0
