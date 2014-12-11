From: Jarkko Nikula <jarkko.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 4/4] sound: oss: Remove dead sound card number definitions part #2
Date: Thu, 11 Dec 2014 14:19:13 +0200
Message-ID: <1418300353-13243-4-git-send-email-jarkko.nikula@linux.intel.com>
References: <1418300353-13243-1-git-send-email-jarkko.nikula@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418300353-13243-1-git-send-email-jarkko.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org
Cc: Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Jarkko Nikula <jarkko.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

None of these is used in kernel tree.

Signed-off-by: Jarkko Nikula <jarkko.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
RFC, I don't know can these be used in user-space?
---
 include/uapi/linux/soundcard.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/include/uapi/linux/soundcard.h b/include/uapi/linux/soundcard.h
index f3b21f989872..d2256bf4bdd8 100644
--- a/include/uapi/linux/soundcard.h
+++ b/include/uapi/linux/soundcard.h
@@ -48,32 +48,10 @@
  *	Supported card ID numbers (Should be somewhere else?)
  */
 
-#define SNDCARD_ADLIB		1
 #define SNDCARD_SB		2
 #define SNDCARD_PAS		3
-#define SNDCARD_GUS		4
 #define SNDCARD_MPU401		5
-#define SNDCARD_SB16		6
-#define SNDCARD_SB16MIDI	7
 #define SNDCARD_UART6850	8
-#define SNDCARD_GUS16		9
-#define SNDCARD_MSS		10
-#define SNDCARD_PSS     	11
-#define SNDCARD_SSCAPE		12
-#define SNDCARD_PSS_MPU     	13
-#define SNDCARD_PSS_MSS     	14
-#define SNDCARD_SSCAPE_MSS	15
-#define SNDCARD_TRXPRO		16
-#define SNDCARD_TRXPRO_SB	17
-#define SNDCARD_TRXPRO_MPU	18
-#define SNDCARD_MAD16		19
-#define SNDCARD_MAD16_MPU	20
-#define SNDCARD_CS4232		21
-#define SNDCARD_CS4232_MPU	22
-#define SNDCARD_MAUI		23
-#define SNDCARD_PSEUDO_MSS	24
-#define SNDCARD_GUSPNP		25
-#define SNDCARD_UART401		26
 /* Sound card numbers 27 to N are reserved. Don't add more numbers here. */
 
 /***********************************
-- 
2.1.3
