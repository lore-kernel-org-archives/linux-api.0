From: Marc Titinger <mtitinger-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Subject: [RFC 0/2] ABI: IIO: proposal for AVERAGING_RATIO support
Date: Tue, 17 Nov 2015 11:44:08 +0100
Message-ID: <1447757050-4214-1-git-send-email-mtitinger@baylibre.com>
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, knaack.h-Mmb7MZpHnFY@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org
Cc: daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marc Titinger <mtitinger-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an attempt to document/define simple downsampling/averaging
features for some ADC devices.

As discussed in https://lkml.org/lkml/2015/11/16/566

As an illustration, Patch 2 is an instance of implementation
using ina226.

Marc Titinger (2):
  ABI: iio: support AVERAGING_RATIO setting
  iio: ina2xx: convert AVERGING ratio setting from generic sysfs attr to
    ABI

 Documentation/ABI/testing/sysfs-bus-iio | 13 +++++++++
 drivers/iio/adc/ina2xx-iio.c            | 47 +++++----------------------------
 drivers/iio/industrialio-core.c         |  1 +
 include/linux/iio/iio.h                 |  1 +
 include/linux/iio/sysfs.h               |  9 +++++++
 5 files changed, 30 insertions(+), 41 deletions(-)

-- 
1.9.1
