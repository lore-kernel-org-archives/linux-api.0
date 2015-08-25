From: Jarkko Sakkinen <jarkko.sakkinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 0/3] Enable PPI sysfs interface for TPM 2.0
Date: Tue, 25 Aug 2015 20:03:27 +0300
Message-ID: <20150825170327.GA23185@intel.com>
References: <1439388347-22325-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1439388347-22325-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterhuewe-Mmb7MZpHnFY@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Does this start be in the shape that there would be chance to pull this
in at some point? To be able to enable TPM 2.0 chips from Linux is quite
mandatory feature in my opinion.

Thank you.

/Jarkko

On Wed, Aug 12, 2015 at 05:05:40PM +0300, Jarkko Sakkinen wrote:
> v9:
> * Fixed naming for __compat_only_sysfs_link_entry_to_kobj()
> 
> v8:
> * Renamed sysfs_link_entry_to_kobj() to
>   __compat_only_sysfs_link_entry_to_kobj()
> 
> v7:
> * Fixed compile error when CONFIG_SYSFS is not enabled.
> 
> v6:
> * Updated documentation.
> 
> v5:
> * Removed dangling export of kernfs_remove_by_name_ns() from the sysfs
>   patch.
> 
> v4:
> * Use sysfs_remove_link()
> 
> v3:
> * Fixed to_tpm_chip() macro.
> * Split into two patches.
> * Renamed sysfs_link_group_to_kobj to sysfs_link_entry_to_kobj
> * Only create the "backwards compatibility" symlink for TPM 1.x devices.
> 
> Jarkko Sakkinen (3):
>   sysfs: added __compat_only_sysfs_link_entry_to_kobj()
>   tpm: move the PPI attributes to character device directory.
>   tpm: update PPI documentation to address the location change.
> 
>  Documentation/ABI/testing/sysfs-driver-ppi | 19 ++++++++-----
>  drivers/char/tpm/tpm-chip.c                | 24 ++++++++++------
>  drivers/char/tpm/tpm.h                     | 17 ++++--------
>  drivers/char/tpm/tpm_ppi.c                 | 34 ++++++++---------------
>  fs/sysfs/group.c                           | 44 ++++++++++++++++++++++++++++++
>  include/linux/sysfs.h                      | 11 ++++++++
>  6 files changed, 100 insertions(+), 49 deletions(-)
> 
> -- 
> 2.5.0
> 
