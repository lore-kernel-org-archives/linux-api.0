From: Martin Hostettler <textshell@uchuujin.de>
Subject: [PATCH 1/4] vt: refactor vc_ques to allow of other private sequences.
Date: Sat, 15 Dec 2018 15:34:20 +0100
Message-ID: <20181215143423.4556-2-textshell@uchuujin.de>
References: <20181215143423.4556-1-textshell@uchuujin.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181215143423.4556-1-textshell@uchuujin.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>, Adam Borowski <kilobyte@angband.pl>, Egmont Koblinger <egmont@gmail.com>, Martin Hostettler <textshell@uchuujin.de>
List-Id: linux-api@vger.kernel.org

The vc_ques keeps track if a csi sequence is a private DEC control
function beginning with '?'. Nowadays some private control functions
begin with '>' and '='. Switch the code to instead use a new 3-bit
vc_priv that allows for all private use parameter prefixes.

Signed-off-by: Martin Hostettler <textshell@uchuujin.de>
---
 drivers/tty/vt/vt.c            | 20 +++++++++++---------
 include/linux/console_struct.h |  2 +-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 41ec8e5010f3..75826a97b0c3 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1341,6 +1341,8 @@ struct vc_data *vc_deallocate(unsigned int currcons)
  *	VT102 emulator
  */
 
+enum { EPecma = 0, EPdec, EPeq, EPgt, EPlt};
+
 #define set_kbd(vc, x)	vt_set_kbd_mode_bit((vc)->vc_num, (x))
 #define clr_kbd(vc, x)	vt_clr_kbd_mode_bit((vc)->vc_num, (x))
 #define is_kbd(vc, x)	vt_get_kbd_mode_bit((vc)->vc_num, (x))
@@ -1814,7 +1816,7 @@ static void set_mode(struct vc_data *vc, int on_off)
 	int i;
 
 	for (i = 0; i <= vc->vc_npar; i++)
-		if (vc->vc_ques) {
+		if (vc->vc_priv == EPdec) {
 			switch(vc->vc_par[i]) {	/* DEC private modes set/reset */
 			case 1:			/* Cursor keys send ^[Ox/^[[x */
 				if (on_off)
@@ -2030,7 +2032,7 @@ static void reset_terminal(struct vc_data *vc, int do_clear)
 	vc->vc_top		= 0;
 	vc->vc_bottom		= vc->vc_rows;
 	vc->vc_state		= ESnormal;
-	vc->vc_ques		= 0;
+	vc->vc_priv		= EPecma;
 	vc->vc_translate	= set_translate(LAT1_MAP, vc);
 	vc->vc_G0_charset	= LAT1_MAP;
 	vc->vc_G1_charset	= GRAF_MAP;
@@ -2233,8 +2235,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_state=ESfunckey;
 			return;
 		}
-		vc->vc_ques = (c == '?');
-		if (vc->vc_ques)
+		vc->vc_priv = (c == '?') ? EPdec : EPecma;
+		if (vc->vc_priv != EPecma)
 			return;
 	case ESgetpars:
 		if (c == ';' && vc->vc_npar < NPAR - 1) {
@@ -2254,7 +2256,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			set_mode(vc, 0);
 			return;
 		case 'c':
-			if (vc->vc_ques) {
+			if (vc->vc_priv == EPdec) {
 				if (vc->vc_par[0])
 					vc->vc_cursor_type = vc->vc_par[0] | (vc->vc_par[1] << 8) | (vc->vc_par[2] << 16);
 				else
@@ -2263,7 +2265,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			}
 			break;
 		case 'm':
-			if (vc->vc_ques) {
+			if (vc->vc_priv == EPdec) {
 				clear_selection();
 				if (vc->vc_par[0])
 					vc->vc_complement_mask = vc->vc_par[0] << 8 | vc->vc_par[1];
@@ -2273,7 +2275,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			}
 			break;
 		case 'n':
-			if (!vc->vc_ques) {
+			if (vc->vc_priv == EPecma) {
 				if (vc->vc_par[0] == 5)
 					status_report(tty);
 				else if (vc->vc_par[0] == 6)
@@ -2281,8 +2283,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			}
 			return;
 		}
-		if (vc->vc_ques) {
-			vc->vc_ques = 0;
+		if (vc->vc_priv != EPecma) {
+			vc->vc_priv = EPecma;
 			return;
 		}
 		switch(c) {
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index ab137f97ecbd..ed798e114663 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -119,7 +119,7 @@ struct vc_data {
 	unsigned int	vc_s_blink	: 1;
 	unsigned int	vc_s_reverse	: 1;
 	/* misc */
-	unsigned int	vc_ques		: 1;
+	unsigned int	vc_priv		: 3;
 	unsigned int	vc_need_wrap	: 1;
 	unsigned int	vc_can_do_color	: 1;
 	unsigned int	vc_report_mouse : 2;
-- 
2.11.0
