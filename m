From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v6 0/2] staging: ion: get one device per heap
Date: Mon, 23 Oct 2017 17:55:35 +0200
Message-ID: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: labbott@redhat.com, sumit.semwal@linaro.org, gregkh@linuxfoundation.org, arve@android.com, riandrews@android.com, broonie@kernel.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-api@vger.kernel.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
List-Id: linux-api@vger.kernel.org

version 6:
- add platform_bus and platform_bus_type when register Ion devices
  to make them appear in /sys/devices/platform.
- re-order include files in aphabetic order.

version 5:
- create a configuration flag to keep legacy Ion misc device

version 4:
- add a configuration flag to switch between legacy Ion misc device
  and one device per heap version.
  This change has been suggested after Laura talks at XDC 2017.

version 3:
- change ion_device_add_heap prototype to return a possible error.

version 2:
- simplify ioctl check like propose by Dan
- make sure that we don't register more than ION_DEV_MAX heaps.

Until now all ion heaps are addressing using the same device "/dev/ion".
This way of working doesn't allow to give access rights (for example with
SElinux rules) per heap.
This series propose to have one device "/dev/ionX" per heap.
Query heaps informations will be possible on each device node but
allocation request will only be possible if heap_mask_id match with device minor number.

Using legacy Ion misc device is still by setting ION_LEGACY_DEVICE_API
configuration flag.

Benjamin Gaignard (2):
  staging: ion: simplify ioctl args checking function
  staging: ion: create one device entry per heap

 drivers/staging/android/TODO            |  1 -
 drivers/staging/android/ion/Kconfig     |  7 +++++
 drivers/staging/android/ion/ion-ioctl.c | 29 +++++++++++++-----
 drivers/staging/android/ion/ion.c       | 53 ++++++++++++++++++++++++++-------
 drivers/staging/android/ion/ion.h       | 15 ++++++++--
 5 files changed, 84 insertions(+), 21 deletions(-)

-- 
2.7.4
