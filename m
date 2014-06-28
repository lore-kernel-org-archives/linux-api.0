From: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Subject: Does it make sense to define a constant for openat and such that is
 guaranteed not to be used for special purposes later on?
Date: Sat, 28 Jun 2014 19:16:53 +0000 (GMT)
Message-ID: <fb54be9c497f.53af14a5@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
Content-language: en
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

For system calls such as openat I might wish to use the value -1 for
the directory file descriptor parameter to indicate that a path passed
in must be an absolute path. However, it has occurred to me that such
a usage isn't defined by POSIX and isn't safe for the future. In the
future -1 may be taken to be used for some other special purpose. I
would like a solution for that problem.

It'd be nice if we could define a constant (maybe call it AT_FDNODIR)
to maybe -1 that is set aside to mean that no directory is to be used
and that will not ever be ever used for some other purpose in the
future. This way I would be able to use this feature in the future and
not accidentally trigger unexpected functionality that might result in
application misbehaviour or even security holes. This would require
absolutely zero changes in the code and only documentation
changes. Eventually, GLibc would have to define the constant in their
headers for Linux features but I expect most people would define it
themselves for now. The documentation might be something like: "If
dirfd is AT_FDNODIR (defined to be -1) then pathname must be
absolute." Eventually, in the far off future people might want to
deprecate the various *at system calls and upgrade them with new
versions so that new AT_FD* constants can be used. When that happens
AT_FDNODIR would be preserved as a constant requiring that the
pathname must be absolute.

Alternatively, there is no point to adding new AT_FD* constants and
the developers of Linux can promise that in the future any constant
except for the current value of AT_FDCWD will have the present effect
that they have. Note that in the future other interests like POSIX
might want to add new AT_FD* constants so even if the developers of
Linux don't care about adding new AT_FD* constants there still might
be pressure for them to add new AT_FD* constants.

Of course, one might argue that the feature of requiring an absolute
path in a system call is pointless and should not be supported. I
would argue that many system calls have potential security risks and
problems if they do not refer to an absolute path. In particular, this
feature would be useful for the proposed execveat system call (which
has the same problem with close on execute files as fexecve does).

I would be happy with either of the first two approaches and argue
against but still accept the Linux developers arguing the feature is
useless.

Thank you,
Steven Stewart-Gallus
