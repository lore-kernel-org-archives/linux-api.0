From: Martin Hostettler <textshell@uchuujin.de>
Subject: [PATCH 4/4] vt: ignore sequences that contain ':' in parameters.
Date: Sat, 15 Dec 2018 15:34:23 +0100
Message-ID: <20181215143423.4556-5-textshell@uchuujin.de>
References: <20181215143423.4556-1-textshell@uchuujin.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181215143423.4556-1-textshell@uchuujin.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>, Adam Borowski <kilobyte@angband.pl>, Egmont Koblinger <egmont@gmail.com>, Martin Hostettler <textshell@uchuujin.de>
List-Id: linux-api@vger.kernel.org

csi sequences can contain subparameters delimited by ':' characters. For
now just ignore the whole sequence in this case. Such sequences are used by
more capable terminal implementations with T.416 high color modes or
extended underline rendition attributes.

Also ignore sequences with private use characters '?', '>', '='
and '>' that are not at the initial position.

Signed-off-by: Martin Hostettler <textshell@uchuujin.de>
---
 drivers/tty/vt/vt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 24cd0e9c037b..0aaa15c723fa 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1629,9 +1629,9 @@ static void rgb_background(struct vc_data *vc, const struct rgb *c)
 
 /*
  * ITU T.416 Higher colour modes. They break the usual properties of SGR codes
- * and thus need to be detected and ignored by hand. Strictly speaking, that
- * standard also wants : rather than ; as separators, contrary to ECMA-48, but
- * no one produces such codes and almost no one accepts them.
+ * and thus need to be detected and ignored by hand. That standard also
+ * wants : rather than ; as separators but sequences containing : are currently
+ * completely ignored by the parser.
  *
  * Subcommands 3 (CMY) and 4 (CMYK) are so insane there's no point in
  * supporting them.
@@ -2259,7 +2259,7 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_par[vc->vc_npar] += c - '0';
 			return;
 		}
-		if (c >= 0x20 && c <= 0x2f) {
+		if (c >= 0x20 && c <= 0x3f) { /* 0x2x, 0x3a and 0x3c - 0x3f */
 			vc->vc_state = EScsiignore;
 			return;
 		}
-- 
2.11.0
