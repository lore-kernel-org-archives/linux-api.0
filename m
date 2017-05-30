From: Manjeet Pawar <manjeet.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] ALSA: Adjust structure(snd_timer_tread) members to avoid 8
 padding bytes
Date: Tue, 30 May 2017 11:49:08 +0530
Message-ID: <1496125148-37895-1-git-send-email-manjeet.p@samsung.com>
References: <CGME20170530062242epcas5p1fb7f94e02c6550a60603ce28090cc70d@epcas5p1.samsung.com>
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: perex-/Fr2/VpizcU@public.gmane.org, tiwai-l3A5Bk7waGM@public.gmane.org, alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: a.sahrawat-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, lalit.mohan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Manjeet Pawar <manjeet.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Vaneet Narang <v.narang-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch is made to fix below CVE issue where 8 padding bytes are sent to
user without being initialized. Structure members are adjusted to avoid 8 
padding bytes.

CVE-2016-4569/CVE-2016-4578:
The stack object tread has a total size of 32 bytes. Its field
event and val both contain 4 bytes padding. These 8 bytes
padding bytes are sent to user without being initialized.

Fix patch:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cec8f96e49d9be372fdb0c3836dcf31ec71e457e
https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git/commit/?h=for-next&id=9a47e9cff994f37f7f0dbd9ae23740d0f64f9fe6

These patches does memset on structure object to initialize 8 padding bytes, which can be skipped by 
adjusting structure members.

Signed-off-by: Manjeet Pawar <manjeet.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Vaneet Narang <v.narang-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 include/uapi/sound/asound.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index a45be6b..820c5a0 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -789,8 +789,8 @@ enum {
 
 struct snd_timer_tread {
 	int event;
-	struct timespec tstamp;
 	unsigned int val;
+	struct timespec tstamp;
 };
 
 /****************************************************************************
-- 
1.9.1
