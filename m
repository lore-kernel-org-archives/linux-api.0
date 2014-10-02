From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] fanotify: add a flag to allow setting O_CLOEXEC on event fd
Date: Thu,  2 Oct 2014 09:52:29 +0200
Message-ID: <1412236349-30035-1-git-send-email-ydroneaud@opteya.com>
References: <cover.1411562410.git.ydroneaud@opteya.com> <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com> <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain> <542666B2.9080700@gmx.de> <1411980555-10818-1-git-send-email-ydroneaud@opteya.com> <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org> <1412230855.28184.5.camel@localhost.localdomain>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412230855.28184.5.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>, Lino Sanfilippo <LinoSanfilippo@gmx.de>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

In order to not potentially break applications which were
requesting O_CLOEXEC on event file descriptors but which
actually need it to be not effective as the kernel currently
ignore the flag, so the file descriptor is inherited accross
exec regardless of O_CLOEXEC (please forgive me for the
wording), this patch introduces FAN_FD_CLOEXEC flag to
fanotify_init() so that application can request O_CLOEXEC
to be effective.
Newer application would use FAN_FD_CLOEXEC flag along
O_CLOEXEC to enable close on exec on newly created
file descriptor:

  fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK|FAN_FD_CLOEXEC,
                     O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---

Hi Andrew,

While I believe fanotify_init() must enable close-on-exec
when requested by userspace to prevent unwelcomed security
issue, I understand your concerns regarding the possible
breakage on userspace application requesting O_CLOEXEC
but relying on it not being enable on file descriptor
created for the events.

So with a new flag to fanotify_init(), we could allow
newer applications to really enable O_CLOEXEC.

But I feel bad to have to force application to specify
twice they want close on exec:
  - are you sure ?
  - are you really sure ?
  - is this your final answer ?
  ...

Regards.

Yann Droneaud
OPTEYA


 fs/notify/fanotify/fanotify_user.c | 6 +++++-
 include/uapi/linux/fanotify.h      | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c991616acca9..3c1fb1412f37 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -78,7 +78,7 @@ static int create_fd(struct fsnotify_group *group,
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	client_fd = get_unused_fd_flags(group->fanotify_data.f_flags);
+	client_fd = get_unused_fd_flags(group->fanotify_data.f_flags & O_CLOEXEC);
 	if (client_fd < 0)
 		return client_fd;
 
@@ -706,6 +706,10 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		return -EINVAL;
 	}
 
+	if ((event_f_flags & O_CLOEXEC) &&
+	    !(flags & FAN_FD_CLOEXEC))
+		event_f_flags ^= O_CLOEXEC;
+
 	user = get_current_user();
 	if (atomic_read(&user->fanotify_listeners) > FANOTIFY_DEFAULT_MAX_LISTENERS) {
 		free_uid(user);
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index 030508d195d3..f2d517be3152 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -36,7 +36,10 @@
 #define FAN_UNLIMITED_QUEUE	0x00000010
 #define FAN_UNLIMITED_MARKS	0x00000020
 
-#define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK | \
+/* flags used for fanotify_init() too */
+#define FAN_FD_CLOEXEC		0x00000100
+
+#define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK | FAN_FD_CLOEXEC | \
 				 FAN_ALL_CLASS_BITS | FAN_UNLIMITED_QUEUE |\
 				 FAN_UNLIMITED_MARKS)
 
-- 
1.9.3
