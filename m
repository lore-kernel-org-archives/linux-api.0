From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: [PATCH 1/2] Input: uinput - fix ioctl nr overflow for UI_GET_SYSNAME
Date: Sat, 10 Jan 2015 13:43:35 +0100
Message-ID: <1420893816-11620-2-git-send-email-gabriel@lse.epita.fr>
References: <1420893816-11620-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420893816-11620-1-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Hutterer <peter.hutterer-Pf4JEFdB4epeoWH0uzbU5w@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Request number for ioctls are encoded on 8bit. Values for are superior
to 255. The effective value is 0x2c. The effective ioctl number is still
the same one, it will not change the api in anyway.

Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
---
 include/uapi/linux/uinput.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/uinput.h b/include/uapi/linux/uinput.h
index baeab83..358f7d9 100644
--- a/include/uapi/linux/uinput.h
+++ b/include/uapi/linux/uinput.h
@@ -82,7 +82,7 @@ struct uinput_ff_erase {
  * The complete sysfs path is then /sys/devices/virtual/input/--NAME--
  * Usually, it is in the form "inputN"
  */
-#define UI_GET_SYSNAME(len)	_IOC(_IOC_READ, UINPUT_IOCTL_BASE, 300, len)
+#define UI_GET_SYSNAME(len)	_IOC(_IOC_READ, UINPUT_IOCTL_BASE, 0x2c, len)
 
 /**
  * UI_GET_VERSION - Return version of uinput protocol
-- 
2.2.1
