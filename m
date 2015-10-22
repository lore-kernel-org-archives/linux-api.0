From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 0/6] of: overlay: kobject & sysfs'ation
Date: Thu, 22 Oct 2015 22:50:21 +0300
Message-ID: <1445543427-26275-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The first patch puts the overlays as objects in the sysfs in
/sys/firmware/devicetree/overlays.

The #2 adds a master overlay enable switch (that once is set to
disabled can't be re-enabled), while the one after that
introduces a number of default per overlay attributes.
The patch following is the ABI docs for the sysfs entries of #2,
while the next one updates the doc entry for the kernel parameter
of_overlay_disable.

Patch #5 add per overlay sysfs attributes, and the next one is
documentation about it.

The patchset is against linus's tree as of today.

Changes since v6:
* Updated changelogs as per maintainer suggestion.
* Fixed documentation entries and split them up
* Added command line parameter docs.

Changes since v5:
* Does a single kobject_put that suffices
* A per-fragment sysfs directory and a single value target.
* Update in the ABI documention.

Changes since v4:
* Rebased against latest mainline.

Changes since v3:
* Used strtobool instead of kstrtoul
* ABI Documentation includes a pointer to the discussion that
requested the sysfs property.

Changes since v2:
* Removed the unittest patch.
* Split the sysfs attribute patch to a global and a per-overlay
  patch.
* Dropped binary attributes using textual kobj_attributes instead.

Changes since v1:
* Maintainer requested changes.
* Documented the sysfs entries
* Per overlay sysfs attributes.
Pantelis Antoniou (6):
  of: overlay: kobjectify overlay objects
  of: overlay: global sysfs enable attribute
  Documentation: ABI: overlays - global attributes
  Documentation: document of_overlay_disable parameter
  of: overlay: add per overlay sysfs attributes
  Documentation: ABI: overlays - per overlay docs

 .../ABI/testing/sysfs-firmware-devicetree-overlays |  52 ++++++
 Documentation/kernel-parameters.txt                |   3 +
 drivers/of/base.c                                  |   7 +
 drivers/of/of_private.h                            |   9 +
 drivers/of/overlay.c                               | 201 ++++++++++++++++++++-
 5 files changed, 266 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

-- 
1.7.12
