From: Wu Hao <hao.wu@intel.com>
Subject: [PATCH v4 0/2] add performance reporting support to FPGA DFL drivers
Date: Thu, 27 Jun 2019 13:09:53 +0800
Message-ID: <1561612195-6081-1-git-send-email-hao.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mdf@kernel.org, linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, gregkh@linuxfoundation.org, atull@kernel.org, Wu Hao <hao.wu@intel.com>
List-Id: linux-api@vger.kernel.org

This patchset adds performance reporting support for FPGA DFL drivers. It
introduces one pmu to expose userspace interfaces via standard perf API.
User could use standard perf tool to access perf events exposed via pmu.

This patchset is splitted from patchset[1] for better review, and version 3
patch could be found here[2]. Please note that this patchset needs to be
applied on top of patchset[3][4].

Main changes from v3:
 - add more descriptions in doc, including how to use perf tool for these
   hardware counters. (patch #1)
 - use standard perf API instead of sysfs entries. (patch #2)

[1]https://lkml.org/lkml/2019/5/27/11
[2]https://lkml.org/lkml/2019/5/27/18
[3]https://lkml.org/lkml/2019/6/27/29
[4]https://lkml.org/lkml/2019/6/27/49

Wu Hao (1):
  fpga: dfl: fme: add performance reporting support

Xu Yilun (1):
  Documentation: fpga: dfl: add description for performance reporting
    support

 Documentation/fpga/dfl.txt  |  83 +++++
 drivers/fpga/Makefile       |   1 +
 drivers/fpga/dfl-fme-main.c |   4 +
 drivers/fpga/dfl-fme-perf.c | 871 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/dfl-fme.h      |   2 +
 5 files changed, 961 insertions(+)
 create mode 100644 drivers/fpga/dfl-fme-perf.c

-- 
1.8.3.1
