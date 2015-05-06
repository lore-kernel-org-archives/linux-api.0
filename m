From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH v3 00/11] Support for coresight ETMv4 tracer
Date: Wed,  6 May 2015 09:27:16 -0600
Message-ID: <1430926047-9125-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

Please find in this patchset a driver implementation that conforms
to the coresight framework and provide support for the Embedded
Trace Macrocell version 4.

Regards,
Mathieu

---
Changes for v3:
- Fixed cosmetic detail in Kconfig.
- Removed THIS_MODULE from driver declaration.
- Removed MODULE_XYX() declarations at the bottom of the file.
---

Pratik Patel (11):
  coresight-etm4x: Adding CoreSight ETM4x driver
  coresight-etm4x: Controls pertaining to tracer configuration
  coresight-etm4x: Controls pertaining to the reset, mode, pe and events
  coresight-etm4x: Controls pertaining to various configuration options
  coresight-etm4x: Controls pertaining to the ViewInst register
  coresight-etm4x: Controls pertaining to the address comparator
    functions
  coresight-etm4x: Controls pertaining to the sequencer functions
  coresight-etm4x: Controls pertaining to the counter functions
  coresight-etm4x: Controls pertaining to the selection of resources
  coresight-etm4x: Controls pertaining to the context ID functions
  coresight-etm4x: Controls pertaining to the VM ID functions

 .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  295 +++
 drivers/hwtracing/coresight/Kconfig                |   11 +
 drivers/hwtracing/coresight/Makefile               |    1 +
 drivers/hwtracing/coresight/coresight-etm4x.c      | 2740 ++++++++++++++++++++
 drivers/hwtracing/coresight/coresight-etm4x.h      |  391 +++
 5 files changed, 3438 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.c
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.h

-- 
1.9.1
