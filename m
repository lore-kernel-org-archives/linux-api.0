From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.21 03/16] mm: Replace BUG_ON() by WARN_ON() in vm_unmap_ram()
Date: Thu,  1 Nov 2018 10:58:31 +0100
Message-ID: <20181101095844.24462-4-mathieu.desnoyers@efficios.com>
References: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181101095844.24462-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Joel Fernandes <joelaf@google.com>, Mathieu Desnoyers <mathieu.desnoyers@ef>
List-Id: linux-api@vger.kernel.org

It is encouraged to warn and return rather than use BUG_ON() when
the condition can be recovered from in ways that are more graceful than
halting the whole system.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Matthew Wilcox <mawilcox@microsoft.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Boqun Feng <boqun.feng@gmail.com>
---
 mm/vmalloc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a728fc492557..a236bac872f0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1123,10 +1123,11 @@ void vm_unmap_ram(const void *mem, unsigned int count)
 	struct vmap_area *va;
 
 	might_sleep();
-	BUG_ON(!addr);
-	BUG_ON(addr < VMALLOC_START);
-	BUG_ON(addr > VMALLOC_END);
-	BUG_ON(!PAGE_ALIGNED(addr));
+	if (WARN_ON(!addr) ||
+	    WARN_ON(addr < VMALLOC_START) ||
+	    WARN_ON(addr > VMALLOC_END) ||
+	    WARN_ON(!PAGE_ALIGNED(addr)))
+		return;
 
 	if (likely(count <= VMAP_MAX_ALLOC)) {
 		debug_check_no_locks_freed(mem, size);
@@ -1135,7 +1136,8 @@ void vm_unmap_ram(const void *mem, unsigned int count)
 	}
 
 	va = find_vmap_area(addr);
-	BUG_ON(!va);
+	if (WARN_ON(!va))
+		return;
 	debug_check_no_locks_freed((void *)va->va_start,
 				    (va->va_end - va->va_start));
 	free_unmap_vmap_area(va);
-- 
2.11.0
