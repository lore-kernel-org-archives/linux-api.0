From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [PATCH] [RFC] vm: add a syscall to map a process memory into a
 pipe
Date: Wed, 1 Nov 2017 10:47:13 -0700
Message-ID: <20171101174712.GA26700@outlook.office365.com>
References: <20170810184616.22726-1-avagin@openvz.org>
 <CAKgNAkiSMhmK7JzVArAUejGPpfvKu0ut-WbFg=r22vk4p78PEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkiSMhmK7JzVArAUejGPpfvKu0ut-WbFg=r22vk4p78PEg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrei Vagin <avagin@openvz.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, criu@openvz.org, Arnd Bergmann <arnd@arndb.de>, Pavel Emelyanov <xemul@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

Hi Michael,

On Mon, Oct 30, 2017 at 01:47:31PM +0100, Michael Kerrisk (man-pages) wrote:
> On 10 August 2017 at 20:46, Andrei Vagin <avagin@openvz.org> wrote:
> > It is a hybrid of process_vm_readv() and vmsplice().
> >
> > vmsplice can map memory from a current address space into a pipe.
> > process_vm_readv can read memory of another process.
> >
> > A new system call can map memory of another process into a pipe.
> >
> > ssize_t process_vmsplice(pid_t pid, int fd, const struct iovec *iov,
> >                         unsigned long nr_segs, unsigned int flags)
> >
> > All arguments are identical with vmsplice except pid which specifies a
> > target process.
> 
> Can we have a man page for this new syscall please?

I think we can add a description for process_vmsplice into
man2/vmsplice.2. The patch is attached.

Thanks,
Andrei

> 
> Thanks,
> 
> Michael
> 
> 

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="0001-vmsplice.2-add-description-for-process_vmsplice.patch"

>From 923cbd38805f8017b6d86ac6a12c8f45a4117399 Mon Sep 17 00:00:00 2001
From: Andrei Vagin <avagin@openvz.org>
Date: Wed, 1 Nov 2017 10:26:06 -0700
Subject: [PATCH] vmsplice.2: add description for process_vmsplice

Signed-off-by: Andrei Vagin <avagin@openvz.org>
---
 man2/vmsplice.2 | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/man2/vmsplice.2 b/man2/vmsplice.2
index e3e61cf27..8b28b6fff 100644
--- a/man2/vmsplice.2
+++ b/man2/vmsplice.2
@@ -25,7 +25,7 @@
 .\"
 .TH VMSPLICE 2 2014-10-02 "Linux" "Linux Programmer's Manual"
 .SH NAME
-vmsplice \- splice user pages into a pipe
+vmsplice, process_vmsplice \- splice user pages into a pipe
 .SH SYNOPSIS
 .nf
 .BR "#define _GNU_SOURCE" "         /* See feature_test_macros(7) */"
@@ -34,6 +34,8 @@ vmsplice \- splice user pages into a pipe
 
 .BI "ssize_t vmsplice(int " fd ", const struct iovec *" iov ,
 .BI "                 unsigned long " nr_segs ", unsigned int " flags );
+.BI "ssize_t process_vmsplice(pid_t " pid ", int " fd ", const struct iovec *" iov ,
+.BI "                 unsigned long " nr_segs ", unsigned int " flags );
 .fi
 .\" Return type was long before glibc 2.7
 .SH DESCRIPTION
@@ -55,6 +57,12 @@ The file descriptor
 .I fd
 must refer to a pipe.
 
+The
+.BR process_vmsplice()
+system call maps user memory from the process identified by
+.I pid
+to the local pipe.
+
 The pointer
 .I iov
 points to an array of
@@ -114,6 +122,7 @@ Data must also be properly page aligned, both in memory and length.
 .\"	commit bd1a68b59c8e3bce45fb76632c64e1e063c3962d
 .\"
 .\" .... if we expect to later SPLICE_F_MOVE to the cache.
+
 .SH RETURN VALUE
 Upon successful completion,
 .BR vmsplice ()
@@ -145,6 +154,15 @@ set.
 .TP
 .B ENOMEM
 Out of memory.
+.TP
+.B ESRCH
+No process with ID
+.I pid
+exists.
+.TP
+.B EPERM
+The caller does not have permission to access the address space of the process
+.IR pid .
 .SH VERSIONS
 The
 .BR vmsplice ()
-- 
2.13.6


--fdj2RfSjLxBAspz7--
