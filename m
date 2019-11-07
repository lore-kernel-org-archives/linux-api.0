From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 04/14] pipe: Add O_NOTIFICATION_PIPE [ver #2]
Date: Thu, 07 Nov 2019 13:35:56 +0000
Message-ID: <157313375678.29677.15875689548927466028.stgit@warthog.procyon.org.uk>
References: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add an O_NOTIFICATION_PIPE flag that can be passed to pipe2() to indicate
that the pipe being created is going to be used for notifications.  This
suppresses the use of splice(), vmsplice(), tee() and sendfile() on the
pipe as calling iov_iter_revert() on a pipe when a kernel notification
message has been inserted into the middle of a multi-buffer splice will be
messy.

The flag is given the same value as O_EXCL as it seems unlikely that
this flag will ever be applicable to pipes and I don't want to use up
another O_* bit unnecessarily.  An alternative could be to add a pipe3()
system call.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/uapi/linux/watch_queue.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/watch_queue.h b/include/uapi/linux/watch_qu=
eue.h
index 5f3d21e8a34b..9df72227f515 100644
--- a/include/uapi/linux/watch_queue.h
+++ b/include/uapi/linux/watch_queue.h
@@ -3,6 +3,9 @@
 #define _UAPI_LINUX_WATCH_QUEUE_H
=20
 #include <linux/types.h>
+#include <linux/fcntl.h>
+
+#define O_NOTIFICATION_PIPE=09O_EXCL=09/* Parameter to pipe2() selecting n=
otification pipe */
=20
 enum watch_notification_type {
 =09WATCH_TYPE_META=09=09=3D 0,=09/* Special record */
