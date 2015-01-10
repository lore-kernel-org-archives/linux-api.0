From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: [PATCH 0/2] Input: uinput - fix ioctl numbers in uapi/uinput.h
Date: Sat, 10 Jan 2015 13:43:34 +0100
Message-ID: <1420893816-11620-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Hutterer <peter.hutterer-Pf4JEFdB4epeoWH0uzbU5w@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Ioctls numbers for UI_GET_SYSNAME and UI_GET_VERSION are incorrectly numbered,
since nr number is 8bit encoded, 300 and 301 will effectively get 44 and 45.
these two patches fixes this

Gabriel Laskar (2):
  Input: uinput - fix ioctl nr overflow for UI_GET_SYSNAME
  Input: uinput - fix ioctl nr overflow for UI_GET_VERSION

 include/uapi/linux/uinput.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.2.1
