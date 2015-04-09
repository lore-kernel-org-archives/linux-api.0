From: Sergei Zviagintsev <sergei@s15v.net>
Subject: [PATCH] kdbus: uapi: Fix kernel-doc for enum kdbus_send_flags
Date: Thu,  9 Apr 2015 13:11:01 +0300
Message-ID: <1428574261-18624-1-git-send-email-sergei@s15v.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Sergei Zviagintsev <sergei@s15v.net>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Sergei Zviagintsev <sergei@s15v.net>
---
 include/uapi/linux/kdbus.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/kdbus.h b/include/uapi/linux/kdbus.h
index 2fe0a1c5056c..00a6e142c977 100644
--- a/include/uapi/linux/kdbus.h
+++ b/include/uapi/linux/kdbus.h
@@ -544,7 +544,7 @@ struct kdbus_msg_info {
  *				reply to this message. The
  *				KDBUS_CMD_SEND ioctl() will block
  *				until the reply is received, and
- *				offset_reply in struct kdbus_msg will
+ *				reply in struct kdbus_cmd_send will
  *				yield the offset in the sender's pool
  *				where the reply can be found.
  *				This flag is only valid if
-- 
1.8.3.1
