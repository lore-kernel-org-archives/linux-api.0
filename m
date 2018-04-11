From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/24] security: Add kernel lockdown
Date: Wed, 11 Apr 2018 17:24:39 +0100
Message-ID: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org


Hi Linus,

I've modified my lockdown mode patches to remove the EFI/secure-boot
interaction and to ignore kexec.  Would you be willing to accept this?

David
---

Here's a set of patches to institute a "locked-down mode" in the kernel.
If enabled, the lockdown can be triggered either by configuration (in which
case it cannot be lifted) or by command line (lockdown=1).  In the latter
case, there's an option to allow it to be lifted by a SysRq key on an
attached keyboard.

Three config options are provided:

 (1) CONFIG_LOCK_DOWN_KERNEL makes lockdown mode available.

 (2) CONFIG_LOCK_DOWN_MANDATORY builds the kernel with lockdown mode
     enabled at compile time and removes the ability to disable it.

 (3) CONFIG_ALLOW_LOCKDOWN_LIFT_BY_SYSRQ will allow a SysRq combination to
     lift the lockdown.  On x86 this is SysRq+x.  The keys must be pressed
     on an attached keyboard.  Echoing into the trigger file won't work.

Inside the kernel, kernel_is_locked_down() is used to check if the kernel
is in lockdown mode.

For the moment, there is only one mode that locks everything down.  Andy
would prefer that there be two modes, one of which allows the kernel to be
read, but not modified and the other which allows neither.  Modifying this
later to allow what Andy wants wouldn't be particularly hard as there isn't
much additional functionality that this would enable (ie. /dev/kmem,
/dev/kcore, bpf and perf).

A manual page, kernel_lockdown.7, is proposed, to which people will be
directed by messages in dmesg.  This lists the features that are restricted
amongst other things.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	tags/lockdown-20180410
	
The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=lockdown

---
David Howells (11):
      Add the ability to lock down access to the running kernel image
      Enforce module signatures if the kernel is locked down
      Prohibit PCMCIA CIS storage when the kernel is locked down
      Lock down TIOCSSERIAL
      Lock down module params that specify hardware parameters (eg. ioport)
      x86/mmiotrace: Lock down the testmmiotrace module
      Lock down /proc/kcore
      Lock down kprobes
      bpf: Restrict kernel image access functions when the kernel is locked down
      Lock down perf
      debugfs: Restrict debugfs when the kernel is locked down

Josh Boyer (2):
      hibernate: Disable when the kernel is locked down
      acpi: Ignore acpi_rsdp kernel param when the kernel has been locked down

Kyle McMartin (1):
      Add a SysRq option to lift kernel lockdown

Linn Crosetto (2):
      acpi: Disable ACPI table override if the kernel is locked down
      acpi: Disable APEI error injection if the kernel is locked down

Matthew Garrett (7):
      Restrict /dev/{mem,kmem,port} when the kernel is locked down
      kexec_load: Disable at runtime if the kernel is locked down
      uswsusp: Disable when the kernel is locked down
      PCI: Lock down BAR access when the kernel is locked down
      x86: Lock down IO port access when the kernel is locked down
      x86/msr: Restrict MSR access when the kernel is locked down
      ACPI: Limit access to custom_method when the kernel is locked down

Mimi Zohar (1):
      ima: require secure_boot rules in lockdown mode


 arch/x86/include/asm/setup.h        |    2 +
 arch/x86/kernel/ioport.c            |    6 +-
 arch/x86/kernel/msr.c               |   10 +++
 arch/x86/kernel/setup.c             |    2 +
 arch/x86/mm/testmmiotrace.c         |    3 +
 drivers/acpi/apei/einj.c            |    3 +
 drivers/acpi/custom_method.c        |    3 +
 drivers/acpi/osl.c                  |    2 -
 drivers/acpi/tables.c               |    5 ++
 drivers/char/mem.c                  |    2 +
 drivers/input/misc/uinput.c         |    1 
 drivers/pci/pci-sysfs.c             |    9 +++
 drivers/pci/proc.c                  |    9 +++
 drivers/pci/syscall.c               |    3 +
 drivers/pcmcia/cistpl.c             |    3 +
 drivers/tty/serial/serial_core.c    |    6 ++
 drivers/tty/sysrq.c                 |   19 ++++--
 fs/debugfs/file.c                   |   28 +++++++++
 fs/debugfs/inode.c                  |   30 +++++++++
 fs/proc/kcore.c                     |    2 +
 include/linux/input.h               |    5 ++
 include/linux/kernel.h              |   32 ++++++++++
 include/linux/sysrq.h               |    8 ++-
 kernel/bpf/syscall.c                |    3 +
 kernel/debug/kdb/kdb_main.c         |    2 -
 kernel/events/core.c                |    5 ++
 kernel/kexec.c                      |    7 ++
 kernel/kprobes.c                    |    3 +
 kernel/module.c                     |   56 +++++++++++++-----
 kernel/params.c                     |   26 +++++++-
 kernel/power/hibernate.c            |    2 -
 kernel/power/user.c                 |    3 +
 security/Kconfig                    |   34 ++++++++++-
 security/Makefile                   |    3 +
 security/integrity/ima/ima_policy.c |   39 +++++++++---
 security/lock_down.c                |  112 +++++++++++++++++++++++++++++++++++
 36 files changed, 443 insertions(+), 45 deletions(-)
 create mode 100644 security/lock_down.c
