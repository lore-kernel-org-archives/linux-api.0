From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v9 0/3] Enable PPI sysfs interface for TPM 2.0
Date: Tue, 29 Sep 2015 10:36:30 +0300
Message-ID: <1443512197-5477-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterhuewe-Mmb7MZpHnFY@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vivien Didelot <vivien.didelot-4ysUXcep3aM1wj+D4I0NRVaTQe2KTcn/@public.gmane.org>
List-Id: linux-api@vger.kernel.org

v9:
* Fixed naming for __compat_only_sysfs_link_entry_to_kobj()

v8:
* Renamed sysfs_link_entry_to_kobj() to
  __compat_only_sysfs_link_entry_to_kobj()

v7:
* Fixed compile error when CONFIG_SYSFS is not enabled.

v6:
* Updated documentation.

v5:
* Removed dangling export of kernfs_remove_by_name_ns() from the sysfs
  patch.

v4:
* Use sysfs_remove_link()

v3:
* Fixed to_tpm_chip() macro.
* Split into two patches.
* Renamed sysfs_link_group_to_kobj to sysfs_link_entry_to_kobj
* Only create the "backwards compatibility" symlink for TPM 1.x devices.

Jarkko Sakkinen (3):
  sysfs: added __compat_only_sysfs_link_entry_to_kobj()
  tpm: move the PPI attributes to character device directory.
  tpm: update PPI documentation to address the location change.

 Documentation/ABI/testing/sysfs-driver-ppi | 19 ++++++++-----
 drivers/char/tpm/tpm-chip.c                | 24 ++++++++++------
 drivers/char/tpm/tpm.h                     | 17 ++++--------
 drivers/char/tpm/tpm_ppi.c                 | 34 ++++++++---------------
 fs/sysfs/group.c                           | 44 ++++++++++++++++++++++++++++++
 include/linux/sysfs.h                      | 11 ++++++++
 6 files changed, 100 insertions(+), 49 deletions(-)

-- 
2.5.0
