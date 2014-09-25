From: Heinrich Schuchardt <xypron.debian-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCHv8 1/6] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
Date: Thu, 25 Sep 2014 22:57:23 +0200
Message-ID: <542481B3.8070300@gmx.de>
References: <cover.1411562410.git.ydroneaud@opteya.com> <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 24.09.2014 15:11, Yann Droneaud wrote:
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

I tested on kernel 3.17.0-rc5. I passed O_CLOEXEC in event_f_flags.
When I called fcnt(event_metadata->fd, F_GETFD) it did not return 
FD_CLOEXEC. So I can confirm your observation that O_CLOEXEC is not 
working as expected.

I found this definition
#define get_unused_fd() get_unused_fd_flags(0)

So essentially when get_unused_fd() is called for a fanotify event 
O_CLOEXEC is ignored.

This is what your patch fixes.

>
> More, there's no effective check on event_f_flags value that
> would catch unknown / unsupported values, unlike the one on
> f_flags argument of the syscall (see FAN_ALL_INIT_FLAGS in
> include/uapi/linux/fanotify.h).

The fanotify_init(2) man page describes which flags are allowable in 
event_f_flags.

Could you, please, explain why the following code in fanotify_user.c is 
not to be considered an effective check:

     if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_BITS)
         return -EINVAL;

     switch (event_f_flags & O_ACCMODE) {
     case O_RDONLY:
     case O_RDWR:
     case O_WRONLY:
         break;
     default:
         return -EINVAL;
     }

I CC Jan Kara as he reviewed the code.

Best regards

Heinrich Schuchardt
