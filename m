From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] coresight: moving to new "hwtracing" directory
Date: Fri, 20 Mar 2015 08:17:57 +0100
Message-ID: <20150320071757.GA30346@kroah.com>
References: <1426802522-25743-1-git-send-email-mathieu.poirier@linaro.org>
 <20150319222741.GA24999@kroah.com>
 <CANLsYkx07_xYcXYbj=TwvUpaDRo9=ppLqsg69e2ju2nO-MArwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANLsYkx07_xYcXYbj=TwvUpaDRo9=ppLqsg69e2ju2nO-MArwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Kaixu Xia <kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 19, 2015 at 06:21:56PM -0600, Mathieu Poirier wrote:
> On 19 March 2015 at 16:27, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > On Thu, Mar 19, 2015 at 04:02:02PM -0600, Mathieu Poirier wrote:
> >> Keeping drivers related to HW tracing on ARM, i.e coresight,
> >> under "drivers/coresight" doesn't make sense when other
> >> architectures start rolling out technologies of the same
> >> nature.
> >>
> >> As such creating a new "drivers/hwtracing" directory where all
> >> drivers of the same kind can reside, reducing namespace
> >> pollution under "drivers/".
> >>
> >> Signed-off-by: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> ---
> >>  MAINTAINERS                                        |    2 +-
> >>  arch/arm/Kconfig.debug                             |    2 +-
> >>  arch/arm64/Kconfig.debug                           |    2 +-
> >>  drivers/Makefile                                   |    2 +-
> >>  drivers/coresight/Kconfig                          |   61 -
> >>  drivers/coresight/Makefile                         |   11 -
> >>  drivers/coresight/coresight-etb10.c                |  527 ------
> >>  drivers/coresight/coresight-etm-cp14.c             |  591 ------
> >>  drivers/coresight/coresight-etm.h                  |  251 ---
> >>  drivers/coresight/coresight-etm3x.c                | 1932 --------------------
> >>  drivers/coresight/coresight-funnel.c               |  258 ---
> >>  drivers/coresight/coresight-priv.h                 |   63 -
> >>  drivers/coresight/coresight-replicator.c           |  137 --
> >>  drivers/coresight/coresight-tmc.c                  |  822 ---------
> >>  drivers/coresight/coresight-tpiu.c                 |  207 ---
> >>  drivers/coresight/coresight.c                      |  720 --------
> >>  drivers/coresight/of_coresight.c                   |  200 --
> >>  drivers/hwtracing/coresight/Kconfig                |   61 +
> >>  drivers/hwtracing/coresight/Makefile               |   11 +
> >>  drivers/hwtracing/coresight/coresight-etb10.c      |  527 ++++++
> >>  drivers/hwtracing/coresight/coresight-etm-cp14.c   |  591 ++++++
> >>  drivers/hwtracing/coresight/coresight-etm.h        |  251 +++
> >>  drivers/hwtracing/coresight/coresight-etm3x.c      | 1932 ++++++++++++++++++++
> >>  drivers/hwtracing/coresight/coresight-funnel.c     |  258 +++
> >>  drivers/hwtracing/coresight/coresight-priv.h       |   63 +
> >>  drivers/hwtracing/coresight/coresight-replicator.c |  137 ++
> >>  drivers/hwtracing/coresight/coresight-tmc.c        |  822 +++++++++
> >>  drivers/hwtracing/coresight/coresight-tpiu.c       |  207 +++
> >>  drivers/hwtracing/coresight/coresight.c            |  720 ++++++++
> >>  drivers/hwtracing/coresight/of_coresight.c         |  200 ++
> >>  30 files changed, 5784 insertions(+), 5784 deletions(-)
> >>  delete mode 100644 drivers/coresight/Kconfig
> >>  delete mode 100644 drivers/coresight/Makefile
> >>  delete mode 100644 drivers/coresight/coresight-etb10.c
> >>  delete mode 100644 drivers/coresight/coresight-etm-cp14.c
> >>  delete mode 100644 drivers/coresight/coresight-etm.h
> >>  delete mode 100644 drivers/coresight/coresight-etm3x.c
> >>  delete mode 100644 drivers/coresight/coresight-funnel.c
> >>  delete mode 100644 drivers/coresight/coresight-priv.h
> >>  delete mode 100644 drivers/coresight/coresight-replicator.c
> >>  delete mode 100644 drivers/coresight/coresight-tmc.c
> >>  delete mode 100644 drivers/coresight/coresight-tpiu.c
> >>  delete mode 100644 drivers/coresight/coresight.c
> >>  delete mode 100644 drivers/coresight/of_coresight.c
> >>  create mode 100644 drivers/hwtracing/coresight/Kconfig
> >>  create mode 100644 drivers/hwtracing/coresight/Makefile
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-etb10.c
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-etm-cp14.c
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-etm.h
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-etm3x.c
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-funnel.c
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-priv.h
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-replicator.c
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-tmc.c
> >>  create mode 100644 drivers/hwtracing/coresight/coresight-tpiu.c
> >>  create mode 100644 drivers/hwtracing/coresight/coresight.c
> >>  create mode 100644 drivers/hwtracing/coresight/of_coresight.c
> >
> > This looks good to me, but please create your patches with -M option to
> > git, so it just moves the code, and we can easily see that it is a move
> > and nothing else changed.
> >
> 
> Right, it's nothing more than a move - would you like me to resend this?

Yes please, I can't apply it as-is :)
