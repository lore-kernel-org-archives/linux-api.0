From: Aubrey Li <aubrey.li@linux.intel.com>
Subject: [PATCH v16 3/3] Documentation/filesystems/proc.txt: add AVX512_elapsed_ms
Date: Wed, 17 Apr 2019 18:18:40 +0800
Message-ID: <20190417101840.2926-3-aubrey.li@linux.intel.com>
References: <20190417101840.2926-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417101840.2926-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com
Cc: ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Aubrey Li <aubrey.li@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Added AVX512_elapsed_ms in /proc/<pid>/status. Report it
in Documentation/filesystems/proc.txt

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux API <linux-api@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/filesystems/proc.txt | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 66cad5c86171..c4a9e48681ad 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -207,6 +207,7 @@ read the file /proc/PID/status:
   Speculation_Store_Bypass:       thread vulnerable
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
+  AVX512_elapsed_ms:	8
 
 This shows you nearly the same information you would get if you viewed it with
 the ps  command.  In  fact,  ps  uses  the  proc  file  system  to  obtain its
@@ -224,7 +225,7 @@ asynchronous manner and the value may not be very precise. To see a precise
 snapshot of a moment, you can see /proc/<pid>/smaps file and scan page table.
 It's slow but very precise.
 
-Table 1-2: Contents of the status files (as of 4.19)
+Table 1-2: Contents of the status files (as of 5.1)
 ..............................................................................
  Field                       Content
  Name                        filename of the executable
@@ -289,6 +290,32 @@ Table 1-2: Contents of the status files (as of 4.19)
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
  nonvoluntary_ctxt_switches  number of non voluntary context switches
+ AVX512_elapsed_ms           time elapsed since last AVX512 usage recorded
+
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
+  task is a real AVX512 user or not.
+
+  A special value of '-1' indicates that no AVX512 usage was recorded, thus
+  the task is unlikely an AVX512 user, but depends on the workload and the
+  scheduling scenario, it also could be a false negative mentioned above.
+
 ..............................................................................
 
 Table 1-3: Contents of the statm files (as of 2.6.8-rc3)
-- 
2.21.0
