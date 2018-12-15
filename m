From: Martin Hostettler <textshell@uchuujin.de>
Subject: [PATCH 2/4] vt: Implement parsing for >, =, < private sequences.
Date: Sat, 15 Dec 2018 15:34:21 +0100
Message-ID: <20181215143423.4556-3-textshell@uchuujin.de>
References: <20181215143423.4556-1-textshell@uchuujin.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181215143423.4556-1-textshell@uchuujin.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>, Adam Borowski <kilobyte@angband.pl>, Egmont Koblinger <egmont@gmail.com>, Martin Hostettler <textshell@uchuujin.de>
List-Id: linux-api@vger.kernel.org

Private sequences can start with '>', '=' and (in theory) '<'.
Implement correct parsing for these. The newly parsable sequences are
cleanly ignored as it is customary with terminal emulators.

This allows the vt to ignore various sequences used by more capable
terminal implementations such as "Secondary Device Attributes",
"Tertiary Device Attributes" and various advanced configuration commands
that don't have dedicated terminfo entries.

Signed-off-by: Martin Hostettler <textshell@uchuujin.de>
---
 drivers/tty/vt/vt.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 75826a97b0c3..448b4f6be7d1 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2235,9 +2235,21 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_state=ESfunckey;
 			return;
 		}
-		vc->vc_priv = (c == '?') ? EPdec : EPecma;
-		if (vc->vc_priv != EPecma)
+		switch (c) {
+		case '?':
+			vc->vc_priv = EPdec;
+			return;
+		case '>':
+			vc->vc_priv = EPgt;
+			return;
+		case '=':
+			vc->vc_priv = EPeq;
 			return;
+		case '<':
+			vc->vc_priv = EPlt;
+			return;
+		}
+		vc->vc_priv = EPecma;
 	case ESgetpars:
 		if (c == ';' && vc->vc_npar < NPAR - 1) {
 			vc->vc_npar++;
@@ -2250,10 +2262,12 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 		vc->vc_state = ESnormal;
 		switch(c) {
 		case 'h':
-			set_mode(vc, 1);
+			if (vc->vc_priv <= EPdec)
+				set_mode(vc, 1);
 			return;
 		case 'l':
-			set_mode(vc, 0);
+			if (vc->vc_priv <= EPdec)
+				set_mode(vc, 0);
 			return;
 		case 'c':
 			if (vc->vc_priv == EPdec) {
-- 
2.11.0
