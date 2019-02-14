From: Keith Busch <keith.busch@intel.com>
Subject: [PATCHv6 00/10] Heterogenous memory node attributes
Date: Thu, 14 Feb 2019 10:10:07 -0700
Message-ID: <20190214171017.9362-1-keith.busch@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>
List-Id: linux-api@vger.kernel.org

== Changes since v5 ==

  Updated HMAT parsing to account for the recently released ACPI 6.3
  changes.

  HMAT attribute calculation overflow checks.

  Fixed memory leak if HMAT parse fails.

  Minor change to the patch order. All the base node attributes occur
  before HMAT usage for these new node attributes to resolve a
  dependency on a new struct.

  Reporting failures to parse HMAT or allocate structures are elevated
  to a NOTICE level from DEBUG. Any failure will result in just one
  print so that it is obvious something may need to be investigated
  rather than silently fail, but also not to be too alarming either.

  Determining the cpu and memory node local relationships is quite
  different this time (PATCH 7/10). The local relationship to a memory
  target will be either *only* the node from the Initiator Proximity
  Domain if provided, or if it is not provided, all the nodes that have
  the same highest performance. Latency was chosen to take prioirty over
  bandwidth when ranking performance.

  Renamed "side_cache" to "memory_side_cache". The previous name was
  ambiguous.

  Removed "level" as an exported cache attribute. It was redundant with
  the directory name anyway.

  Minor changelog updates, added received reviews, and documentation
  fixes.

Just want to point out that I am sticking with struct device
instead of using struct kobject embedded in the attribute tracking
structures. Previous feedback was leaning either way on this point.

== Background ==

Platforms may provide multiple types of cpu attached system memory. The
memory ranges for each type may have different characteristics that
applications may wish to know about when considering what node they want
their memory allocated from. 

It had previously been difficult to describe these setups as memory
rangers were generally lumped into the NUMA node of the CPUs. New
platform attributes have been created and in use today that describe
the more complex memory hierarchies that can be created.

This series' objective is to provide the attributes from such systems
that are useful for applications to know about, and readily usable with
existing tools and libraries. Those applications may query performance
attributes relative to a particular CPU they're running on in order to
make more informed choices for where they want to allocate hot and cold
data. This works with mbind() or the numactl library.

Keith Busch (10):
  acpi: Create subtable parsing infrastructure
  acpi: Add HMAT to generic parsing tables
  acpi/hmat: Parse and report heterogeneous memory
  node: Link memory nodes to their compute nodes
  node: Add heterogenous memory access attributes
  node: Add memory-side caching attributes
  acpi/hmat: Register processor domain to its memory
  acpi/hmat: Register performance attributes
  acpi/hmat: Register memory side cache attributes
  doc/mm: New documentation for memory performance

 Documentation/ABI/stable/sysfs-devices-node   |  89 +++-
 Documentation/admin-guide/mm/numaperf.rst     | 164 +++++++
 arch/arm64/kernel/acpi_numa.c                 |   2 +-
 arch/arm64/kernel/smp.c                       |   4 +-
 arch/ia64/kernel/acpi.c                       |  12 +-
 arch/x86/kernel/acpi/boot.c                   |  36 +-
 drivers/acpi/Kconfig                          |   1 +
 drivers/acpi/Makefile                         |   1 +
 drivers/acpi/hmat/Kconfig                     |   9 +
 drivers/acpi/hmat/Makefile                    |   1 +
 drivers/acpi/hmat/hmat.c                      | 677 ++++++++++++++++++++++++++
 drivers/acpi/numa.c                           |  16 +-
 drivers/acpi/scan.c                           |   4 +-
 drivers/acpi/tables.c                         |  76 ++-
 drivers/base/Kconfig                          |   8 +
 drivers/base/node.c                           | 351 ++++++++++++-
 drivers/irqchip/irq-gic-v2m.c                 |   2 +-
 drivers/irqchip/irq-gic-v3-its-pci-msi.c      |   2 +-
 drivers/irqchip/irq-gic-v3-its-platform-msi.c |   2 +-
 drivers/irqchip/irq-gic-v3-its.c              |   6 +-
 drivers/irqchip/irq-gic-v3.c                  |  10 +-
 drivers/irqchip/irq-gic.c                     |   4 +-
 drivers/mailbox/pcc.c                         |   2 +-
 include/linux/acpi.h                          |   6 +-
 include/linux/node.h                          |  60 ++-
 25 files changed, 1480 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/numaperf.rst
 create mode 100644 drivers/acpi/hmat/Kconfig
 create mode 100644 drivers/acpi/hmat/Makefile
 create mode 100644 drivers/acpi/hmat/hmat.c

-- 
2.14.4
