From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 0/3] Enable PPI sysfs interface for TPM 2.0
Date: Tue, 26 May 2015 11:22:05 +0300
Message-ID: <20150526082205.GA3360@intel.com>
References: <1432129766-7289-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432129766-7289-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterhuewe-Mmb7MZpHnFY@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Simon Wunderlich <sw-2YrNx6rUIHYiY0qSoAWiAoQuADTiUCJX@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vivien Didelot <vivien.didelot-4ysUXcep3aM1wj+D4I0NRVaTQe2KTcn/@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

Any feedback on this?

/Jarkko

On Wed, May 20, 2015 at 04:49:21PM +0300, Jarkko Sakkinen wrote:
> Changes since v5:
> * Updated documentation.
> 
> Changes since v4:
> * Removed dangling export of kernfs_remove_by_name_ns() from the sysfs
>   patch.
> 
> Changes since v3:
> * Use sysfs_remove_link()
> 
> Changes since v2:
> * Fixed to_tpm_chip() macro.
> * Split into two patches.
> * Renamed sysfs_link_group_to_kobj to sysfs_link_entry_to_kobj
> * Only create the "backwards compatibility" symlink for TPM 1.x devices.
> 
> Jarkko Sakkinen (3):
>   sysfs: added sysfs_link_entry_to_kobj()
>   tpm: move the PPI attributes to character device directory.
>   tpm: update PPI documentation to address the location change.
> 
>  Documentation/ABI/testing/sysfs-driver-ppi | 19 +++++++++-----
>  drivers/char/tpm/tpm-chip.c                | 24 +++++++++++------
>  drivers/char/tpm/tpm.h                     | 17 +++++-------
>  drivers/char/tpm/tpm_ppi.c                 | 34 ++++++++----------------
>  fs/sysfs/group.c                           | 42 ++++++++++++++++++++++++++++++
>  include/linux/sysfs.h                      |  8 ++++++
>  6 files changed, 95 insertions(+), 49 deletions(-)
> 
> -- 
> 2.1.4
> 
