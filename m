From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/4] docs: fs-verity: mention statx() support
Date: Tue, 29 Oct 2019 13:41:41 -0700
Message-ID: <20191029204141.145309-5-ebiggers@kernel.org>
References: <20191029204141.145309-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191029204141.145309-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org, Victor Hsieh <victorhsieh@google.com>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Document that the statx() system call can now be used to check whether a
file is a verity file.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fsverity.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 42a0b6dd9e0b68..3355377a24398d 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -226,6 +226,14 @@ To do so, check for FS_VERITY_FL (0x00100000) in the returned flags.
 The verity flag is not settable via FS_IOC_SETFLAGS.  You must use
 FS_IOC_ENABLE_VERITY instead, since parameters must be provided.
 
+statx
+-----
+
+Since Linux v5.5, the statx() system call sets STATX_ATTR_VERITY if
+the file has fs-verity enabled.  This can perform better than
+FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
+opening the file, and opening verity files can be expensive.
+
 Accessing verity files
 ======================
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog
