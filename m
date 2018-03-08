From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3] arm64: signal: Ensure si_code is valid for all fault
 signals
Date: Thu,  8 Mar 2018 17:41:05 +0000
Message-ID: <1520530865-26554-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: linux-api@vger.kernel.org

Changes since v2:

 * Rebased to v4.16-rc4.

 * Split out the SIGFPE related changes (which impact core/x86 code)
   into a separate series.

Original blurb:

Currently, as reported by Eric, an invalid si_code value 0 is
passed in many signals delivered to userspace in response to faults
and other kernel errors.  Typically 0 is passed when the fault is
insufficiently diagnosable or when there does not appear to be any
sensible alternative value to choose.

This appears to violate POSIX, and is intuitively wrong for at
least two reasons arising from the fact that 0 == SI_USER:

 1) si_code is a union selector, and SI_USER (and si_code <= 0 in
    general) implies the existence of a different set of fields
    (siginfo._kill) from that which exists for a fault signal
    (siginfo._sigfault).  However, the code raising the signal
    typically writes only the _sigfault fields, and the _kill
    fields make no sense in this case.

    Thus when userspace sees si_code == 0 (SI_USER) it may
    legitimately inspect fields in the inactive union member _kill
    and obtain garbage as a result.

    There appears to be software in the wild relying on this,
    albeit generally only for printing diagnostic messages.

 2) Software that wants to be robust against spurious signals may
    discard signals where si_code == SI_USER (or <= 0), or may
    filter such signals based on the si_uid and si_pid fields of
    siginfo._sigkill.  In the case of fault signals, this means
    that important (and usually fatal) error conditions may be
    silently ignored.

In practice, many of the faults for which arm64 passes si_code == 0
are undiagnosable conditions such as exceptions with syndrome
values in ESR_ELx to which the architecture does not yet assign any
meaning, or conditions indicative of a bug or error in the kernel
or system and thus that are unrecoverable and should never occur in
normal operation.

The approach taken in this patch is to translate all such
undiagnosable or "impossible" synchronous fault conditions to
SIGKILL, since these are at least probably localisable to a single
process.  Some of these conditions should really result in a kernel
panic, but due to the lack of diagnostic information it is
difficult to be certain: this patch does not add any calls to
panic(), but this could change later if justified.

Although si_code will not reach userspace in the case of SIGKILL,
it is still desirable to pass a nonzero value so that the common
siginfo handling code can detect incorrect use of si_code == 0
without false positives.  In this case the si_code dependent
siginfo fields will not be correctly initialised, but since they
are not passed to userspace I deem this not to matter.

A few faults can reasonably occur in realistic userspace scenarios,
and _should_ raise a regular, handleable (but perhaps not
ignorable/blockable) signal: for these, this patch attempts to
choose a suitable standard si_code value for the raised signal in
each case instead of 0.

arm64 was the only arch to define a BUS_FIXME code, so after this
patch nobody defines it.  This patch therefore also removes the
relevant code from siginfo_layout().

Cc: James Morse <james.morse@arm.com>
Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

 arch/arm64/include/uapi/asm/siginfo.h |  14 ----
 arch/arm64/kernel/fpsimd.c            |   4 +-
 arch/arm64/mm/fault.c                 | 116 +++++++++++++++++-----------------
 kernel/signal.c                       |   4 --
 4 files changed, 60 insertions(+), 78 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
index 9b4d912..8d7dbbc 100644
--- a/arch/arm64/include/uapi/asm/siginfo.h
+++ b/arch/arm64/include/uapi/asm/siginfo.h
@@ -28,18 +28,4 @@
 #define FPE_FIXME	0	/* Broken dup of SI_USER */
 #endif /* __KERNEL__ */
 
-/*
- * SIGBUS si_codes
- */
-#ifdef __KERNEL__
-#define BUS_FIXME	0	/* Broken dup of SI_USER */
-#endif /* __KERNEL__ */
-
-/*
- * SIGTRAP si_codes
- */
-#ifdef __KERNEL__
-#define TRAP_FIXME	0	/* Broken dup of SI_USER */
-#endif /* __KERNEL__ */
-
 #endif
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index e7226c4..c2e87a20 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -285,8 +285,8 @@ static void task_fpsimd_save(void)
 				 * re-enter user with corrupt state.
 				 * There's no way to recover, so kill it:
 				 */
-				force_signal_inject(
-					SIGKILL, 0, current_pt_regs(), 0);
+				force_signal_inject(SIGKILL, SI_KERNEL,
+						    current_pt_regs(), 0);
 				return;
 			}
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index bff1155..c7c85c3 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -600,9 +600,9 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 			nmi_exit();
 	}
 
