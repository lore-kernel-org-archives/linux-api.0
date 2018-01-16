From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Tue, 16 Jan 2018 14:18:22 +0000
Message-ID: <30249.1516112302@warthog.procyon.org.uk>
References: <CAOssrKc46bf=yme=zSubYF6t-TGfxEpCaKMQ6GVp30-vuaXWLw@mail.gmail.com> <28167.1516032442@warthog.procyon.org.uk> <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com> <22576.1516097412@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOssrKc46bf=yme=zSubYF6t-TGfxEpCaKMQ6GVp30-vuaXWLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-ID: <30248.1516112302.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> > Maybe - the problem is that it's harder to manage if you've got multiple
> > mounts attached to a single superblock as you can only change the superblock
> > state if all the mounts are R/O.
> 
> Not true:
> 
>  [root@veci ~]# cat /proc/self/mountinfo | grep 46
> 212 78 0:46 / /tmp/1 rw,relatime shared:153 - tmpfs tmpfs rw,seclabel
> 219 78 0:46 / /tmp/2 rw,relatime shared:153 - tmpfs tmpfs rw,seclabel
> [root@veci ~]# mount -oremount,ro /tmp/1
> [root@veci ~]# cat /proc/self/mountinfo | grep 46
> 212 78 0:46 / /tmp/1 ro,relatime shared:153 - tmpfs tmpfs ro,seclabel
> 219 78 0:46 / /tmp/2 rw,relatime shared:153 - tmpfs tmpfs ro,seclabel
> [root@veci ~]# mount -oremount,bind,rw /tmp/1
> [root@veci ~]# cat /proc/self/mountinfo | grep 46
> 212 78 0:46 / /tmp/1 rw,relatime shared:153 - tmpfs tmpfs ro,seclabel
> 219 78 0:46 / /tmp/2 rw,relatime shared:153 - tmpfs tmpfs ro,seclabel
> [root@veci ~]#
> 
> R/O flag on mount and on superblock can be changed independently.

Ah...  I misread the code.  I was looking at the check that there are no
writers on a mount.

David
