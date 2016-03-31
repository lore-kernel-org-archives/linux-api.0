From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: New syscall: leftpad()
Date: Fri,  1 Apr 2016 00:33:31 +0200
Message-ID: <1459463613-32473-1-git-send-email-richard@nod.at>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Recent happenings in the node.js community showed how fragile software is when
it comes to dependencies of fundamental algorithms like leftpad[1].
A node.js package which provided ledpad vanished and broke a lot of software.
This raised our attention and we came to the conclusion that it is the kernel's
job to provide such functionality such that node.js based applications can in future
rely in Linux's "don't break userspace" rule.
We hope that glibc and Andoid's bionic will soon offer wrapper functions for this
new leftpad system call.
We put leftpad into the kernel not only because of Linux's stable ABI,
also for performance reasons.
As everyone knows, within the kernel everything is faster and better.
Leftpad has millions of users, so it has to be as fast as possible.
This new system call will also help making services like left-pad.io[2]
faster and more reliable. If the leftpad() system call gets adopted by a wider user base
it might also make sense to add a generic npm() system call which acts like ioctl()
where kernel modules can register new functions that are often used by node.js.
Such functions might be, is_array(), is_int(), etc.

Enjoy,
//richard

[1] http://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/
[2] http://left-pad.io/

[PATCH] Implement leftpad syscall
[PATCH] leftpad.2: Document new syscall
