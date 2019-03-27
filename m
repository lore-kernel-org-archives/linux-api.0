From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v1 1/4] Make anon_inodes unconditional
Date: Wed, 27 Mar 2019 23:19:07 +0100
Message-ID: <20190327221910.5897-2-christian@brauner.io>
References: <20190327221910.5897-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327221910.5897-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Make the anon_inodes facility unconditional so that it can be used by core
VFS code and the pidfd_open() syscall.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[christian@brauner.io: adapt commit message to mention pidfd_open()]
Signed-off-by: Christian Brauner <christian@brauner.io>
---
 arch/arm/kvm/Kconfig       |  1 -
 arch/arm64/kvm/Kconfig     |  1 -
 arch/mips/kvm/Kconfig      |  1 -
 arch/powerpc/kvm/Kconfig   |  1 -
 arch/s390/kvm/Kconfig      |  1 -
 arch/x86/Kconfig           |  1 -
 arch/x86/kvm/Kconfig       |  1 -
 drivers/base/Kconfig       |  1 -
 drivers/char/tpm/Kconfig   |  1 -
 drivers/dma-buf/Kconfig    |  1 -
 drivers/gpio/Kconfig       |  1 -
 drivers/iio/Kconfig        |  1 -
 drivers/infiniband/Kconfig |  1 -
 drivers/vfio/Kconfig       |  1 -
 fs/Makefile                |  2 +-
 fs/notify/fanotify/Kconfig |  1 -
 fs/notify/inotify/Kconfig  |  1 -
 init/Kconfig               | 10 ----------
 18 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 3f5320f46de2..f591026347a5 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on MMU && OF
 	select PREEMPT_NOTIFIERS
-	select ANON_INODES
 	select ARM_GIC
 	select ARM_GIC_V3
 	select ARM_GIC_V3_ITS
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a3f85624313e..a67121d419a2 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -23,7 +23,6 @@ config KVM
 	depends on OF
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
-	select ANON_INODES
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 4528bc9c3cb1..eac25aef21e0 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -21,7 +21,6 @@ config KVM
 	depends on MIPS_FP_SUPPORT
 	select EXPORT_UASM
 	select PREEMPT_NOTIFIERS
-	select ANON_INODES
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_MMIO
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index bfdde04e4905..f53997a8ca62 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM
 	bool
 	select PREEMPT_NOTIFIERS
-	select ANON_INODES
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select SRCU
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 767453faacfc..1816ee48eadd 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -21,7 +21,6 @@ config KVM
 	prompt "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM
 	select PREEMPT_NOTIFIERS
-	select ANON_INODES
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_EVENTFD
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c1f9b3cf437c..18f2c954464e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -44,7 +44,6 @@ config X86
 	#
 	select ACPI_LEGACY_TABLES_LOOKUP	if ACPI
 	select ACPI_SYSTEM_POWER_STATES_SUPPORT	if ACPI
-	select ANON_INODES
 	select ARCH_32BIT_OFF_T			if X86_32
 	select ARCH_CLOCKSOURCE_DATA
 	select ARCH_CLOCKSOURCE_INIT
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 72fa955f4a15..fc042419e670 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -27,7 +27,6 @@ config KVM
 	depends on X86_LOCAL_APIC
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
-	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQFD
 	select IRQ_BYPASS_MANAGER
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 059700ea3521..03f067da12ee 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -174,7 +174,6 @@ source "drivers/base/regmap/Kconfig"
 config DMA_SHARED_BUFFER
 	bool
 	default n
-	select ANON_INODES
 	select IRQ_WORK
 	help
 	  This option enables the framework for buffer-sharing between
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 536e55d3919f..f3e4bc490cf0 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -157,7 +157,6 @@ config TCG_CRB
 config TCG_VTPM_PROXY
 	tristate "VTPM Proxy Interface"
 	depends on TCG_TPM
-	select ANON_INODES
 	---help---
 	  This driver proxies for an emulated TPM (vTPM) running in userspace.
 	  A device /dev/vtpmx is provided that creates a device pair
diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 2e5a0faa2cb1..3fc9c2efc583 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -3,7 +3,6 @@ menu "DMABUF options"
 config SYNC_FILE
 	bool "Explicit Synchronization Framework"
 	default n
