From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH V3 0/6] Introduce CoreSight STM support
Date: Sat,  6 Feb 2016 19:04:26 +0800
Message-ID: <1454756672-12790-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: mike.leach@arm.com, Michael.Williams@arm.com, al.grant@arm.com, tor@ti.com, nicolas.guion@st.com, broonie@kernel.org, robh@kernel.org, pratikp@codeaurora.org, corbet@lwn.net, mark.rutland@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
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

Changes from V2:
 - Changed to return -EFAULT if failed on the command STP_GET_OPTIONS.
 - Used Alex's patch [1] instead of the last 2/6.
 - Removed the while loop from stm_send(), since the packet size passed
   to it isn't larger than 4 bytes on 32-bit system and 8 bytes on
   64-bit system.
 - Removed stm_send_64bit(), since the process of packets on 64-bit
   CS-STM should be basically the same with on 32-bit system, except the 
   maximum length of writing STM at a time.
 - Removed the support of writing 64-bit to CoreSight STM buffer at a time
   on 32-bit ARM architecture according to an ARM engineer suggestion.  As
   he said that the STM might receive a 64-bit write, or might receive a
   pair of 32-bit writes to the two addressed words in either order.
   So 64-bit write isn't guaranteed to work on the ARM 32-bit architecture.

Thanks,
Chunyan

[1] https://lkml.org/lkml/2016/2/4/652

Alexander Shishkin (1):
  stm class: Support devices with multiple instances

Chunyan Zhang (2):
  stm class: Add ioctl get_options interface
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
 drivers/hwtracing/coresight/coresight-stm.c        | 928 +++++++++++++++++++++
 drivers/hwtracing/stm/core.c                       |  30 +-
 drivers/hwtracing/stm/policy.c                     |  25 +-
 include/linux/coresight-stm.h                      |   6 +
 include/linux/stm.h                                |  11 +
 include/uapi/linux/coresight-stm.h                 |  12 +
 include/uapi/linux/stm.h                           |   1 +
 13 files changed, 1140 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
 create mode 100644 drivers/hwtracing/coresight/coresight-stm.c
 create mode 100644 include/linux/coresight-stm.h
 create mode 100644 include/uapi/linux/coresight-stm.h

-- 
1.9.1

