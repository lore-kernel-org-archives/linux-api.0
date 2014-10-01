From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCHv8.1] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
Date: Wed, 1 Oct 2014 15:36:21 -0700
Message-ID: <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
References: <cover.1411562410.git.ydroneaud@opteya.com>
	<9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
	<542481B3.8070300@gmx.de>
	<1411721898.7778.18.camel@localhost.localdomain>
	<542666B2.9080700@gmx.de>
	<1411980555-10818-1-git-send-email-ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411980555-10818-1-git-send-email-ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Lino Sanfilippo <LinoSanfilippo-Mmb7MZpHnFY@public.gmane.org>, Valdis Kletnieks <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 29 Sep 2014 10:49:15 +0200 Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrote:

> According to commit 80af258867648 ('fanotify: groups can specify
> their f_flags for new fd'), file descriptors created as part of
> file access notification events inherit flags from the
> event_f_flags argument passed to syscall fanotify_init(2).
> 
> So while it is legal for userspace to call fanotify_init() with
> O_CLOEXEC as part of its second argument, O_CLOEXEC is currently
> silently ignored.
> 
> Indeed event_f_flags are only given to dentry_open(), which only
> seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
> O_DIRECT in open_check_o_direct() and O_LARGEFILE in
> generic_file_open().
> 
> But it seems logical to set close-on-exec flag on the file
> descriptor if userspace is allowed to request it with O_CLOEXEC.
> 
> In fact, according to some lookup on http://codesearch.debian.net/
> and various search engine, there's already some userspace code
> requesting it:
> 
> - in systemd's readahead[2]:
> 
>     fanotify_fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);
> 
> - in clsync[3]:
> 
>     #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)
> 
>     int fanotify_d = fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);
> 
> - in examples [4] from "Filesystem monitoring in the Linux
>   kernel" article[5] by Aleksander Morgado:
> 
>     if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
>                                       O_RDONLY | O_CLOEXEC | O_LARGEFILE)) < 0)

So we have a number of apps which are setting O_CLOEXEC, but it doesn't
actually work.  With this change it *will* work, so the behaviour of
those apps might change, possibly breaking them?
