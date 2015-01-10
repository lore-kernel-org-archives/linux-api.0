From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: [PATCH 2/2] Input: uinput - fix ioctl nr overflow for UI_GET_VERSION
Date: Sat, 10 Jan 2015 13:43:36 +0100
Message-ID: <1420893816-11620-3-git-send-email-gabriel@lse.epita.fr>
References: <1420893816-11620-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420893816-11620-1-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Hutterer <peter.hutterer-Pf4JEFdB4epeoWH0uzbU5w@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Request number for ioctls are encoded on 8bit. Values for are superior
to 255. The effective value is 0x2d. The effective ioctl number is still
the same one, it will not change the api in anyway.

Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
---
 include/uapi/linux/uinput.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
index 358f7d9..e1daf2e 100644
--- a/include/uapi/linux/uinput.h
+++ b/include/uapi/linux/uinput.h
@@ -91,7 +91,7 @@ struct uinput_ff_erase {
  * the integer pointed to by the ioctl argument. The protocol version
  * is hard-coded in the kernel and is independent of the uinput device.
  */
-#define UI_GET_VERSION		_IOR(UINPUT_IOCTL_BASE, 301, unsigned int)
+#define UI_GET_VERSION		_IOR(UINPUT_IOCTL_BASE, 0x2d, unsigned int)
 
 /*
  * To write a force-feedback-capable driver, the upload_effect
-- 
2.2.1
