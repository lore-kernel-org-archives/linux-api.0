From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Thu, 26 Mar 2015 23:23:38 +0100
Message-ID: <20150326222338.GA13694@kroah.com>
References: <1427056381-27614-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1427056381-27614-2-git-send-email-alexander.shishkin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427056381-27614-2-git-send-email-alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 22, 2015 at 10:32:51PM +0200, Alexander Shishkin wrote:
> A System Trace Module (STM) is a device exporting data in System Trace
> Protocol (STP) format as defined by MIPI STP standards. Examples of such
> devices are Intel Trace Hub and Coresight STM.
> 
> This abstraction provides a unified interface for software trace sources
> to send their data over an STM device to a debug host. In order to do
> that, such a trace source needs to be assigned a pair of master/channel
> identifiers that all the data from this source will be tagged with. The
> STP decoder on the debug host side will use these master/channel tags to
> distinguish different trace streams from one another inside one STP
> stream.
> 
> This abstraction provides a configfs-based policy management mechanism
> for dynamic allocation of these master/channel pairs based on trace
> source-supplied string identifier. It has the flexibility of being
> defined at runtime and at the same time (provided that the policy
> definition is aligned with the decoding end) consistency.
> 
> For userspace trace sources, this abstraction provides write()-based and
> mmap()-based (if the underlying stm device allows this) output mechanism.
> 
> For kernel-side trace sources, we provide "stm_source" device class that
> can be connected to an stm device at run time.
> 
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Cc: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  Documentation/ABI/testing/configfs-stp-policy    |  44 ++
>  Documentation/ABI/testing/sysfs-class-stm        |  14 +
>  Documentation/ABI/testing/sysfs-class-stm_source |  11 +
>  Documentation/trace/stm.txt                      |  77 ++
>  drivers/Kconfig                                  |   2 +
>  drivers/Makefile                                 |   1 +
>  drivers/hwtracing/stm/Kconfig                    |   8 +
>  drivers/hwtracing/stm/Makefile                   |   3 +
>  drivers/hwtracing/stm/core.c                     | 897 +++++++++++++++++++++++
>  drivers/hwtracing/stm/policy.c                   | 467 ++++++++++++
>  drivers/hwtracing/stm/stm.h                      |  79 ++
>  include/linux/stm.h                              | 102 +++
>  include/uapi/linux/stm.h                         |  47 ++
>  13 files changed, 1752 insertions(+)
>  create mode 100644 Documentation/ABI/testing/configfs-stp-policy
>  create mode 100644 Documentation/ABI/testing/sysfs-class-stm
>  create mode 100644 Documentation/ABI/testing/sysfs-class-stm_source
>  create mode 100644 Documentation/trace/stm.txt
>  create mode 100644 drivers/hwtracing/stm/Kconfig
>  create mode 100644 drivers/hwtracing/stm/Makefile
>  create mode 100644 drivers/hwtracing/stm/core.c
>  create mode 100644 drivers/hwtracing/stm/policy.c
>  create mode 100644 drivers/hwtracing/stm/stm.h
>  create mode 100644 include/linux/stm.h
>  create mode 100644 include/uapi/linux/stm.h
> 
> diff --git a/Documentation/ABI/testing/configfs-stp-policy b/Documentation/ABI/testing/configfs-stp-policy
> new file mode 100644
> index 0000000000..1c7ab3dbcd
> --- /dev/null
> +++ b/Documentation/ABI/testing/configfs-stp-policy
> @@ -0,0 +1,44 @@
> +What:		/config/stp-policy
> +Date:		Jan 2015
> +KernelVersion:	3.20

There is no 3.20 kernel version, and January 2015 is in the past :(
