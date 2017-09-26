From: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 0/2] staging: ion: get one device per heap
Date: Tue, 26 Sep 2017 14:07:03 +0200
Message-ID: <1506427625-19202-1-git-send-email-benjamin.gaignard@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

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
This series propose to have (under configuartion flag) one device "/dev/ionX"
per heap. Query heaps informations will be possible on each device node but
allocation request will only be possible if heap_mask_id match with device minor number.

That enable  thsi new flag change Ion ABI because:
- device name change
- allocation must be done on the correct device/heap.
- device major number will not be the same and that could impact init scripts.

Benjamin Gaignard (2):
  staging: ion: simplify ioctl args checking function
  staging: ion: create one device entry per heap

 drivers/staging/android/TODO            |  1 -
 drivers/staging/android/ion/Kconfig     |  8 ++++++++
 drivers/staging/android/ion/ion-ioctl.c | 27 +++++++++++++++++++--------
 drivers/staging/android/ion/ion.c       | 29 +++++++++++++++++++++++++++--
 drivers/staging/android/ion/ion.h       | 18 +++++++++++++++++-
 5 files changed, 71 insertions(+), 12 deletions(-)

-- 
2.7.4
