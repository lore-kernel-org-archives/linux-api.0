From: Peter Wu <peter@lekensteyn.nl>
Subject: [PATCH] block: add start and size to ABI documentation
Date: Sat, 26 Dec 2015 19:36:35 +0100
Message-ID: <1451154995-4686-1-git-send-email-peter@lekensteyn.nl>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Document the start and size fields (which were introduced in commit
v2.5.42-215-gb288f6a) to avoid guesswork on the unit.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
Hi,

As the meaning has not changed for over 13 years, I would like to
formalize these attributes such that users can rely on it[1][2].
The sector definition was inspired by the block/stat.txt documentation.

By the way, the ABI/README document is ambiguous on the meaning of
"Date", is it the creation date of the documentation entry or the
creation of the filesystem interface? I have chosen the latter here.

Kind regards,
Peter

 [1]: https://lkml.kernel.org/r/201012011729.18661.lists@egidy.de
 [2]: https://unix.stackexchange.com/questions/52215/determine-the-size-of-a-block-device#comment112867_52219
---
 Documentation/ABI/testing/sysfs-block | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 71d184d..b85a266 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -235,3 +235,20 @@ Description:
 		write_same_max_bytes is 0, write same is not supported
 		by the device.
 
+What:		/sys/block/<disk>/<partition>/start
+Date:		October 2002
+Contact:	linux-block@vger.kernel.org
+Kernel Version:	2.5.43
+Description:
+		Starting position of the partition within the disk.
+		Measured in standard UNIX 512-byte sectors (not a
+		device-specific block size).
+
+What:		/sys/block/<disk>/<partition>/size
+Date:		October 2002
+Contact:	linux-block@vger.kernel.org
+Kernel Version:	2.5.43
+Description:
+		Size of the partition in standard UNIX 512-byte sectors
+		(not a device-specific block size).
+
-- 
2.6.4