-	info.si_signo = SIGBUS;
+	info.si_signo = inf->sig;
 	info.si_errno = 0;
-	info.si_code  = BUS_FIXME;
+	info.si_code  = inf->code;
 	if (esr & ESR_ELx_FnV)
 		info.si_addr = NULL;
 	else
@@ -613,70 +613,70 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 }
 
 static const struct fault_info fault_info[] = {
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"ttbr address size fault"	},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"level 1 address size fault"	},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"level 2 address size fault"	},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"level 3 address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"level 2 address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"level 3 address size fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 0 translation fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 1 translation fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 2 translation fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 3 translation fault"	},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 8"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 8"			},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 access flag fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 access flag fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 access flag fault"	},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 12"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 12"			},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"synchronous external abort"	},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 17"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 18"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 19"			},
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 0 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 1 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 2 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 3 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"synchronous parity or ECC error" },	// Reserved when RAS is implemented
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 25"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 26"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 27"			},
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 0 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 1 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 2 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_sea,		SIGBUS,  BUS_FIXME,	"level 3 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 32"			},
+	{ do_sea,		SIGBUS,  BUS_OBJERR,	"synchronous external abort"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 17"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 18"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 19"			},
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 0 (translation table walk)"	},
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 1 (translation table walk)"	},
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 2 (translation table walk)"	},
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 3 (translation table walk)"	},
+	{ do_sea,		SIGBUS,  BUS_OBJERR,	"synchronous parity or ECC error" },	// Reserved when RAS is implemented
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 25"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 26"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 27"			},
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 0 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 1 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 2 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
+	{ do_sea,		SIGKILL, SI_KERNEL,	"level 3 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 32"			},
 	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 34"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 35"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 36"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 37"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 38"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 39"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 40"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 41"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 42"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 43"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 44"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 45"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 46"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 47"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"TLB conflict abort"		},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"Unsupported atomic hardware update fault"	},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 50"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 51"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"implementation fault (lockdown abort)" },
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"implementation fault (unsupported exclusive)" },
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 54"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 55"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 56"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 57"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 58" 			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 59"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 60"			},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"section domain fault"		},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"page domain fault"		},
-	{ do_bad,		SIGBUS,  BUS_FIXME,	"unknown 63"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 34"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 35"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 36"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 37"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 38"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 39"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 40"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 41"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 42"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 43"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 44"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 45"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 46"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 47"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"TLB conflict abort"		},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"Unsupported atomic hardware update fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 50"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 51"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"implementation fault (lockdown abort)" },
+	{ do_bad,		SIGBUS,  BUS_OBJERR,	"implementation fault (unsupported exclusive)" },
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 54"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 55"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 56"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 57"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 58" 			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 59"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 60"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"section domain fault"		},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"page domain fault"		},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 63"			},
 };
 
 int handle_guest_sea(phys_addr_t addr, unsigned int esr)
@@ -774,11 +774,11 @@ static struct fault_info __refdata debug_fault_info[] = {
 	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware breakpoint"	},
 	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware single-step"	},
 	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware watchpoint"	},
-	{ do_bad,	SIGBUS,		BUS_FIXME,	"unknown 3"		},
+	{ do_bad,	SIGKILL,	SI_KERNEL,	"unknown 3"		},
 	{ do_bad,	SIGTRAP,	TRAP_BRKPT,	"aarch32 BKPT"		},
-	{ do_bad,	SIGTRAP,	TRAP_FIXME,	"aarch32 vector catch"	},
+	{ do_bad,	SIGKILL,	SI_KERNEL,	"aarch32 vector catch"	},
 	{ early_brk64,	SIGTRAP,	TRAP_BRKPT,	"aarch64 BRK"		},
-	{ do_bad,	SIGBUS,		BUS_FIXME,	"unknown 7"		},
+	{ do_bad,	SIGKILL,	SI_KERNEL,	"unknown 7"		},
 };
 
 void __init hook_debug_fault_code(int nr,
diff --git a/kernel/signal.c b/kernel/signal.c
index c6e4c83d..049a482 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2844,10 +2844,6 @@ enum siginfo_layout siginfo_layout(int sig, int si_code)
 		if ((sig == SIGFPE) && (si_code == FPE_FIXME))
 			layout = SIL_FAULT;
 #endif
-#ifdef BUS_FIXME
-		if ((sig == SIGBUS) && (si_code == BUS_FIXME))
-			layout = SIL_FAULT;
-#endif
 	}
 	return layout;
 }
-- 
2.1.4
