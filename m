From: Leonid Maksymchuk <leonmaxx@gmail.com>
Subject: [PATCH v6 0/2] platform/x86: asus_wmi: Support of ASUS TUF laptops on Ryzen CPUs
Date: Sun, 15 Dec 2019 16:25:27 +0200
Message-ID: <20191215142527.13780-1-leonmaxx@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org, acpi4asus-user@lists.sourceforge.net, chiu@endlessm.com, yurii.pavlovskyi@gmail.com, kristian@klausen.dk, andy@infradead.org, dvhart@infradead.org, corentin.chary@gmail.com, Leonid Maksymchuk <leonmaxx@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi,

this patch series adds support of Throttle themal policy ACPI device to
existing asus_wmi platform driver. Support of this device is required
for ASUS TUF laptops on Ryzen CPUs to properly work on Linux.

v2: fixed indentation.
v3: patches 2/3 and 3/3 are refactored.
v4: patch 2/3 are simplified.
v5: add new device instead of merging with fan boost mode.
v6: document new ABI, simplify code.

Leonid Maksymchuk (2):
  platform/x86: asus_wmi: Support throttle thermal policy
  platform/x86: asus_wmi: Set throttle thermal policy to default

 .../ABI/testing/sysfs-platform-asus-wmi       |  10 ++
 drivers/platform/x86/asus-wmi.c               | 124 ++++++++++++++++++
 include/linux/platform_data/x86/asus-wmi.h    |   1 +
 3 files changed, 135 insertions(+)

-- 
2.24.0
