From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH 1/2] nsfs: Add an ioctl() to return the namespace type
Date: Mon, 19 Dec 2016 15:38:26 +0100
Message-ID: <4a0f873a-acd5-ebac-9770-c10807144400@gmail.com>
References: <fdce894d-8385-b4b4-da3c-6282a7e4ecba@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fdce894d-8385-b4b4-da3c-6282a7e4ecba@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: mtk.manpages@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

Linux 4.9 added two ioctl() operations that can be used to discover:

* the parental relationships for hierarchical namespaces (user and PID)
  [NS_GET_PARENT]
* the user namespaces that owns a specified non-user-namespace
  [NS_GET_USERNS]

For no good reason that I can glean, NS_GET_USERNS was made synonymous
with NS_GET_PARENT for user namespaces. It might have been better if
NS_GET_USERNS had returned an error if the supplied file descriptor
referred to a user namespace, since it suggests that the caller may be
confused. More particularly, if it had generated an error, then I wouldn't
need the new ioctl() operation proposed here. (On the other hand, what
I propose here may be more generally useful.)

I would like to write code that can answer the question: "what
capabilities does process X have in namespace Y"? (where Y is defined
by a file descriptor referring to one of the /proc/PID/ns/xxxx
files). The rules that determine the answer to this question are
described in the capabilities(7) manual page and involve working out
the chain of relationships between the user namespace of process X and
the namespace Y.

Namespace Y might be a user namespace (in which case my code would
just use Y) or a non-user namespace (in which case my code needs to
use NS_GET_USERNS to get the user namespace associated with Y). The
problem is that there is no way to tell the difference by looking at
the file descriptor (and if I try to use NS_GET_USERNS on a Y that is
a user namespace, I get the parent user namespace of Y, which is not
what I want).

This patch therefore adds a new ioctl(), NS_GET_NSTYPE, which, given
a file descriptor that refers to a user namespace, returns the
namespace type (one of the CLONE_NEW* constants).

Signed-off-by: Michael Kerrisk <mtk-manpages@gmail.com>
---
 fs/nsfs.c                 | 2 ++
 include/uapi/linux/nsfs.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8c9fb29..5d53476 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -172,6 +172,8 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
 		if (!ns->ops->get_parent)
 			return -EINVAL;
 		return open_related_ns(ns, ns->ops->get_parent);
+	case NS_GET_NSTYPE:
+		return ns->ops->type;
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index 3af6172..2b48df1 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -9,5 +9,8 @@
 #define NS_GET_USERNS	_IO(NSIO, 0x1)
 /* Returns a file descriptor that refers to a parent namespace */
 #define NS_GET_PARENT	_IO(NSIO, 0x2)
+/* Returns the type of namespace (CLONE_NEW* value) referred to by
+   file descriptor */
+#define NS_GET_NSTYPE	_IO(NSIO, 0x3)
 
 #endif /* __LINUX_NSFS_H */
-- 
2.5.5
