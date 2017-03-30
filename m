From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: RFC: reject unknown open flags
Date: Thu, 30 Mar 2017 18:33:25 +0200
Message-ID: <20170330163327.23920-1-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Linux has traditionally accepted random garbage in the flags argument to
the open syscall (including the later added openat).  This really harms
when adding new flags, because applications can't just probe for the
flag to actually work.  While rejecting unknown flags is an ABI change
strictly speaking I can't see what would actually get broken by it
in practice, so by the Linux rules it might not be an issue.

Below is the trivial series to reject unknown flags.  If this is not
acceptable there migh be some other ways, although they seem ugly:

 (a) add a new openat2 system call that enforces this behavior, and
     hope all majors libcs switch to using that by default to implement
     open(3).
 (b) add a new personality flag to enforce this behavior (or maybe
     opt in by default and allow admins to opt out of it)
