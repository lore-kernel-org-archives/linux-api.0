From: Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [RFC PATCH 2/3] iio: allow better control for flushing the hardware
 fifo
Date: Sat, 02 May 2015 19:42:54 +0200
Message-ID: <55450C9E.4060409@metafoo.de>
References: <1430306340-5026-1-git-send-email-octavian.purdila@intel.com> <1430306340-5026-3-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430306340-5026-3-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>, jic23@kernel.org
Cc: knaack.h@gmx.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, adriana.reus@intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/29/2015 01:18 PM, Octavian Purdila wrote:
> Some applications need to be able to flush [1] the hardware fifo of
> the device and to receive events of when that happened [2] so that it
> can ignore stale data.
>
> This patch adds a new event (IIO_EV_TYPE_HWFIFO_FLUSHED) that should
> be sent to userspace when a flush has been completed. The application
> will be able to identify which are the samples to ignore based on the
> timestamp of the event.
>
> To allow applications to accurately generate a hardware fifo flush on
> demand, this patch also adds a new sysfs entry that triggers a
> hardware fifo flush when written to.
>
> [1] https://source.android.com/devices/sensors/hal-interface.html#flush_sensor
> [2] https://source.android.com/devices/sensors/hal-interface.html#metadata_flush_complete_events

Since there is no asynchronous queue for commands to be executed in IIO 
adding a asynchronous completion event doesn't make too much sense. This is 
something that needs to be handled at the HAL level.

The HAL needs to have a queue of commands that need to be executed where new 
events can be added asynchronously, then has a loop which goes through the 
commands in the queue and executes them, and once executed generated the 
appropriate completion event.

I really wish that document would specify what is actually meant by flush. 
Copy the FIFO content to a software buffer or discard the FIFO content.

>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>   Documentation/ABI/testing/sysfs-bus-iio | 11 +++++++++++
>   include/linux/iio/sysfs.h               |  3 +++
>   include/uapi/linux/iio/types.h          |  1 +
>   3 files changed, 15 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 866b4ec..bb4d8de 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -1375,3 +1375,14 @@ Description:
>   		The emissivity ratio of the surface in the field of view of the
>   		contactless temperature sensor.  Emissivity varies from 0 to 1,
>   		with 1 being the emissivity of a black body.
> +
> +What:		/sys/bus/iio/devices/iio:deviceX/buffer/hwfifo_flush
> +KernelVersion:	4.2
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Write only entry that accepts a single strictly positive integer
> +		specifying the number of samples to flush from the hardware fifo
> +		to the device buffer. When the flush is completed an
> +		IIO_EV_TYPE_HWFIFO_FLUSHED event is generated. The event has the
> +		timestamp equal with the timestamp of last sample that was
> +		flushed from the hardware fifo.

I'd prefer this to be handled through the normal read() API rather than 
having a side channel for it. Big question is how though. We could specify 
that reading in O_NONBLOCK mode will always read data if it is available and 
not only if it is above the watermark threshold.
