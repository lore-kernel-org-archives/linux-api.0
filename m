From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3.10 09/17] arm64: Fix up /proc/cpuinfo
Date: Mon,  9 Feb 2015 16:33:36 +0800
Message-ID: <20150209083040.217202212@linuxfoundation.org>
References: <20150209083039.240170510@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20150209083039.240170510@linuxfoundation.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, cross-distro@lists.linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Serban Constantinescu <serban.constantinescu@arm.com>, Will Deacon <will.deacon@arm.com>, Greg Hackmann <ghackmann@google.com>, stable@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 44b82b7700d05a52cd983799d3ecde1a976b3bed upstream.

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

Cc: Greg Hackmann <ghackmann@google.com>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: cross-distro@lists.linaro.org
Cc: linux-api@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
[Mark: backport to v3.10.x]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/cputype.h |    2 
 arch/arm64/kernel/setup.c        |  100 +++++++++++++++++++++++++++++----------
 arch/arm64/kernel/smp.c          |    5 +
 3 files changed, 82 insertions(+), 25 deletions(-)

--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -74,6 +74,8 @@ static inline u32 __attribute_const__ re
 	return read_cpuid(ID_CTR_EL0);
 }
 
+void cpuinfo_store_cpu(void);
+
 #endif /* __ASSEMBLY__ */
 
 #endif
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -41,6 +41,7 @@
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
+#include <linux/personality.h>
 
 #include <asm/cputype.h>
 #include <asm/elf.h>
@@ -97,6 +98,19 @@ void __init early_print(const char *str,
 	printk("%s", buf);
 }
 
+struct cpuinfo_arm64 {
+	struct cpu	cpu;
+	u32		reg_midr;
+};
+
+static DEFINE_PER_CPU(struct cpuinfo_arm64, cpu_data);
+
+void cpuinfo_store_cpu(void)
+{
+	struct cpuinfo_arm64 *info = this_cpu_ptr(&cpu_data);
+	info->reg_midr = read_cpuid_id();
+}
+
 static void __init setup_processor(void)
 {
 	struct cpu_info *cpu_info;
@@ -127,6 +141,8 @@ static void __init setup_machine_fdt(phy
 	struct boot_param_header *devtree;
 	unsigned long dt_root;
 
+	cpuinfo_store_cpu();
+
 	/* Check we have a non-NULL DT pointer */
 	if (!dt_phys) {
 		early_print("\n"
@@ -290,14 +306,12 @@ static int __init arm64_device_init(void
 }
 arch_initcall(arm64_device_init);
 
-static DEFINE_PER_CPU(struct cpu, cpu_data);
-
 static int __init topology_init(void)
 {
 	int i;
 
 	for_each_possible_cpu(i) {
-		struct cpu *cpu = &per_cpu(cpu_data, i);
+		struct cpu *cpu = &per_cpu(cpu_data.cpu, i);
 		cpu->hotpluggable = 1;
 		register_cpu(cpu, i);
 	}
@@ -312,14 +326,41 @@ static const char *hwcap_str[] = {
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
@@ -328,27 +369,36 @@ static int c_show(struct seq_file *m, vo
 #ifdef CONFIG_SMP
 		seq_printf(m, "processor\t: %d\n", i);
 #endif
-		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n\n",
+		seq_printf(m, "BogoMIPS\t: %lu.%02lu\n",
 			   loops_per_jiffy / (500000UL/HZ),
 			   loops_per_jiffy / (5000UL/HZ) % 100);
-	}
-
-	/* dump out the processor features */
-	seq_puts(m, "Features\t: ");
 
-	for (i = 0; hwcap_str[i]; i++)
-		if (elf_hwcap & (1 << i))
-			seq_printf(m, "%s ", hwcap_str[i]);
-
-	seq_printf(m, "\nCPU implementer\t: 0x%02x\n", read_cpuid_id() >> 24);
-	seq_printf(m, "CPU architecture: AArch64\n");
-	seq_printf(m, "CPU variant\t: 0x%x\n", (read_cpuid_id() >> 20) & 15);
-	seq_printf(m, "CPU part\t: 0x%03x\n", (read_cpuid_id() >> 4) & 0xfff);
-	seq_printf(m, "CPU revision\t: %d\n", read_cpuid_id() & 15);
-
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
+				if (COMPAT_ELF_HWCAP & (1 << j))
+					seq_printf(m, " %s", compat_hwcap_str[j]);
+#endif /* CONFIG_COMPAT */
+		} else {
+			for (j = 0; hwcap_str[j]; j++)
+				if (elf_hwcap & (1 << j))
+					seq_printf(m, " %s", hwcap_str[j]);
+		}
+		seq_puts(m, "\n");
+
+		seq_printf(m, "CPU implementer\t: 0x%02x\n", (midr >> 24));
+		seq_printf(m, "CPU architecture: 8\n");
+		seq_printf(m, "CPU variant\t: 0x%x\n", ((midr >> 20) & 0xf));
+		seq_printf(m, "CPU part\t: 0x%03x\n", ((midr >> 4) & 0xfff));
+		seq_printf(m, "CPU revision\t: %d\n\n", (midr & 0xf));
+	}
 
 	return 0;
 }
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -200,6 +200,11 @@ asmlinkage void __cpuinit secondary_star
 	raw_spin_unlock(&boot_lock);
 
 	/*
+	 * Log the CPU info before it is marked online and might get read.
+	 */
+	cpuinfo_store_cpu();
+
+	/*
 	 * OK, now it's safe to let the boot CPU continue.  Wait for
 	 * the CPU migration code to notice that the CPU is online
 	 * before we continue.
