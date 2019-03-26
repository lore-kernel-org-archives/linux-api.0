From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V31 11/25] x86: Lock down IO port access when the kernel is
 locked down
Date: Tue, 26 Mar 2019 11:27:27 -0700
Message-ID: <20190326182742.16950-12-matthewgarrett@google.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190326182742.16950-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Garrett <mjg59@google.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>

IO port access would permit users to gain access to PCI configuration
registers, which in turn (on a lot of hardware) give access to MMIO
register space. This would potentially permit root to trigger arbitrary
DMA, so lock it down by default.

This also implicitly locks down the KDADDIO, KDDELIO, KDENABIO and
KDDISABIO console ioctls.

Signed-off-by: Matthew Garrett <mjg59@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: x86@kernel.org
---
 arch/x86/kernel/ioport.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 0fe1c8782208..febbd7eb847c 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -31,7 +31,8 @@ long ksys_ioperm(unsigned long from, unsigned long num, int turn_on)
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
 		return -EINVAL;
-	if (turn_on && !capable(CAP_SYS_RAWIO))
+	if (turn_on && (!capable(CAP_SYS_RAWIO) ||
+			kernel_is_locked_down("ioperm", LOCKDOWN_INTEGRITY)))
 		return -EPERM;
 
 	/*
@@ -126,7 +127,8 @@ SYSCALL_DEFINE1(iopl, unsigned int, level)
 		return -EINVAL;
 	/* Trying to gain more privileges? */
 	if (level > old) {
-		if (!capable(CAP_SYS_RAWIO))
+		if (!capable(CAP_SYS_RAWIO) ||
+		    kernel_is_locked_down("iopl", LOCKDOWN_INTEGRITY))
 			return -EPERM;
 	}
 	regs->flags = (regs->flags & ~X86_EFLAGS_IOPL) |
-- 
2.21.0.392.gf8f6787159e-goog
