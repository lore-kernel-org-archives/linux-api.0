From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 02/15] fs-verity: add MAINTAINERS file entry
Date: Thu, 23 May 2019 09:17:58 -0700
Message-ID: <20190523161811.6259-3-ebiggers@kernel.org>
References: <20190523161811.6259-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190523161811.6259-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-integrity@vger.kernel.org, linux-ext4@vger.kernel.org, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fs-verity will be jointly maintained by Eric Biggers and Theodore Ts'o.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5cfbea4ce5750..869c836e9039f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6493,6 +6493,18 @@ S:	Maintained
 F:	fs/notify/
 F:	include/linux/fsnotify*.h
 
+FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PROTECTION
+M:	Eric Biggers <ebiggers@kernel.org>
+M:	Theodore Y. Ts'o <tytso@mit.edu>
+L:	linux-fscrypt@vger.kernel.org
+Q:	https://patchwork.kernel.org/project/linux-fscrypt/list/
+T:	git git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git fsverity
+S:	Supported
+F:	fs/verity/
+F:	include/linux/fsverity.h
+F:	include/uapi/linux/fsverity.h
+F:	Documentation/filesystems/fsverity.rst
+
 FUJITSU LAPTOP EXTRAS
 M:	Jonathan Woithe <jwoithe@just42.net>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.21.0
