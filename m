From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCHv8 1/6] fanotify: enable close-on-exec on events' fd when requested in fanotify_init()
Date: Wed, 24 Sep 2014 15:11:06 +0200
Message-ID: <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
References: <cover.1411562410.git.ydroneaud@opteya.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1411562410.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1411562410.git.ydroneaud@opteya.com>
References: <cover.1411562410.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

According to commit 80af258867648 ('fanotify: groups can specify
their f_flags for new fd'), file descriptors created as part of
file access notification events inherit flags from the
event_f_flags argument passed to syscall fanotify_init(2).

So while it is legal for userspace to call fanotify_init() with
O_CLOEXEC as part of its second argument, O_CLOEXEC is currently
silently ignored.

Indeed event_f_flags are only given to dentry_open(), which only
seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
O_DIRECT in open_check_o_direct() and O_LARGEFILE in
generic_file_open().

More, there's no effective check on event_f_flags value that
would catch unknown / unsupported values, unlike the one on
f_flags argument of the syscall (see FAN_ALL_INIT_FLAGS in
include/uapi/linux/fanotify.h).

Reading article "Botching up ioctls"[1] by Daniel Vetter might
make one feel uncomfortable when trying to add extension to an
API that doesn't check for unrecognized values.

But it seems logical to set close-on-exec flag on the file
descriptor if userspace is allowed to request it with O_CLOEXEC.

In fact, according to some lookup on http://codesearch.debian.net/
and various search engine, there's already some userspace code
requesting it:

- in systemd's readahead[2]:

    fanotify_fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);

- in clsync[3]:

    #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)

    int fanotify_d = fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);

- in examples [4] from "Filesystem monitoring in the Linux
  kernel" article[5] by Aleksander Morgado:

    if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
                                      O_RDONLY | O_CLOEXEC | O_LARGEFILE)) < 0)

Lookup also returned some wrong usage of the syscall:

- in Gonk HAL from Mozilla Firefox OS sources[6]:

    mFd = fanotify_init(FAN_CLASS_NOTIF, FAN_CLOEXEC);

Adding support for O_CLOEXEC in fanotify_init() won't magically
enable it for Gonk since FAN_CLOEXEC is defined as 0x1, which
is likely equal to O_WRONLY when used in open flag context. In
the other hand, it won't hurt it either.

So this patch replaces call to macro get_unused_fd() by a call
to function get_unused_fd_flags() with event_f_flags value as
argument. This way O_CLOEXEC flag in the second argument of
fanotify_init(2) syscall is interpreted so that close-on-exec
get enabled when requested.

[1] http://blog.ffwll.ch/2013/11/botching-up-ioctls.html
[2] http://cgit.freedesktop.org/systemd/systemd/tree/src/readahead/readahead-collect.c?id=v208#n294
[3] https://github.com/xaionaro/clsync/blob/v0.2.1/sync.c#L1631
    https://github.com/xaionaro/clsync/blob/v0.2.1/configuration.h#L38
[4] http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
[5] http://www.lanedo.com/2013/filesystem-monitoring-linux-kernel/
[6] http://hg.mozilla.org/mozilla-central/file/325c74addeba/hal/gonk/GonkDiskSpaceWatcher.cpp#l167

Link: http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud@opteya.com
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Cc: linux-api@vger.kernel.org
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/notify/fanotify/fanotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b13992a41bd9..c991616acca9 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -78,7 +78,7 @@ static int create_fd(struct fsnotify_group *group,
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	client_fd = get_unused_fd();
+	client_fd = get_unused_fd_flags(group->fanotify_data.f_flags);
 	if (client_fd < 0)
 		return client_fd;
 
-- 
1.9.3
