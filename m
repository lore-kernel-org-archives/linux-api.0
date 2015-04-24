From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 0/4] of: overlay: kobject & sysfs'ation
Date: Fri, 24 Apr 2015 12:45:40 +0300
Message-ID: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The first patch puts the overlays as objects in the sysfs in
/sys/firmware/devicetree/overlays.

The next adds a master overlay enable switch (that once is set to
disabled can't be re-enabled), while the one after that
introduces a number of default per overlay attributes.

The patchset is against linus's tree as of today.

The last patch updates the ABI docs for the sysfs entries.

Changes since v2:
* Removed the unittest patch.
* Split the sysfs attribute patch to a global and a per-overlay
  patch.
* Dropped binary attributes using textual kobj_attributes instead.

Changes since v1:
* Maintainer requested changes.
* Documented the sysfs entries
* Per overlay sysfs attributes.

Pantelis Antoniou (4):
  of: overlay: kobjectify overlay objects
  of: overlay: global sysfs enable attribute
  of: overlay: add per overlay sysfs attributes
  Documentation: ABI: /sys/firmware/devicetree/overlays

 .../ABI/testing/sysfs-firmware-devicetree-overlays |  23 ++++
 drivers/of/base.c                                  |   5 +
 drivers/of/of_private.h                            |   9 ++
 drivers/of/overlay.c                               | 148 ++++++++++++++++++++-
 4 files changed, 183 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

-- 
1.7.12
