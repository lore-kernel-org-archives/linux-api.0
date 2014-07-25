From: David Drysdale <drysdale@google.com>
Subject: [PATCH 06/11] capsicum: implement sockfd_lookupr()
Date: Fri, 25 Jul 2014 14:47:02 +0100
Message-ID: <1406296033-32693-7-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add variants of sockfd_lookup() and related functions where the caller
indicates the operations that will be performed on the socket.

If CONFIG_SECURITY_CAPSICUM is defined, these variants use the
fgetr()-style functions to retrieve the struct file from the file
descriptor.

If CONFIG_SECURITY_CAPSICUM is not defined, these variants use the
normal fget() functions.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 include/linux/net.h |  16 +++++++
 net/socket.c        | 120 ++++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 119 insertions(+), 17 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 17d83393afcc..05429ce3b730 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -24,6 +24,7 @@
 #include <linux/fcntl.h>	/* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/kmemcheck.h>
 #include <linux/rcupdate.h>
+#include <linux/capsicum.h>
 #include <linux/jump_label.h>
 #include <uapi/linux/net.h>
 
@@ -222,6 +223,21 @@ struct socket *sock_from_file(struct file *file, int *err);
 #define		     sockfd_put(sock) fput(sock->file)
 int net_ratelimit(void);
 
+#ifdef CONFIG_SECURITY_CAPSICUM
+struct socket *sockfd_lookup_rights(int fd, int *err,
+				    struct capsicum_rights *rights);
+struct socket *_sockfd_lookupr(int fd, int *err, ...);
+#define sockfd_lookupr(fd, err, ...) \
+	_sockfd_lookupr((fd), (err), __VA_ARGS__, 0ULL)
+#else
+static inline struct socket *
+sockfd_lookup_rights(int fd, int *err, struct capsicum_rights *rights)
+{
+	return sockfd_lookup(fd, err);
+}
+#define sockfd_lookupr(fd, err, ...)	sockfd_lookup((fd), (err))
+#endif
+
 #define net_ratelimited_function(function, ...)			\
 do {								\
 	if (net_ratelimit())					\
diff --git a/net/socket.c b/net/socket.c
index abf56b2a14f9..cc2e59576b3c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -96,6 +96,7 @@
 #include <net/compat.h>
 #include <net/wext.h>
 #include <net/cls_cgroup.h>
+#include <net/sctp/sctp.h>
 
 #include <net/sock.h>
 #include <linux/netfilter.h>
@@ -418,6 +419,108 @@ struct socket *sock_from_file(struct file *file, int *err)
 }
 EXPORT_SYMBOL(sock_from_file);
 
+static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
+{
+	struct fd f = fdget(fd);
+	struct socket *sock;
+
+	*err = -EBADF;
+	if (f.file) {
+		sock = sock_from_file(f.file, err);
+		if (likely(sock)) {
+			*fput_needed = f.flags;
+			return sock;
+		}
+		fdput(f);
+	}
+	return NULL;
+}
+
+#ifdef CONFIG_SECURITY_CAPSICUM
+struct socket *sockfd_lookup_rights(int fd, int *err,
+				    struct capsicum_rights *rights)
+{
+	struct file *file;
+	struct socket *sock;
+
+	file = fget_rights(fd, rights);
+	if (IS_ERR(file)) {
+		*err = PTR_ERR(file);
+		return NULL;
+	}
+
+	sock = sock_from_file(file, err);
+	if (!sock)
+		fput(file);
+	return sock;
+}
+EXPORT_SYMBOL(sockfd_lookup_rights);
+
+static struct socket *
+sockfd_lookup_light_rights(int fd, int *err, int *fput_needed,
+			   const struct capsicum_rights **actual_rights,
+			   const struct capsicum_rights *required_rights)
+{
+	struct fd f = fdget_raw_rights(fd, actual_rights, required_rights);
+	struct socket *sock;
+
+	*err = -EBADF;
+	if (!IS_ERR(f.file)) {
+		sock = sock_from_file(f.file, err);
+		if (likely(sock)) {
+			*fput_needed = f.flags;
+			return sock;
+		}
+		fdput(f);
+	} else {
+		*err = PTR_ERR(f.file);
+	}
+	return NULL;
+}
+
+struct socket *_sockfd_lookupr(int fd, int *err, ...)
+{
+	struct capsicum_rights rights;
+	struct socket *sock;
+	va_list ap;
+
+	va_start(ap, err);
+	sock = sockfd_lookup_rights(fd, err, cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	return sock;
+}
+EXPORT_SYMBOL(_sockfd_lookupr);
+
+struct socket *_sockfd_lookupr_light(int fd, int *err, int *fput_needed, ...)
+{
+	struct capsicum_rights rights;
+	struct socket *sock;
+	va_list ap;
+
+	va_start(ap, fput_needed);
+	sock = sockfd_lookup_light_rights(fd, err, fput_needed,
+					  NULL, cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	return sock;
+}
+#define sockfd_lookupr_light(fd, err, fpn, ...) \
+	_sockfd_lookupr_light((fd), (err), (fpn), __VA_ARGS__, 0ULL)
+
+#else
+
+static inline struct socket *
+sockfd_lookup_light_rights(int fd, int *err, int *fput_needed,
+			   const struct capsicum_rights **actual_rights,
+			   const struct capsicum_rights *required_rights)
+{
+	return sockfd_lookup_light(fd, err, fput_needed);
+}
+
+#define sockfd_lookupr_light(f, e, p, ...) \
+	sockfd_lookup_light((f), (e), (p))
+
+#endif
+
 /**
  *	sockfd_lookup - Go from a file number to its socket slot
  *	@fd: file handle
@@ -449,23 +552,6 @@ struct socket *sockfd_lookup(int fd, int *err)
 }
 EXPORT_SYMBOL(sockfd_lookup);
 
-static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
-{
-	struct fd f = fdget(fd);
-	struct socket *sock;
-
-	*err = -EBADF;
-	if (f.file) {
-		sock = sock_from_file(f.file, err);
-		if (likely(sock)) {
-			*fput_needed = f.flags;
-			return sock;
-		}
-		fdput(f);
-	}
-	return NULL;
-}
-
 #define XATTR_SOCKPROTONAME_SUFFIX "sockprotoname"
 #define XATTR_NAME_SOCKPROTONAME (XATTR_SYSTEM_PREFIX XATTR_SOCKPROTONAME_SUFFIX)
 #define XATTR_NAME_SOCKPROTONAME_LEN (sizeof(XATTR_NAME_SOCKPROTONAME)-1)
-- 
2.0.0.526.g5318336

