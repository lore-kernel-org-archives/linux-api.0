From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/5] coresight: Support context-ID tracing when PID
 namespace is enabled
Date: Mon, 13 Jul 2015 11:26:11 -0600
Message-ID: <CANLsYkwBmquLNiDfUXzZmwEDR7Ow2CPPCoiUrSQKgXTnoN0ohg@mail.gmail.com>
References: <1436258518-9339-1-git-send-email-zhang.chunyan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436258518-9339-1-git-send-email-zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Broslavsky <serge.broslavsky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 7 July 2015 at 02:41, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> The Coresight ETM drivers already support context-ID tracing, but it won't
> work when PID namespace is enabled. This is because when using PID
> namespace a process id (ie. VPID) seen from the current namespace differs
> from the id (ie. PID) seen by kernel.
>
> This patch-set does add a translation between VPID and PID.
>
> Chunyan Zhang (5):
>   coresight-etm3x: Change the name of the ctxid_val to ctxid_pid
>   coresight-etm4x: Change the name of the ctxid_val to ctxid_pid
>   Coresight: Add an interface for supporting ETM3/4 Context ID tracing
>   coresight-etm3x: Support context-ID tracing when PID namespace is
>     enabled
>   coresight-etm4x: Support context-ID tracing when PID namespace is
>     enabled
>
>  .../ABI/testing/sysfs-bus-coresight-devices-etm3x  |  2 +-
>  .../ABI/testing/sysfs-bus-coresight-devices-etm4x  |  2 +-
>  drivers/hwtracing/coresight/coresight-etm.h        |  7 ++--
>  drivers/hwtracing/coresight/coresight-etm3x.c      | 28 +++++++++-------
>  drivers/hwtracing/coresight/coresight-etm4x.c      | 37 ++++++++++++++--------
>  drivers/hwtracing/coresight/coresight-etm4x.h      |  7 ++--
>  include/linux/coresight.h                          | 20 ++++++++++++
>  7 files changed, 72 insertions(+), 31 deletions(-)
>
> --
> 1.9.1
>

Applied - thanks.
