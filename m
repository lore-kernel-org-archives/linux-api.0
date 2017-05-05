From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: new ...at() flag: AT_NO_JUMPS
Date: Fri, 5 May 2017 04:00:58 +0100
Message-ID: <20170505030058.GO29622@ZenIV.linux.org.uk>
References: <20170429220414.GT29622@ZenIV.linux.org.uk>
 <CAG48ez0wccvQ5i+XN_Q_yA9_ZwSaGb-W+zky0KQb_GU=9G+MSw@mail.gmail.com>
 <20170505003030.GM29622@ZenIV.linux.org.uk>
 <CA+55aFyOKM7DW7+0sdDFKdZFXgptb5r1id9=Wvhd8AgSP7qjwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyOKM7DW7+0sdDFKdZFXgptb5r1id9=Wvhd8AgSP7qjwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 04, 2017 at 06:27:10PM -0700, Linus Torvalds wrote:

> As mentioned last time, at least for the git usage, even relative
> symlinks are a no-no - not because they'd escape, but simply because
> git wants to see the *unique* name, and resolve relative symlinks to
> either the symlink, or to the actual file it points to.
> 
> So I think that we'd want an additional flag that says "no symlinks at all".

OK, that's easily done.

> And I think the "no mountpoint" traversal might be splittable too.
> 
> Yes, sometimes you'd probably want to say "stay exactly inside this
> filesystem" (like find -xdev). So no arguments against AT_XDEV that
> refuses any mount traversal (kind of like my "no symlink traversal"
> thing).
> 
> But at other points you might want to just guarantee that the walk
> stays below a certain starting point and doesn't escape.
> 
> That could still allow crossing mount-points, but only if they are
> non-bind mounts and cannot let us escape.
> 
> I'm not sure if that's testable, though.

This one isn't, unfortunately - there is no difference between bind and
no-bind; vfsmounts form a tree and both normal mount and bind add leaves
to it.  Moreover, mount -t ext2 /dev/sdc7 /mnt; mount -t ext2 /dev/sdc7 /tmp/a
yield the same state as mount -t ext2 /dev/sdc7; mount --bind /mnt /tmp/a.
There is no way to tell the difference, simply because there *is* no
difference.  Moreover, either can be followed by umount /mnt and you'll get
the same state as you would have after a solitary mount of the same fs on
/tmp/a.

Ho-hum...  So:

			AT_BENEATH	AT_XDEV		AT_NO_SYMLINKS
absolute pathname:	EXDEV
non-relative symlink:	EXDEV		?		ELOOP
relative symlink:					ELOOP
.. from starting point:	EXDEV
.. crossing mountpoint:			EXDEV
crossing into mountpoint:		EXDEV

1) What should AT_XDEV do about absolute symlinks?  Nothing special?  EXDEV?
EXDEV if we are not on root?
2) What should AT_BENEATH | AT_NO_SYMLINKS do on absolute symlinks?  My
preference would be "AT_NO_SYMLINKS wins, ELOOP for you", but that's based
mostly upon the convenience of implementation.
3) What effect should AT_NO_SYMLINKS have upon the final component?  Same
as AT_SYMLINK_NOFOLLOW?
