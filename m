From: tip-bot for Aubrey Li <tipbot@zytor.com>
Subject: [tip:x86/core] Documentation/filesystems/proc.txt: Add arch_status
 file
Date: Wed, 12 Jun 2019 05:36:19 -0700
Message-ID: <tip-711486fd18596315d42cebaac3dba8c408f60a3d@git.kernel.org>
References: <20190606012236.9391-3-aubrey.li@linux.intel.com>
Reply-To: linux-api@vger.kernel.org, ak@linux.intel.com, hpa@zytor.com,
          dave.hansen@intel.com, luto@kernel.org,
          linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
          adobriyan@gmail.com, arjan@linux.intel.com, tglx@linutronix.de,
          aubrey.li@linux.intel.com, mingo@kernel.org,
          peterz@infradead.org, tim.c.chen@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606012236.9391-3-aubrey.li@linux.intel.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Cc: adobriyan@gmail.com, arjan@linux.intel.com, tglx@linutronix.de, aubrey.li@linux.intel.com, peterz@infradead.org, mingo@kernel.org, tim.c.chen@linux.intel.com, linux-api@vger.kernel.org, dave.hansen@intel.com, hpa@zytor.com, ak@linux.intel.com, luto@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Commit-ID:  711486fd18596315d42cebaac3dba8c408f60a3d
Gitweb:     https://git.kernel.org/tip/711486fd18596315d42cebaac3dba8c408f60a3d
Author:     Aubrey Li <aubrey.li@linux.intel.com>
AuthorDate: Thu, 6 Jun 2019 09:22:36 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 12 Jun 2019 11:42:13 +0200

Documentation/filesystems/proc.txt: Add arch_status file

Add documentation for /proc/<pid>/arch_status file and the x86 specific
AVX512_elapsed_ms entry in it.

[ tglx: Massage changelog ]

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: akpm@linux-foundation.org
Cc: peterz@infradead.org
Cc: hpa@zytor.com
Cc: ak@linux.intel.com
Cc: tim.c.chen@linux.intel.com
Cc: dave.hansen@intel.com
Cc: arjan@linux.intel.com
Cc: adobriyan@gmail.com
Cc: aubrey.li@intel.com
Cc: linux-api@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux API <linux-api@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190606012236.9391-3-aubrey.li@linux.intel.com

---
 Documentation/filesystems/proc.txt | 40 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 66cad5c86171..a226061fa109 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -45,6 +45,7 @@ Table of Contents
   3.9   /proc/<pid>/map_files - Information about memory mapped files
   3.10  /proc/<pid>/timerslack_ns - Task timerslack value
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
+  3.12	/proc/<pid>/arch_status - Task architecture specific information
 
   4	Configuring procfs
   4.1	Mount options
@@ -1948,6 +1949,45 @@ patched.  If the patch is being enabled, then the task has already been
 patched.  If the patch is being disabled, then the task hasn't been
 unpatched yet.
 
+3.12 /proc/<pid>/arch_status - task architecture specific status
+-------------------------------------------------------------------
+When CONFIG_PROC_PID_ARCH_STATUS is enabled, this file displays the
+architecture specific status of the task.
+
+Example
+-------
+ $ cat /proc/6753/arch_status
+ AVX512_elapsed_ms:      8
+
+Description
+-----------
+
+x86 specific entries:
+---------------------
+ AVX512_elapsed_ms:
+ ------------------
+  If AVX512 is supported on the machine, this entry shows the milliseconds
+  elapsed since the last time AVX512 usage was recorded. The recording
+  happens on a best effort basis when a task is scheduled out. This means
+  that the value depends on two factors:
+
+    1) The time which the task spent on the CPU without being scheduled
+       out. With CPU isolation and a single runnable task this can take
+       several seconds.
+
+    2) The time since the task was scheduled out last. Depending on the
+       reason for being scheduled out (time slice exhausted, syscall ...)
+       this can be arbitrary long time.
+
+  As a consequence the value cannot be considered precise and authoritative
+  information. The application which uses this information has to be aware
+  of the overall scenario on the system in order to determine whether a
+  task is a real AVX512 user or not. Precise information can be obtained
+  with performance counters.
+
+  A special value of '-1' indicates that no AVX512 usage was recorded, thus
+  the task is unlikely an AVX512 user, but depends on the workload and the
+  scheduling scenario, it also could be a false negative mentioned above.
 
 ------------------------------------------------------------------------------
 Configuring procfs
