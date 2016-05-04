From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 00/13] Rework for AFE440x drivers to prepare for AFE4405
Date: Wed, 4 May 2016 11:25:10 +0100
Message-ID: <3a3f1547-90d3-e239-aa93-5218744732a9@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-1-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> Hello all,
> 
> I will be posting a driver for the AFE4405 soon and in preparation
> for this I have made some changes to the existing drivers to better
> align them with the new part. Some of these changes are trivial, others
> change the sysfs entries, I understand these are considered ABIs and
> changes to even testing ABIs should not be made lightly, but my hope is
> that these changes will more accurately reflect the devices intended use
> and improve functionality as the first users begin to appear.
> 
> Thanks,
> Andrew

Hi Andrew,

Just a quick not to explain my reasoning for taking these which involve
some pretty major ABI surgery, whilst bouncing back much more trivial
changes.

Ultimately, whether we can change ABI comes down to 1 simple question.
'Will anyone notice and if so will it be an issue for them?'
We must not break userspace.

For the vast majority of IIO drivers, only simple tools along the lines
of generic_buffer or just sysfs file reads are all that is needed to
make 'use' of the data.  Obviously lots of users will go through one
of the more advanced libraries, but these are still mostly generic.

We had a long debate through numerous versions when Andrew was
originally submitting these two drivers to try and pin down a vaguely
standard ABI for them.  The result was indeed 'Vaguely' standard.
We moved in a good direction but sometimes a device is just too
specialized (unfortunately).

The very nature of these devices is that the data is only meaningful
(i.e. measuring what they are supposedly for) once a non trivial
amount of computation has been performed in userspace. Now, there
probably is enough information available to do pulse oximetry using
one of these devices, but it is certainly non trivial.

As such the interface is hopefully tightly coupled to the userspace
tools that TI provide allowing us to make changes without it
adversely effecting anyone.  As time moves on this may well not be
the case.  If anyone knows that there is existing non TI code out
there for this and we will be causing pain, let me know ASAP so that
we can work out a way forward.

So really it's a case of an educated guess that no one cares and
crossing fingers!  I think the improvements made here are worth
the risk.

Jonathan
> 
> Andrew F. Davis (13):
>   iio: health/afe440x: Fix kernel-doc format
>   iio: health/afe440x: Remove of_match_ptr and ifdefs
>   iio: health/afe440x: Remove unneeded initializers
>   iio: health/afe440x: Always use separate gain values
>   iio: health/afe440x: Fix scan_index assignment
>   iio: health/afe440x: Remove unneeded offset handling
>   iio: health/afe4404: Remove LED3 input channel
>   iio: health/afe440x: Remove channel names
>   iio: health/afe440x: Use regmap fields
>   iio: health/afe440x: Make gain settings a modifier for the stages
>   iio: health/afe440x: Match LED currents to stages
>   iio: health/afe440x: Remove unused definitions
>   iio: health/afe4404: ENSEPGAIN is part of CONTROL2 register
> 
>  .../ABI/testing/sysfs-bus-iio-health-afe440x       |  95 +++----
>  drivers/iio/health/afe4403.c                       | 299 ++++++++------------
>  drivers/iio/health/afe4404.c                       | 308 +++++++++------------
>  drivers/iio/health/afe440x.h                       |  48 +---
>  4 files changed, 295 insertions(+), 455 deletions(-)
>  rewrite Documentation/ABI/testing/sysfs-bus-iio-health-afe440x (72%)
> 
