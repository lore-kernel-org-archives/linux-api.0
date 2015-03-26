From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] coresight: moving to new "hwtracing" directory
Date: Thu, 26 Mar 2015 23:22:18 +0100
Message-ID: <20150326222218.GA13240@kroah.com>
References: <1426870883-12169-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426870883-12169-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, alexander.shishkin@linux.intel.com, linux-kernel@vger.kernel.org, peter.lachner@intel.com, norbert.schulz@intel.com, keven.boell@intel.com, yann.fouassier@intel.com, laurent.fert@intel.com, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kaixu.xia@linaro.org, zhang.chunyan@linaro.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 20, 2015 at 11:01:23AM -0600, Mathieu Poirier wrote:
> Keeping drivers related to HW tracing on ARM, i.e coresight,
> under "drivers/coresight" doesn't make sense when other
> architectures start rolling out technologies of the same
> nature.
> 
> As such creating a new "drivers/hwtracing" directory where all
> drivers of the same kind can reside, reducing namespace
> pollution under "drivers/".
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> ---
> Change for v2:
>  - generated patch with -M option 
> ---
>  MAINTAINERS                                              | 2 +-
>  arch/arm/Kconfig.debug                                   | 2 +-
>  arch/arm64/Kconfig.debug                                 | 2 +-
>  drivers/Makefile                                         | 2 +-
>  drivers/{ => hwtracing}/coresight/Kconfig                | 0
>  drivers/{ => hwtracing}/coresight/Makefile               | 0
>  drivers/{ => hwtracing}/coresight/coresight-etb10.c      | 0
>  drivers/{ => hwtracing}/coresight/coresight-etm-cp14.c   | 0
>  drivers/{ => hwtracing}/coresight/coresight-etm.h        | 0
>  drivers/{ => hwtracing}/coresight/coresight-etm3x.c      | 0
>  drivers/{ => hwtracing}/coresight/coresight-funnel.c     | 0
>  drivers/{ => hwtracing}/coresight/coresight-priv.h       | 0
>  drivers/{ => hwtracing}/coresight/coresight-replicator.c | 0
>  drivers/{ => hwtracing}/coresight/coresight-tmc.c        | 0
>  drivers/{ => hwtracing}/coresight/coresight-tpiu.c       | 0
>  drivers/{ => hwtracing}/coresight/coresight.c            | 0
>  drivers/{ => hwtracing}/coresight/of_coresight.c         | 0
>  17 files changed, 4 insertions(+), 4 deletions(-)
>  rename drivers/{ => hwtracing}/coresight/Kconfig (100%)
>  rename drivers/{ => hwtracing}/coresight/Makefile (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-etb10.c (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-etm-cp14.c (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-etm.h (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-etm3x.c (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-funnel.c (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-priv.h (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-replicator.c (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-tmc.c (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight-tpiu.c (100%)
>  rename drivers/{ => hwtracing}/coresight/coresight.c (100%)
>  rename drivers/{ => hwtracing}/coresight/of_coresight.c (100%)

I'm fine with this, but it doesn't apply to my tree, so I can't add it
:(

Fix it up and resend?

thanks,

greg k-h
