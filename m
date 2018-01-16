From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Tue, 16 Jan 2018 15:40:04 +0000
Message-ID: <1643.1516117204@warthog.procyon.org.uk>
References: <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com> <28167.1516032442@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <1642.1516117204.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> >  (6) Adjust a mountpoint's topology flags:
> >
> >         mount_set_topology(int dfd, const char *path,
> >                            unsigned int topology_flags);
> >
> >  (7) Reconfigure a mountpoint:
> >
> >         mount_reconfigure(int dfd, const char *path,
> >                           unsigned int mount_flags);
> 
> 
> What's the fundamental  difference between topology flags and other
> flags?  Why two syscalls?

Actually, if you look at the do_mount() function, these *are* separate
things.  If you look at the code:

	if (flags & MS_REMOUNT)
		retval = do_remount(&path, flags, sb_flags, mnt_flags,
				    data_page);

^^^ that is mount_reconfigure() and superblock reconfiguration.

	else if (flags & MS_BIND)
		retval = do_loopback(&path, dev_name, flags & MS_REC);
	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
		retval = do_change_type(&path, flags);

^^^ that is mount_set_topology().

	else if (flags & MS_MOVE)
		retval = do_move_mount(&path, dev_name);
	else
		retval = do_new_mount(&path, type_page, sb_flags, mnt_flags,
				      dev_name, data_page);

The mount() syscall is actually a function switch with five functions.

David
