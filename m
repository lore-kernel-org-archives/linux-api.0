From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 0/4] of: overlay: Assorted fixes
Date: Tue,  7 Apr 2015 22:23:48 +0300
Message-ID: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The first patch makes sure that no overlays are being left over from
the unit tests.

The second puts the overlays as objects in the sysfs in
/sys/firmware/devicetree/overlays while the next one adds a master
overlay enable switch (that once is set to disabled can't be re-enabled),
and a few per-overlay attributes.

The last patch updates the ABI docs for the sysfs entries.

The patchset is against Rob Herring's tree at
git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux branch for-next

Changes since v1:
* Maintainer requested changes.
* Documented the sysfs entries
* Per overlay sysfs attributes.

Pantelis Antoniou (4):
  of: unittest: overlay: Keep track of created overlays
  of: overlay: kobjectify overlay objects
  of: overlay: Add sysfs attributes
  Documentation: ABI: /sys/firmware/devicetree/overlays

 .../ABI/testing/sysfs-firmware-devicetree-overlays |  23 +++
 drivers/of/base.c                                  |   5 +
 drivers/of/of_private.h                            |   9 +
 drivers/of/overlay.c                               | 217 ++++++++++++++++++++-
 drivers/of/unittest.c                              |  62 ++++++
 5 files changed, 314 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

-- 
1.7.12
