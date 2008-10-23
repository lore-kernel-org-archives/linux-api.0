From: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
Subject: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Date: Thu, 23 Oct 2008 16:50:55 +0200
Message-ID: <20081023145054.998439866@marvin.suse.de>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

found something which looks for me like a kernel/glibc syscall mismatch. At
least the parameter list of "readlink" is different in the kernel compared to
glibc, POSIX and linux-man-pages. I'm not quite sure if this difference was
intended or not ... 

man 3p readlink:
ssize_t readlink(const char *restrict path, char *restrict buf, size_t bufsize);

http://www.opengroup.org/onlinepubs/000095399/functions/readlink.html:
size_t readlink(const char *restrict path, char *restrict buf, size_t bufsize);

glibc (/usr/include/unistd.h):
size_t readlink (__const char *__restrict __path, char *__restrict __buf, size_t

man 2 readlink:
ssize_t readlink(const char *path, char *buf, size_t bufsiz);
                                              ^^^^^^
linux-2.6/include/linux/syscalls.h:
asmlinkage long sys_readlink(const char __user *path, char __user *buf, int
		bufsiz);                                                ^^^


All readlink prototypes, expect the one in the kernel, have an unsigned
buffer size. Even the readlink(2) man-page, which also describes an error
statement like this:

EINVAL bufsiz is not positive.

Note: the same man-page defined bufsiz as type of size_t (unsigned).

While reviewing LTP i discovered that the "readlink03" syscall test contains a 
testcase to do a functional error-path test for "EINVAL bufsiz is not positive".
This testcase is using the glibc readlink() interface, which cause a unsigned
cast of the value "-1" and let the testcase fail (actually due to gcc/glibc
fortify checks and cause a __chk_fail()).

Before workarounding the testcase, or not applying -D_FORTIFY_SOURCE=2 on LTP
build, i try to understand if there is any reason for this mismatch between
kernel and glibc/POSIX. Regarding the man-page, i'm quite certain this was a
copy&paste-error by coping the prototype from the POSIX man-page.

Even sys_readlinkat(), which got introduced a long time after sys_readlink(),
got a signed buffer size. Intended?

In the rare case all this was unintended, find patches for kernel, man-pages
and LTP to change the kernel readlink syscall interface to a unsigned buffer
size.

Thoughts?

best regards,
Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
