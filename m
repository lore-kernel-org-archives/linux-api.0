From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Regression: Requiring CAP_SYS_ADMIN for /proc/<pid>/pagemap causes
 application-level breakage
Date: Fri, 24 Apr 2015 16:01:24 +0100
Message-ID: <CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi all,

<resending without unwanted HTML-ifying - apologies for the noise if
this appears twice for you!>

Recent changes have restricted a userspace interface used by our
product; specifically, a security patch to require CAP_SYS_ADMIN when
opening /proc/PID/pagemap
(https://github.com/torvalds/linux/commit/ab676b7d6fbf4b294bf198fb27ade5b0e865c7ce,
original LKML discussion here: https://lkml.org/lkml/2015/3/9/864).

Although I've marked this as a "Regression", we do realise there are
legitimate security concerns over the original implementation of this
interface.  Still, given the kernel's strong stance on preserving
userspace interfaces, we thought we ought to flag this quickly as
something that has changed application-relevant behaviour.

We believe this change came into released kernels with Linux 4.0.  We
first observed problems when testing on Ubuntu 15.04 this week; I see
the patch is now backported to the various -stable kernel lines, so
I'd expect it to show up in other distros in due course.  The obvious
solution (to simply run with CAP_SYS_ADMIN) is quite undesirable for
our product, which is a debugger; we're expecting our users to run
without special privileges.

In our use of /proc/PID/pagemap, we currently make use of the physical
pageframe addresses.  We should be able to work with a scrambled
representation of these (Andy Lutomirski suggested this in the
original discussion - https://lkml.org/lkml/2015/3/16/1273) so long as
the scrambling remained consistent during the lifetime of the open
pagemap file.  Alternatively, if physical addresses were simply zeroed
(also suggested by Pavel Emelyanov -
https://lkml.org/lkml/2015/3/9/871) we would be able to change our
code to rely only on the soft-dirty flag and thus still work
correctly.

I propose to follow up with a patch that provides unprivileged access
to /proc/PID/pagemap with the physical pageframe addresses zeroed.
Would this be an acceptable approach?

Thank you,
Mark Williamson

---
Undo Software - http://undo-software.com/
