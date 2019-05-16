From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH RFC 5/5] mm/ksm, proc: add remote madvise documentation
Date: Thu, 16 May 2019 11:42:34 +0200
Message-ID: <20190516094234.9116-6-oleksandr@redhat.com>
References: <20190516094234.9116-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516094234.9116-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Alexey Dobriyan <adobriyan@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Document respective /proc/<pid>/madvise knob.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 Documentation/filesystems/proc.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 66cad5c86171..17106e435bba 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -45,6 +45,7 @@ Table of Contents
   3.9   /proc/<pid>/map_files - Information about memory mapped files
   3.10  /proc/<pid>/timerslack_ns - Task timerslack value
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
+  3.12  /proc/<pid>/madvise - Remote madvise
 
   4	Configuring procfs
   4.1	Mount options
@@ -1948,6 +1949,18 @@ patched.  If the patch is being enabled, then the task has already been
 patched.  If the patch is being disabled, then the task hasn't been
 unpatched yet.
 
+3.12    /proc/<pid>/madvise - Remote madvise
+--------------------------------------------
+This write-only file allows executing madvise operation for another task.
+
+If CONFIG_KSM is enabled, the following actions are available:
+
+  * marking task's memory as mergeable:
+    # echo merge > /proc/<pid>/madvise
+
+  * unmerging all the task's memory:
+    # echo unmerge > /proc/<pid>/madvise
+
 
 ------------------------------------------------------------------------------
 Configuring procfs
-- 
2.21.0
