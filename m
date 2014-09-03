From: David Drysdale <drysdale@google.com>
Subject: [PATCH] shm: add memfd.h to UAPI export list
Date: Wed,  3 Sep 2014 14:28:10 +0100
Message-ID: <1409750890-32399-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Herrmann <dh.herrmann@gmail.com>, Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

New header file memfd.h from commit 9183df25fe7b194563db
("shm: add memfd_create() syscall") should be exported.

Signed-off-by: David Drysdale <drysdale@google.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
---

Against v3.17-rc3, for inclusion in v3.17.

 include/uapi/linux/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index c1c8e4d0ce2a..51b0e9df3e31 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -241,6 +241,7 @@ header-y += matroxfb.h
 header-y += mdio.h
 header-y += media.h
 header-y += mei.h
+header-y += memfd.h
 header-y += mempolicy.h
 header-y += meye.h
 header-y += mic_common.h
-- 
1.9.1