-	select ANON_INODES
 	select DMA_SHARED_BUFFER
 	---help---
 	  The Sync File Framework adds explicit syncronization via
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3f50526a771f..0f91600c27ae 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -12,7 +12,6 @@ config ARCH_HAVE_CUSTOM_GPIO_H
 
 menuconfig GPIOLIB
 	bool "GPIO Support"
-	select ANON_INODES
 	help
 	  This enables GPIO support through the generic GPIO library.
 	  You only need to enable this, if you also want to enable
diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index d08aeb41cd07..1dec0fecb6ef 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig IIO
 	tristate "Industrial I/O support"
-	select ANON_INODES
 	help
 	  The industrial I/O subsystem provides a unified framework for
 	  drivers for many different types of embedded sensors using a
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index a1fb840de45d..d318bab25860 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -25,7 +25,6 @@ config INFINIBAND_USER_MAD
 
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
-	select ANON_INODES
 	depends on MMU
 	---help---
 	  Userspace InfiniBand access support.  This enables the
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 9de5ed38da83..3798d77d131c 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -22,7 +22,6 @@ menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
 	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
-	select ANON_INODES
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/vfio.txt for more details.
diff --git a/fs/Makefile b/fs/Makefile
index 427fec226fae..35945f8139e6 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_PROC_FS) += proc_namespace.o
 
 obj-y				+= notify/
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
-obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
+obj-y				+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
diff --git a/fs/notify/fanotify/Kconfig b/fs/notify/fanotify/Kconfig
index 735bfb2e9190..521dc91d2cb5 100644
--- a/fs/notify/fanotify/Kconfig
+++ b/fs/notify/fanotify/Kconfig
@@ -1,7 +1,6 @@
 config FANOTIFY
 	bool "Filesystem wide access notification"
 	select FSNOTIFY
-	select ANON_INODES
 	select EXPORTFS
 	default n
 	---help---
diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
index b981fc0c8379..0161c74e76e2 100644
--- a/fs/notify/inotify/Kconfig
+++ b/fs/notify/inotify/Kconfig
@@ -1,6 +1,5 @@
 config INOTIFY_USER
 	bool "Inotify support for userspace"
-	select ANON_INODES
 	select FSNOTIFY
 	default y
 	---help---
diff --git a/init/Kconfig b/init/Kconfig
index 4592bf7997c0..be8f97e37a76 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1171,9 +1171,6 @@ config LD_DEAD_CODE_DATA_ELIMINATION
 config SYSCTL
 	bool
 
-config ANON_INODES
-	bool
-
 config HAVE_UID16
 	bool
 
@@ -1378,14 +1375,12 @@ config HAVE_FUTEX_CMPXCHG
 config EPOLL
 	bool "Enable eventpoll support" if EXPERT
 	default y
-	select ANON_INODES
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
 
 config SIGNALFD
 	bool "Enable signalfd() system call" if EXPERT
-	select ANON_INODES
 	default y
 	help
 	  Enable the signalfd() system call that allows to receive signals
@@ -1395,7 +1390,6 @@ config SIGNALFD
 
 config TIMERFD
 	bool "Enable timerfd() system call" if EXPERT
-	select ANON_INODES
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer
@@ -1405,7 +1399,6 @@ config TIMERFD
 
 config EVENTFD
 	bool "Enable eventfd() system call" if EXPERT
-	select ANON_INODES
 	default y
 	help
 	  Enable the eventfd() system call that allows to receive both
@@ -1516,7 +1509,6 @@ config KALLSYMS_BASE_RELATIVE
 # syscall, maps, verifier
 config BPF_SYSCALL
 	bool "Enable bpf() system call"
-	select ANON_INODES
 	select BPF
 	select IRQ_WORK
 	default n
@@ -1533,7 +1525,6 @@ config BPF_JIT_ALWAYS_ON
 
 config USERFAULTFD
 	bool "Enable userfaultfd() system call"
-	select ANON_INODES
 	depends on MMU
 	help
 	  Enable the userfaultfd() system call that allows to intercept and
@@ -1600,7 +1591,6 @@ config PERF_EVENTS
 	bool "Kernel performance events and counters"
 	default y if PROFILING
 	depends on HAVE_PERF_EVENTS
-	select ANON_INODES
 	select IRQ_WORK
 	select SRCU
 	help
-- 
2.21.0
