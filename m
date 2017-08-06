From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH man] kcmp: Add KCMP_EPOLL_TFD description
Date: Sun, 6 Aug 2017 10:38:58 +0300
Message-ID: <20170806073858.GB1916@uranus.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

       KCMP_EPOLL_TFD
              Check whether the file descriptor idx1 of process pid1 present in epoll(7)
              instance described by idx2 of process  pid2.   The  argument  idx2  is  an
              address of structure where the target file is described.

                  struct kcmp_epoll_slot {
                       __u32 efd;
                       __u32 tfd;
                       __u64 toff;
                  };

              where  efd  is  epoll  file descriptor from epoll_create(2) call, tfd is a
              target file number, toff is a target file offset counted from zero.   Sev‐
              eral  different  targets  may  be registered with the same file descriptor
              number and setting specific offset helps to investigate each of them.

Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 man2/kcmp.2 |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

Index: man-pages/man2/kcmp.2
===================================================================
--- man-pages.orig/man2/kcmp.2
+++ man-pages/man2/kcmp.2
@@ -156,6 +156,44 @@ See the discussion of the
 .BR CLONE_VM
 flag in
 .BR clone (2).
+.TP
+.BR KCMP_EPOLL_TFD
+Check whether the file descriptor
+.I idx1
+of the process
+.I pid1
+present in
+.BR epoll (7)
+instance described by
+.I idx2
+of the process
+.IR pid2 .
+The argument
+.I idx2
+is an address of a structure where the target file is described.
+.in +4n
+.nf
+.sp
+struct kcmp_epoll_slot {
+	__u32 efd;
+	__u32 tfd;
+	__u64 toff;
+};
+.fi
+.in
+.sp
+where
+.I efd
+is epoll file descriptor from
+.BR epoll_create (2)
+call,
+.I tfd
+is a target file number,
+.I toff
+is a target file offset counted from zero.
+Several different targets may be registered with
+the same file descriptor number and setting specific
+offset helps to investigate each of them.
 .PP
 Note the
 .BR kcmp ()
@@ -246,6 +284,16 @@ Process
 or
 .I pid2
 does not exist.
+.TP
+.B EFAULT
+The epoll slot addressed by
+.I idx2
+is outside of the user's address space.
+.TP
+.B ENOENT
+The target file is not present in
+.BR epoll ()
+instance.
 .SH VERSIONS
 The
 .BR kcmp ()
