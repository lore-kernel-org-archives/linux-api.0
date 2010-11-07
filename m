From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Inconsistent credential checking in prlimit() syscall
Date: Sun, 7 Nov 2010 09:04:22 +0100
Message-ID: <AANLkTi=mM2GoL=+umHJ6dDCqa7dNmG3=ra8xDOW4QCEV@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Jiri Slaby <jslaby-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Cc: marcin.slusarz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Neil, Jiri,

I  started documenting the prlimit() system call added in 2.6.36, and
found the permission checks to be rather inconsistent with any other
kernel-userspace API. They are:

CAP_SYS_RESOURCE ||
(c-uid == t-uid && c0uid == t-euid && c-uid == t-suid) &&
(c-gid == t-gid && c-gid == t-guid && c-gid == t-sgid)

(uid == real UID; euid == effective UID; suid == save set-user-ID; and
analogously for GIDs; c- == caller's ID, and t- == target process's
ID)

In other words, for an unprivileged user, all UIDs of the target
process must match the calling process's real UID *and* all GIDs of
the target process must match the calling process's real GID.

What is the reason that the checks for prlimit() aren't similar to say
setpriority(), whose checks are the much simpler, and make no mention
of GIDs:

c-euid == t-uid || c-euid == t-euid

?

Thanks,

Michael

PS see also http://linux-man-pages.blogspot.com/2010/11/system-call-credential-checking-tale-of.html

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
