From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 00/11] Support for coresight ETMv4 tracer
Date: Wed, 22 Apr 2015 16:40:40 -0600
Message-ID: <1429742451-11465-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org, mathieu.poirier@linaro.org
List-Id: linux-api@vger.kernel.org

Please find in this patchset a driver implementation that conforms
to the coresight framework and provide support for the Embedded
Trace Macrocell version 4.

With this driver support for ARM's juno platform can be added to the
list of coresight supported architecture.

Best regards,
Mathieu

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
 drivers/hwtracing/coresight/Kconfig                |   10 +
 drivers/hwtracing/coresight/Makefile               |    1 +
 drivers/hwtracing/coresight/coresight-etm4x.c      | 2748 ++++++++++++++++++++
 drivers/hwtracing/coresight/coresight-etm4x.h      |  391 +++
 5 files changed, 3445 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-etm4x
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.c
 create mode 100644 drivers/hwtracing/coresight/coresight-etm4x.h

-- 
1.9.1
