From: "Andrew F. Davis" <afd@ti.com>
Subject: [PATCH 00/13] Rework for AFE440x drivers to prepare for AFE4405
Date: Sun, 1 May 2016 15:36:50 -0500
Message-ID: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, "Andrew F. Davis" <afd@ti.com>
List-Id: linux-api@vger.kernel.org

Hello all,

I will be posting a driver for the AFE4405 soon and in preparation
for this I have made some changes to the existing drivers to better
align them with the new part. Some of these changes are trivial, others
change the sysfs entries, I understand these are considered ABIs and
changes to even testing ABIs should not be made lightly, but my hope is
that these changes will more accurately reflect the devices intended use
and improve functionality as the first users begin to appear.

Thanks,
Andrew

Andrew F. Davis (13):
  iio: health/afe440x: Fix kernel-doc format
  iio: health/afe440x: Remove of_match_ptr and ifdefs
  iio: health/afe440x: Remove unneeded initializers
  iio: health/afe440x: Always use separate gain values
  iio: health/afe440x: Fix scan_index assignment
  iio: health/afe440x: Remove unneeded offset handling
  iio: health/afe4404: Remove LED3 input channel
  iio: health/afe440x: Remove channel names
  iio: health/afe440x: Use regmap fields
  iio: health/afe440x: Make gain settings a modifier for the stages
  iio: health/afe440x: Match LED currents to stages
  iio: health/afe440x: Remove unused definitions
  iio: health/afe4404: ENSEPGAIN is part of CONTROL2 register

 .../ABI/testing/sysfs-bus-iio-health-afe440x       |  95 +++----
 drivers/iio/health/afe4403.c                       | 299 ++++++++------------
 drivers/iio/health/afe4404.c                       | 308 +++++++++------------
 drivers/iio/health/afe440x.h                       |  48 +---
 4 files changed, 295 insertions(+), 455 deletions(-)
 rewrite Documentation/ABI/testing/sysfs-bus-iio-health-afe440x (72%)

-- 
2.8.1
