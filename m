From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv8.2] fanotify: enable close-on-exec on events' fd when requested in fanotify_init()
Date: Fri,  3 Oct 2014 10:39:37 +0200
Message-ID: <1412325577-11591-1-git-send-email-ydroneaud@opteya.com>
References: <cover.1411562410.git.ydroneaud@opteya.com> <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com> <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain> <542666B2.9080700@gmx.de> <1411980555-10818-1-git-send-email-ydroneaud@opteya.com> <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org> <20141002104410.GB19748@quack.suse.cz> <20141002124652.c877efeb35d07064e520a702@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141002124652.c877efeb35d07064e520a702-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lino Sanfilippo <LinoSanfilippo-Mmb7MZpHnFY@public.gmane.org>, Valdis Kletnieks <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mihai.dontu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
List-Id: linux-api@vger.kernel.org

According to commit 80af258867648 ('fanotify: groups can specify
their f_flags for new fd'), file descriptors created as part of
file access notification events inherit flags from the
event_f_flags argument passed to syscall fanotify_init(2)[1].

Unfortunately O_CLOEXEC is currently silently ignored.

Indeed, event_f_flags are only given to dentry_open(), which only
seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
O_DIRECT in open_check_o_direct() and O_LARGEFILE in
generic_file_open().

It's a pity, since, according to some lookup on various search
engines and http://codesearch.debian.net/, there's already some
userspace code which use O_CLOEXEC:

- in systemd's readahead[2]:

    fanotify_fd =3D fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_=
LARGEFILE|O_CLOEXEC|O_NOATIME);

- in clsync[3]:

    #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)

    int fanotify_d =3D fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);

- in examples [4] from "Filesystem monitoring in the Linux
  kernel" article[5] by Aleksander Morgado:

    if ((fanotify_fd =3D fanotify_init (FAN_CLOEXEC,
                                      O_RDONLY | O_CLOEXEC | O_LARGEFIL=
E)) < 0)

Additionally, since commit 48149e9d3a7e ('fanotify: check file
flags passed in fanotify_init'). having O_CLOEXEC as part of
fanotify_init() second argument is expressly allowed.

So it seems expected to set close-on-exec flag on the file
descriptors if userspace is allowed to request it with O_CLOEXEC.

But Andrew Morton raised[6] the concern that enabling now
close-on-exec might break existing applications which ask for
O_CLOEXEC but expect the file descriptor to be inherited
across exec().

In the other hand, as reported by Mihai Don=C8=9Bu[7], not setting
close-on-exec on the file descriptor returned as part of file
access notify can break applications due to deadlock.
So close-on-exec is needed for most applications.

More, applications asking for close-on-exec are likely expecting
it to be enabled, relying on O_CLOEXEC being effective. If not,
it might weaken their security, as noted by Jan Kara[8].

So this patch replaces call to macro get_unused_fd() by a call
to function get_unused_fd_flags() with event_f_flags value as
argument. This way O_CLOEXEC flag in the second argument of
fanotify_init(2) syscall is interpreted and close-on-exec
get enabled when requested.

[1] http://man7.org/linux/man-pages/man2/fanotify_init.2.html
[2] http://cgit.freedesktop.org/systemd/systemd/tree/src/readahead/read=
ahead-collect.c?id=3Dv208#n294
[3] https://github.com/xaionaro/clsync/blob/v0.2.1/sync.c#L1631
    https://github.com/xaionaro/clsync/blob/v0.2.1/configuration.h#L38
[4] http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
[5] http://www.lanedo.com/2013/filesystem-monitoring-linux-kernel/
[6] http://lkml.kernel.org/r/20141001153621.65e9258e65a6167bf2e4cb50@li=
nux-foundation.org
[7] http://lkml.kernel.org/r/20141002095046.3715eb69@mdontu-l
[8] http://lkml.kernel.org/r/20141002104410.GB19748-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org

Link: http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud-RlY5vtjFyJ1hl2p70BpVqQ@public.gmane.org=
m
Cc: Mihai Don=C8=9Bu <mihai.dontu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: P=C3=A1draig Brady <P@draigBrady.com>
Cc: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Lino Sanfilippo <LinoSanfilippo-Mmb7MZpHnFY@public.gmane.org>
Cc: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Reviewed by: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
Tested-by: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
Hi Andrew,

> Fair enough, it sounds like the risk is acceptable.
>

OK.

> Can we get a new version sent out with all this new info appropriatel=
y
> changelogged?
>

Of course !

Please find an updated patch with revamped commit message.

Changes from v8.1:

- added more Cc:
- added Reviewed-by:
- rewrote commit message.

 fs/notify/fanotify/fanotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fa=
notify_user.c
index b13992a41bd9..c991616acca9 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -78,7 +78,7 @@ static int create_fd(struct fsnotify_group *group,
=20
 	pr_debug("%s: group=3D%p event=3D%p\n", __func__, group, event);
=20
-	client_fd =3D get_unused_fd();
+	client_fd =3D get_unused_fd_flags(group->fanotify_data.f_flags);
 	if (client_fd < 0)
 		return client_fd;
=20
--=20
1.9.3
