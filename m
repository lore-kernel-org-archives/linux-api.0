From: robert.foss@collabora.com
Subject: [PACTH v4 3/3] Documentation/filesystems: Added /proc/PID/totmaps documentation
Date: Tue, 16 Aug 2016 18:33:24 -0400
Message-ID: <1471386804-7236-4-git-send-email-robert.foss@collabora.com>
References: <1471386804-7236-1-git-send-email-robert.foss@collabora.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1471386804-7236-1-git-send-email-robert.foss@collabora.com>
Sender: linux-doc-owner@vger.kernel.org
To: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, robert.foss@collabora.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, john.stultz@linaro.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, mnfhuang@gmail.com, adobriyan@gmail.com, calvinowens@fb.com, jdanis@google.com, jann@thejh.net, sonnyrao@chromium.org, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Mateusz Guzik <mguzik@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Robert Foss <robert.foss@collabora.com>

Added documentation covering /proc/PID/totmaps.

Signed-off-by: Robert Foss <robert.foss@collabora.com>
---
 Documentation/filesystems/proc.txt | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 7d001be..4cb97df 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -11,6 +11,7 @@ Version 1.3                                              Kernel version 2.2.12
 					      Kernel version 2.4.0-test11-pre4
 ------------------------------------------------------------------------------
 fixes/update part 1.1  Stefani Seibold <stefani@seibold.net>       June 9 2009
+add totmaps            Robert Foss <robert.foss@collabora.com>  August 12 2016
 
 Table of Contents
 -----------------
@@ -147,6 +148,8 @@ Table 1-1: Process specific entries in /proc
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		an extension based on maps, showing the memory consumption of
 		each mapping and flags associated with it
+ totmaps        an extension based on maps, showing the total memory
+                consumption of all mappings
  numa_maps	an extension based on maps, showing the memory locality and
 		binding policy as well as mem usage (in pages) of each mapping.
 ..............................................................................
@@ -512,6 +515,24 @@ be vanished or the reverse -- new added.
 This file is only present if the CONFIG_MMU kernel configuration option is
 enabled.
 
+The /proc/PID/totmaps is an extension based on maps, showing the memory
+consumption totals for all of the process's mappings. It lists the sums of the
+same statistics as /proc/PID/smaps.
+
+The process' mappings will be summarized as a series of lines like the
+following:
+
+Rss:                4256 kB
+Pss:                1170 kB
+Shared_Clean:       2720 kB
+Shared_Dirty:       1136 kB
+Private_Clean:         0 kB
+Private_Dirty:       400 kB
+Referenced:         4256 kB
+Anonymous:          1536 kB
+AnonHugePages:         0 kB
+Swap:                  0 kB
+
 The /proc/PID/clear_refs is used to reset the PG_Referenced and ACCESSED/YOUNG
 bits on both physical and virtual pages associated with a process, and the
 soft-dirty bit on pte (see Documentation/vm/soft-dirty.txt for details).
-- 
2.7.4

