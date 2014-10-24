From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC PATCH 1/1] arm64: Fix up /proc/cpuinfo
Date: Fri, 24 Oct 2014 14:56:40 +0100
Message-ID: <1414159000-27059-2-git-send-email-mark.rutland@arm.com>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414159000-27059-1-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, serban.constantinescu-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Commit d7a49086f263164a (arm64: cpuinfo: print info for all CPUs)
attempted to clean up /proc/cpuinfo, but due to concerns regarding
further changes was reverted in commit 5e39977edf6500fd (Revert "arm64:
cpuinfo: print info for all CPUs").

There are two major issues with the arm64 /proc/cpuinfo format
currently:

* The "Features" line describes (only) the 64-bit hwcaps, which is
  problematic for some 32-bit applications which attempt to parse it. As
  the same names are used for analogous ISA features (e.g. aes) despite
  these generally being architecturally unrelated, it is not possible to
  simply append the 64-bit and 32-bit hwcaps in a manner that might not
  be misleading to some applications.

  Various potential solutions have appeared in vendor kernels. Typically
  the format of the Features line varies depending on whether the task
  is 32-bit.

* Information is only printed regarding a single CPU. This does not
  match the ARM format, and does not provide sufficient information in
  big.LITTLE systems where CPUs are heterogeneous. The CPU information
  printed is queried from the current CPU's registers, which is racy
  w.r.t. cross-cpu migration.

This patch attempts to solve these issues. The following changes are
made:

* When a task with a LINUX32 personality attempts to read /proc/cpuinfo,
  the "Features" line contains the decoded 32-bit hwcaps, as with the
  arm port. Otherwise, the decoded 64-bit hwcaps are shown. This aligns
  with the behaviour of COMPAT_UTS_MACHINE and COMPAT_ELF_PLATFORM. In
  the absense of compat support, the Features line is empty.

  The set of hwcaps injected into a task's auxval are unaffected.

* Properties are printed per-cpu, as with the ARM port. The per-cpu
  information is queried from pre-recorded cpu information (as used by
  the sanity checks).

* As with the previous attempt at fixing up /proc/cpuinfo, the hardware
  field is removed. The only users so far are 32-bit applications tied
  to particular boards, so no portable applications should be affected,
  and this should prevent future tying to particular boards.

The following differences remain:

* No model_name is printed, as this cannot be queried from the hardware
  and cannot be provided in a stable fashion. Use of the CPU
  {implementor,variant,part,revision} fields is sufficient to identify a
  CPU and is portable across arm and arm64.

* The following system-wide properties are not provided, as they are not
  possible to provide generally. Programs relying on these are already
  tied to particular (32-bit only) boards:
  - Hardware
  - Revision
  - Serial

No software has yet been identified for which these remaining
differences are problematic.

Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ian Campbell <ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>
Cc: Serban Constantinescu <serban.constantinescu-5wv7dgnIgG8@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/arm64/kernel/setup.c | 96 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 72 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index edb146d..1834b33 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
 #include <linux/efi.h>
+#include <linux/personality.h>
 
 #include <asm/fixmap.h>
 #include <asm/cpu.h>
@@ -78,7 +79,6 @@ unsigned int compat_elf_hwcap2 __read_mostly;
 #endif
 
 static const char *cpu_name;
-static const char *machine_name;
 phys_addr_t __fdt_pointer __initdata;
 
 /*
@@ -310,8 +310,6 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
 		while (true)
 			cpu_relax();
 	}
-
-	machine_name = of_flat_dt_get_machine_name();
 }
 
 /*
@@ -446,14 +444,50 @@ static const char *hwcap_str[] = {
 	NULL
 };
 
+#ifdef CONFIG_COMPAT
+static const char *compat_hwcap_str[] = {
+	"swp",
+	"half",
+	"thumb",
+	"26bit",
+	"fastmult",
+	"fpa",
+	"vfp",
+	"edsp",
+	"java",
+	"iwmmxt",
+	"crunch",
+	"thumbee",
+	"neon",
+	"vfpv3",
+	"vfpv3d16",
+	"tls",
+	"vfpv4",
+	"idiva",
+	"idivt",
+	"vfpd32",
+	"lpae",
+	"evtstrm"
+};
+
+static const char *compat_hwcap2_str[] = {
+	"aes",
+	"pmull",
+	"sha1",
+	"sha2",
+	"crc32",
+	NULL
+};
+#endif /* CONFIG_COMPAT */
+
 static int c_show(struct seq_file *m, void *v)
 {
-	int i;
-
-	seq_printf(m, "Processor\t: %s rev %d (%s)\n",
-		   cpu_name, read_cpuid_id() & 15, ELF_PLATFORM);
+	int i, j;
 
 	for_each_online_cpu(i) {
+		struct cpuinfo_arm64 *cpuinfo = &per_cpu(cpu_data, i);
+		u32 midr = cpuinfo->reg_midr;
+
 		/*
 		 * glibc reads /proc/cpuinfo to determine the number of
 		 * online processors, looking for lines beginning with
@@ -462,24 +496,38 @@ static int c_show(struct seq_file *m, void *v)
 #ifdef CONFIG_SMP
 		seq_printf(m, "processor\t: %d\n", i);
 #endif
-	}
-
-	/* dump out the processor features */
-	seq_puts(m, "Features\t: ");
-
-	for (i = 0; hwcap_str[i]; i++)
-		if (elf_hwcap & (1 << i))
-			seq_printf(m, "%s ", hwcap_str[i]);
-
-	seq_printf(m, "\nCPU implementer\t: 0x%02x\n", read_cpuid_id() >> 24);
-	seq_printf(m, "CPU architecture: AArch64\n");
-	seq_printf(m, "CPU variant\t: 0x%x\n", (read_cpuid_id() >> 20) & 15);
-	seq_printf(m, "CPU part\t: 0x%03x\n", (read_cpuid_id() >> 4) & 0xfff);
-	seq_printf(m, "CPU revision\t: %d\n", read_cpuid_id() & 15);
 
-	seq_puts(m, "\n");
-
-	seq_printf(m, "Hardware\t: %s\n", machine_name);
+		/*
+		 * Dump out the common processor features in a single line.
+		 * Userspace should read the hwcaps with getauxval(AT_HWCAP)
+		 * rather than attempting to parse this, but there's a body of
+		 * software which does already (at least for 32-bit).
+		 */
+		seq_puts(m, "Features\t:");
+		if (personality(current->personality) == PER_LINUX32) {
+#ifdef CONFIG_COMPAT
+			for (j = 0; compat_hwcap_str[j]; j++)
+				if (compat_elf_hwcap & (1 << j))
+					seq_printf(m, " %s", compat_hwcap_str[j]);
+
+			for (j = 0; compat_hwcap2_str[j]; j++)
+				if (compat_elf_hwcap2 & (1 << j))
+					seq_printf(m, " %s", compat_hwcap2_str[j]);
+#endif /* CONFIG_COMPAT */
+		} else {
+			for (j = 0; hwcap_str[j]; j++)
+				if (elf_hwcap & (1 << j))
+					seq_printf(m, " %s", hwcap_str[j]);
+		}
+		seq_puts(m, "\n");
+
+		seq_printf(m, "CPU implementer\t: 0x%02x\n",
+			   MIDR_IMPLEMENTOR(midr));
+		seq_printf(m, "CPU architecture: 8\n");
+		seq_printf(m, "CPU variant\t: 0x%x\n", MIDR_VARIANT(midr));
+		seq_printf(m, "CPU part\t: 0x%03x\n", MIDR_PARTNUM(midr));
+		seq_printf(m, "CPU revision\t: %d\n\n", MIDR_REVISION(midr));
+	}
 
 	return 0;
 }
-- 
1.9.1
