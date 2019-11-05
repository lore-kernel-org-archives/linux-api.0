From: David Howells <dhowells@redhat.com>
Subject: Details on the UAPI of implementing notifications on pipes
Date: Tue, 05 Nov 2019 16:02:59 +0000
Message-ID: <18580.1572969779@warthog.procyon.org.uk>
References: <157262963995.13142.5568934007158044624.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157262963995.13142.5568934007158044624.stgit@warthog.procyon.org.uk>
Content-ID: <18579.1572969779.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

So to implement notifications on top of pipes, I've hacked it together a bi=
t
in the following ways:

 (1) I'm passing O_TMPFILE to the pipe2() system call to indicate that you
     want a notifications pipe.  This prohibits splice and co. from being
     called on it as I don't want to have to try to fix iov_iter_revert() t=
o
     handle kernel notifications being intermixed with splices.

     The choice of O_TMPFILE was just for convenience, but it needs to be
     something different.  I could, for instance, add a constant,
     O_NOTIFICATION_PIPE with the same *value* as O_TMPFILE.  I don't think
     it's likely that it will make sense to use O_TMPFILE with a pipe, but =
I
     also don't want to eat up another O_* constant just for this.

     Unfortunately, pipe2() doesn't have any other arguments into from whic=
h I
     can steal a bit.

 (2) I've added a pair of ioctls to configure the notifications bits.  They=
're
     ioctls as I just reused the ioctl code from my devmisc driver.  Should=
 I
     use fcntl() instead, such as is done for F_SETPIPE_SZ?

     The ioctls do two things: set the ring size to a number of slots (so
     similarish to F_SETPIPE_SZ) and set filters.

Any thoughts on how better to represent these bits?

Thanks,
David
