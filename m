From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ioctl_ficlone/clonerange/dedupe: fix licensing
Date: Thu, 9 Jun 2016 10:36:58 -0700
Message-ID: <20160609173658.GB10371@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

These are licensed under GPLv2, not VERBATIM.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/ioctl_ficlonerange.2  |   22 ++++++++++++++--------
 man2/ioctl_fideduperange.2 |   22 ++++++++++++++--------
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
index c6e0762..d1da3e6 100644
--- a/man2/ioctl_ficlonerange.2
+++ b/man2/ioctl_ficlonerange.2
@@ -1,18 +1,24 @@
-.\" Copyright (C) 2016 Oracle.  All rights reserved.
+.\" Copyright (c) 2016, Oracle.  All rights reserved.
 .\"
-.\" %%%LICENSE_START(VERBATIM)
-.\" This program is free software; you can redistribute it and/or
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
 .\" modify it under the terms of the GNU General Public License as
-.\" published by the Free Software Foundation.
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
 .\"
-.\" This program is distributed in the hope that it would be useful,
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
 .\" but WITHOUT ANY WARRANTY; without even the implied warranty of
 .\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 .\" GNU General Public License for more details.
 .\"
-.\" You should have received a copy of the GNU General Public License
-.\" along with this program; if not, write the Free Software Foundation,
-.\" Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .TH IOCTL-FICLONERANGE 2 2016-02-10 "Linux" "Linux Programmer's Manual"
 .SH NAME
diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
index 44a7765..fd63ff8 100644
--- a/man2/ioctl_fideduperange.2
+++ b/man2/ioctl_fideduperange.2
@@ -1,18 +1,24 @@
-.\" Copyright (C) 2016 Oracle.  All rights reserved.
+.\" Copyright (c) 2016, Oracle.  All rights reserved.
 .\"
-.\" %%%LICENSE_START(VERBATIM)
-.\" This program is free software; you can redistribute it and/or
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
 .\" modify it under the terms of the GNU General Public License as
-.\" published by the Free Software Foundation.
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
 .\"
-.\" This program is distributed in the hope that it would be useful,
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
 .\" but WITHOUT ANY WARRANTY; without even the implied warranty of
 .\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 .\" GNU General Public License for more details.
 .\"
-.\" You should have received a copy of the GNU General Public License
-.\" along with this program; if not, write the Free Software Foundation,
-.\" Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
 .\" %%%LICENSE_END
 .TH IOCTL-FIDEDUPERANGE 2 2016-02-10 "Linux" "Linux Programmer's Manual"
 .SH NAME
