From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Seccomp implications for glibc wrapper function changes
Date: Tue, 7 Nov 2017 21:35:25 +0100
Message-ID: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Adhemerval Zanella <adhemerval.zanella-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

I was recently testing some code I'd written a while back that makes
use of seccomp filters to control which system calls a process can
make, and I got a surpise when someone showed the code no longer
worked in on a system that had glibc 2.26.

The behavior change resulted from Adhemerval's glibc commit

     commit b41152d716ee9c5ba34495a54e64ea2b732139b5
     Author: Adhemerval Zanella <adhemerval.zanella-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
     Date:   Fri Nov 11 15:00:03 2016 -0200

        Consolidate Linux open implementation
            [...]
            3. Use __NR_openat as default syscall for open{64}.

The commit in question changed the glibc open() wrapper to swtcch from
use the kernel's open() system call to using the kernel's openat()
system call.

This change broke my code that was doing seccomp filtering for the
open() system call number (__NR_open). The breakage in question is not
serious, since this was really just demonstration code. However, I
want to raise awareness that these sorts of changes have the potential
to possibly cause breakages for some code using seccomp, and note that
I think such changes should not be made lightly or gratuitously. (In
the above commit, it's not clear why the switch was made to using
openat(): there's no mention of the reasoning in the commit message,
nor is there anything that is obvious from reading through the code
change itself.)

Best regards,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
