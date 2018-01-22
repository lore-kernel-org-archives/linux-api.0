From: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC PATCH 2/2] arm64: signal: Ensure si_code is valid for all fault signals
Date: Mon, 22 Jan 2018 12:23:18 +0000
Message-ID: <1516623798-25001-3-git-send-email-Dave.Martin@arm.com>
References: <1516623798-25001-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516623798-25001-1-git-send-email-Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

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

Reported-by: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Dave Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm64/kernel/fpsimd.c |   4 +-
 arch/arm64/mm/fault.c      | 114 ++++++++++++++++++++++-----------------------
 2 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 2d6ba9e..7ce23e0 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -286,8 +286,8 @@ static void task_fpsimd_save(void)
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
index 9b7f89d..4baa922 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -596,7 +596,7 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 
 	info.si_signo = SIGBUS;
 	info.si_errno = 0;
-	info.si_code  = 0;
+	info.si_code  = BUS_OBJERR;
 	if (esr & ESR_ELx_FnV)
 		info.si_addr = NULL;
 	else
@@ -607,70 +607,70 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 }
 
 static const struct fault_info fault_info[] = {
-	{ do_bad,		SIGBUS,  0,		"ttbr address size fault"	},
-	{ do_bad,		SIGBUS,  0,		"level 1 address size fault"	},
-	{ do_bad,		SIGBUS,  0,		"level 2 address size fault"	},
-	{ do_bad,		SIGBUS,  0,		"level 3 address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"level 2 address size fault"	},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"level 3 address size fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 0 translation fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 1 translation fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 2 translation fault"	},
 	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level 3 translation fault"	},
-	{ do_bad,		SIGBUS,  0,		"unknown 8"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 8"			},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 access flag fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 access flag fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 access flag fault"	},
-	{ do_bad,		SIGBUS,  0,		"unknown 12"			},
+	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 12"			},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
 	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
-	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},
-	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
-	{ do_sea,		SIGBUS,  0,		"level 0 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  0,		"level 1 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  0,		"level 2 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  0,		"level 3 (translation table walk)"	},
-	{ do_sea,		SIGBUS,  0,		"synchronous parity or ECC error" },	// Reserved when RAS is implemented
-	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
-	{ do_sea,		SIGBUS,  0,		"level 0 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_sea,		SIGBUS,  0,		"level 1 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_sea,		SIGBUS,  0,		"level 2 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_sea,		SIGBUS,  0,		"level 3 synchronous parity error (translation table walk)"	},	// Reserved when RAS is implemented
-	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
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
-	{ do_bad,		SIGBUS,  0,		"unknown 34"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 35"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 36"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 37"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 38"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 39"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 40"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 41"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 42"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 43"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 44"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 45"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 46"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 47"			},
-	{ do_bad,		SIGBUS,  0,		"TLB conflict abort"		},
-	{ do_bad,		SIGBUS,  0,		"Unsupported atomic hardware update fault"	},
-	{ do_bad,		SIGBUS,  0,		"unknown 50"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 51"			},
-	{ do_bad,		SIGBUS,  0,		"implementation fault (lockdown abort)" },
-	{ do_bad,		SIGBUS,  0,		"implementation fault (unsupported exclusive)" },
-	{ do_bad,		SIGBUS,  0,		"unknown 54"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 55"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 56"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 57"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 58" 			},
-	{ do_bad,		SIGBUS,  0,		"unknown 59"			},
-	{ do_bad,		SIGBUS,  0,		"unknown 60"			},
-	{ do_bad,		SIGBUS,  0,		"section domain fault"		},
-	{ do_bad,		SIGBUS,  0,		"page domain fault"		},
-	{ do_bad,		SIGBUS,  0,		"unknown 63"			},
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
@@ -739,11 +739,11 @@ static struct fault_info __refdata debug_fault_info[] = {
 	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware breakpoint"	},
 	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware single-step"	},
 	{ do_bad,	SIGTRAP,	TRAP_HWBKPT,	"hardware watchpoint"	},
-	{ do_bad,	SIGBUS,		0,		"unknown 3"		},
+	{ do_bad,	SIGKILL,	SI_KERNEL,	"unknown 3"		},
 	{ do_bad,	SIGTRAP,	TRAP_BRKPT,	"aarch32 BKPT"		},
-	{ do_bad,	SIGTRAP,	0,		"aarch32 vector catch"	},
+	{ do_bad,	SIGKILL,	SI_KERNEL,	"aarch32 vector catch"	},
 	{ early_brk64,	SIGTRAP,	TRAP_BRKPT,	"aarch64 BRK"		},
-	{ do_bad,	SIGBUS,		0,		"unknown 7"		},
+	{ do_bad,	SIGKILL,	SI_KERNEL,	"unknown 7"		},
 };
 
 void __init hook_debug_fault_code(int nr,
-- 
2.1.4
