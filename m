From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 01/21] pipe: Reduce #inclusion of pipe_fs_i.h
Date: Tue, 15 Oct 2019 22:47:58 +0100
Message-ID: <157117607843.15019.8325197788819637475.stgit@warthog.procyon.org.uk>
References: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157117606853.15019.15459271147790470307.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Remove some #inclusions of linux/pipe_fs_i.h that don't seem to be
necessary any more.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/exec.c                  |    1 -
 fs/ocfs2/aops.c            |    1 -
 security/smack/smack_lsm.c |    1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 555e93c7dec8..57bc7ef8d31b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -59,7 +59,6 @@
 #include <linux/kmod.h>
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
-#include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
 #include <linux/vmalloc.h>
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 8de1c9d644f6..c50ac6b7415b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -11,7 +11,6 @@
 #include <linux/pagemap.h>
 #include <asm/byteorder.h>
 #include <linux/swap.h>
-#include <linux/pipe_fs_i.h>
 #include <linux/mpage.h>
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index abeb09c30633..ecea41ce919b 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -28,7 +28,6 @@
 #include <linux/icmpv6.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
-#include <linux/pipe_fs_i.h>
 #include <net/cipso_ipv4.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
