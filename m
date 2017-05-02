From: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How to get an owning userns for a superblock
Date: Mon, 1 May 2017 17:05:56 -0700
Message-ID: <CANaxB-zFNSjZYhBNJt_hAewrvi2=0RHQ_oY0mTinWe4=9P=ieA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Everyone,

Now superblock has a reference to userns. Is there a way to discover
an owning userns for a superblock from user-space? In CRIU, we need
this information to dump and restore mount namespaces. For other
users, this information can be useful too to analyze and understand
the running system.

Recently we solved a similar problem for namespaces:
https://lkml.org/lkml/2016/7/6/158

In that case, we added two ioctl-s for nsfs files. Here we have a deal
regular files and I am not sure that adding a new ioctl for them is a
good idea.

Another way to solve a problem is use the kcmp() system call. We will
need to add two commands. One is to compare user namespaces and
another one is to compare a supper block userns with another userns.
The first command is required to create a sorted list of user
namespaces and the second command allows to find a proper userns in
this list.

Maybe someone has a better idea about this?

Thanks,
Andrei
