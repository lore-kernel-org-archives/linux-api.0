From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/5] of: overlay: Assorted fixes
Date: Tue, 17 Mar 2015 22:30:52 +0200
Message-ID: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <matt.porter-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The first patch makes sure that no overlays are being left over from
the unit tests.

The second puts the overlays as objects in the sysfs in
/sys/firmware/devicetree/overlays while the next one adds a master
overlay enable switch (that once is set to disabled can't be re-enabled)

The next updates the ABI docs and the final one adds me as the
maintainer for device tree overlays.

Pantelis Antoniou (5):
  of: unittest: overlay: Keep track of created overlays
  of: overlay: kobjectify overlay objects
  of: overlay: Master enable switch
  Documentation: ABI: /sys/firmware/devicetree/overlays
  MAINTAINERS: Pantelis Antoniou device tree overlay maintainer

 .../ABI/testing/sysfs-firmware-devicetree-overlays |   9 ++
 MAINTAINERS                                        |   9 ++
 drivers/of/base.c                                  |   5 +
 drivers/of/of_private.h                            |   9 ++
 drivers/of/overlay.c                               | 116 ++++++++++++++++++++-
 drivers/of/unittest.c                              |  62 +++++++++++
 6 files changed, 208 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays

-- 
1.7.12
