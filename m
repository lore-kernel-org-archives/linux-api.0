From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/15] kexec: New syscall kexec_file_load() declaration
Date: Thu, 26 Jun 2014 16:43:03 -0400
Message-ID: <20140626204303.GE11136@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-9-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403814824-7587-9-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chaowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 26, 2014 at 04:33:37PM -0400, Vivek Goyal wrote:
> This is the new syscall kexec_file_load() declaration/interface. I have
> reserved the syscall number only for x86_64 so far. Other architectures
> (including i386) can reserve syscall number when they enable the support
> for this new syscall.
> 
> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michael,

As per feedback last time, I enhanced the existing man page to include
details of this new syscall. Here is the patch.

Thanks
Vivek


Subject: kexec_file_load() syscall man page

We already have man page for kexec_load() syscall. This patch adds details
of kexec_file_load() to same man page.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 man2/kexec_file_load.2 |    1 
 man2/kexec_load.2      |   55 +++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 6 deletions(-)

Index: man-pages/man2/kexec_file_load.2
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ man-pages/man2/kexec_file_load.2	2014-06-25 17:39:12.056441803 -0400
@@ -0,0 +1 @@
+.so man2/kexec_load.2
Index: man-pages/man2/kexec_load.2
===================================================================
--- man-pages.orig/man2/kexec_load.2	2014-06-25 17:36:09.237453355 -0400
+++ man-pages/man2/kexec_load.2	2014-06-26 11:11:49.599810213 -0400
@@ -25,17 +25,26 @@
 .\"
 .TH KEXEC_LOAD 2 2012-07-13 "Linux" "Linux Programmer's Manual"
 .SH NAME
-kexec_load \- load a new kernel for later execution
+kexec_load, kexec_file_load \- load a new kernel for later execution
 .SH SYNOPSIS
 .B #include <linux/kexec.h>
 .br
+
 .BI "long kexec_load(unsigned long " entry ", unsigned long " nr_segments ","
 .br
 .BI "                struct kexec_segment *" segments \
 ", unsigned long " flags ");"
+.br
+
+.BI "int kexec_file_load(int " kernel_fd ", int " initrd_fd ","
+.br
+.BI "                    unsigned long " cmdline_len  \
+", const char *" cmdline ","
+.br
+.BI "                    unsigned long " flags ");"
 
 .IR Note :
-There is no glibc wrapper for this system call; see NOTES.
+There are no glibc wrappers for these system calls; see NOTES.
 .SH DESCRIPTION
 The
 .BR kexec_load ()
@@ -111,11 +120,42 @@ struct kexec_segment {
 The kernel image defined by
 .I segments
 is copied from the calling process into previously reserved memory.
+.SS kexec_file_load()
+The
+.BR kexec_file_load ()
+system call is similar to
+.BR kexec_load(),
+but it takes a different set of arguments. It reads kernel to be loaded from
+file descriptor
+.IR kernel_fd
+and initrd to be loaded from file descriptor
+.IR initrd_fd .
+It also takes length of kernel command line in
+.IR cmdline_len
+and pointer to command line in
+.IR cmdline .
+
+The
+.IR flags
+argument is a mask which allows control over system call operation. The
+following values can be specified in
+.IR flags
+
+.TP
+.BR KEXEC_FILE_UNLOAD
+Unload currently loaded kernel.
+.TP
+.BR KEXEC_FILE_ON_CRASH
+Load kernel in memory region reserved for crash kernel. This kernel is
+booted into if currently running kernel crashes.
+.TP
+.BR KEXEC_FILE_NO_INITRAMFS
+Loading initrd/initramfs is optional. Specify this flag if no initramfs
+is being loaded. If this flag is set, kernel will ignore the value passed
+in
+.IR initrd_fd
 .SH RETURN VALUE
-On success,
-.BR kexec_load ()
-returns 0.
-On error, \-1 is returned and
+On success, these system calls returns 0.  On error, \-1 is returned and
 .I errno
 is set to indicate the error.
 .SH ERRORS
@@ -135,6 +175,9 @@ is too large
 The caller does not have the
 .BR CAP_SYS_BOOT
 capability.
+.TP
+.B ENOEXEC
+kernel_fd does not refer to an open file. Or kernel can't load this file.
 .SH VERSIONS
 The
 .BR kexec_load ()
