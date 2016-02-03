From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V2 0/6] Introduce CoreSight STM support
Date: Wed,  3 Feb 2016 16:15:31 +0800
Message-ID: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, mike.leach@arm.com, tor@ti.com, al.grant@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patchset adds support for CoreSight STM IP block. It also makes
a little modification to the generic STM framework to cover the
CoreSight STM requirements. Full description follows the changelog.

Changes from v1:
 - Added a definition of coresight_simple_func() in CS-STM driver to
   avoid the kbuild test robot error for the time being.  This
   modification will be removed when merging the code in which the
   coresight_simple_func() has been moved to the header file.
 - Calculate the channel number according to the channel memory space size.

Thanks,
Chunyan

Chunyan Zhang (3):
  stm class: Add ioctl get_options interface
  stm class: adds a loop to extract the first valid STM device name
  Documentations: Add explanations of the case for non-configurable
    masters

Mathieu Poirier (2):
  stm class: provision for statically assigned masterIDs
  coresight-stm: Bindings for System Trace Macrocell

Pratik Patel (1):
  coresight-stm: adding driver for CoreSight STM component

 .../ABI/testing/sysfs-bus-coresight-devices-stm    |  53 ++
 .../devicetree/bindings/arm/coresight.txt          |  28 +
 Documentation/trace/coresight.txt                  |  37 +-
 Documentation/trace/stm.txt                        |   6 +
 drivers/hwtracing/coresight/Kconfig                |  11 +
 drivers/hwtracing/coresight/Makefile               |   1 +
 drivers/hwtracing/coresight/coresight-stm.c        | 972 +++++++++++++++++++++
 drivers/hwtracing/stm/core.c                       |  29 +-
 drivers/hwtracing/stm/policy.c                     |  46 +-
 include/linux/coresight-stm.h                      |   6 +
 include/linux/stm.h                                |  11 +
 include/uapi/linux/coresight-stm.h                 |  12 +
 include/uapi/linux/stm.h                           |   1 +
 13 files changed, 1196 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
 create mode 100644 drivers/hwtracing/coresight/coresight-stm.c
 create mode 100644 include/linux/coresight-stm.h
 create mode 100644 include/uapi/linux/coresight-stm.h

-- 
1.9.1

