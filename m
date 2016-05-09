From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH v8 0/6]  of: overlay: kobject & sysfs'ation
Date: Mon,  9 May 2016 16:09:57 +0300
Message-ID: <1462799403-10083-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
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

Changes since v7:
* ACKs from gregh
* Rebased against latest mainline

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
 drivers/of/base.c                                  |   5 +
 drivers/of/of_private.h                            |   9 +
 drivers/of/overlay.c                               | 201 ++++++++++++++++++++-
 5 files changed, 264 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

-- 
1.7.12
