From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/24] Lock down perf
Date: Wed, 11 Apr 2018 17:27:09 +0100
Message-ID: <152346402954.4030.7078270243543630603.stgit@warthog.procyon.org.uk>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Disallow the use of certain perf facilities that might allow userspace to
access kernel data.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/events/core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fc1c330c6bd6..1922f2e0980a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10407,6 +10407,11 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	if ((attr.sample_type & PERF_SAMPLE_REGS_INTR) &&
+	    kernel_is_locked_down("PERF_SAMPLE_REGS_INTR"))
+		/* REGS_INTR can leak data, lockdown must prevent this */
+		return -EPERM;
+
 	/* Only privileged users can get physical addresses */
 	if ((attr.sample_type & PERF_SAMPLE_PHYS_ADDR) &&
 	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
