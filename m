From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: [PATCH 0/6] Introduce CoreSight STM support
Date: Mon,  1 Feb 2016 16:18:22 +0800
Message-ID: <1454314702-9095-1-git-send-email-zhang.chunyan@linaro.org>
References: <1454313529-8860-1-git-send-email-zhang.chunyan@linaro.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1454313529-8860-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: mathieu.poirier@linaro.org, alexander.shishkin@linux.intel.com
Cc: robh@kernel.org, broonie@kernel.org, pratikp@codeaurora.org, nicolas.guion@st.com, corbet@lwn.net, mark.rutland@arm.com, zhang.lyra@gmail.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patchset adds support for CoreSight STM IP block. It also makes
a little modification to the generic STM framework to cover the
CoreSight STM requirements. Full description follows the changelog.

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
 drivers/hwtracing/coresight/coresight-stm.c        | 964 +++++++++++++++++++++
 drivers/hwtracing/stm/core.c                       |  29 +-
 drivers/hwtracing/stm/policy.c                     |  46 +-
 include/linux/coresight-stm.h                      |   6 +
 include/linux/stm.h                                |  11 +
 include/uapi/linux/coresight-stm.h                 |  12 +
 include/uapi/linux/stm.h                           |   1 +
 13 files changed, 1188 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-coresight-devices-stm
 create mode 100644 drivers/hwtracing/coresight/coresight-stm.c
 create mode 100644 include/linux/coresight-stm.h
 create mode 100644 include/uapi/linux/coresight-stm.h

-- 
1.9.1

