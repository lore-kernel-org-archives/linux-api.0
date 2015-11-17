From: Marc Titinger <mtitinger@baylibre.com>
Subject: Re: [RFC 1/2] ABI: iio: support AVERAGING_RATIO setting
Date: Tue, 17 Nov 2015 15:04:43 +0100
Message-ID: <564B33FB.8080806@baylibre.com>
References: <1447757050-4214-1-git-send-email-mtitinger@baylibre.com>
 <1447757050-4214-2-git-send-email-mtitinger@baylibre.com>
 <e917f9f0583a32f74fe6f6f2357a4365@jic23.retrosnub.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e917f9f0583a32f74fe6f6f2357a4365@jic23.retrosnub.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: jic23@jic23.retrosnub.co.uk
Cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, daniel.baluta@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 17/11/2015 14:39, jic23@jic23.retrosnub.co.uk wrote:
> On 17.11.2015 10:44, Marc Titinger wrote:
>> Some ADC devices allow averaging/downsampling. The minimal parameter
>> set for this will be the number of taps used for computing a mean value.
>>
>> In some cases the ratio will hold discrete values for instance "1, 4, 16"
>> hence an averaging_ratio_available property is useful. The possible ratio
>> values are less likely to changing with the device settings, so this
>> patch
>> only provides a CONST version of the definition helper.
>>
>> Tested with ina226:
>>
>> # ls /sys/bus/iio/devices/iio\:device0/
>> averaging_ratio_available     in_voltage0_raw
>> dev                           in_voltage1_raw
>> in_averaging_ratio            name
>> in_calibscale                 power
>> in_current2_raw               sampling_frequency_available
>> in_power3_raw                 subsystem
>> in_sampling_frequency         uevent
>>
>> # cat averaging_ratio_available
>> 1, 4, 16, 64, 128, 256, 512, 1024
>>
>> Signed-off-by: Marc Titinger <mtitinger@baylibre.com>
> Having just noted the previous element we added was oversampling_ratio,
> in a sense they are somewhat similar.
>
> To play Devil's advocate...
> Could we in theory just use that as it is existing ABI?
>
> oversampling_ratio was introduced for the bmc150.
> That particular part doesn't have the worlds clearest datasheet
> but it seems like it's effectively specifying how many repeat measurements
> to average.
>
> I'm afraid I'd completely forgotten about this or
> I would have mentioned it earlier!

I saw that oversampling setting, but I my memories, oversampling was 
sometimes related to increasing the samplerate, i.e creating more 
samples possibly through interpolation, in order to allow for filtering.

If there is a consensus about this being ok to mean 'averaging' I'm 
happy to use this ABI!

M.


>
> Jonathan
>
>> ---
>>  Documentation/ABI/testing/sysfs-bus-iio | 13 +++++++++++++
>>  drivers/iio/industrialio-core.c         |  1 +
>>  include/linux/iio/iio.h                 |  1 +
>>  include/linux/iio/sysfs.h               |  9 +++++++++
>>  4 files changed, 24 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio
>> b/Documentation/ABI/testing/sysfs-bus-iio
>> index 42d360f..a208dfe 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>> @@ -56,6 +56,19 @@ Description:
>>          When the internal sampling clock can only take a small
>>          discrete set of values, this file lists those available.
>>
>> +What:        /sys/bus/iio/devices/iio:deviceX/averaging_ratio
>> +KernelVersion:    4.x.x
>> +Contact:    linux-iio@vger.kernel.org
>> +Description:
>> +        Hardware dependent ADC averaging. Controls the averaging ratio
>> +        of the digital filter if available.
>> +
>> +What:        /sys/bus/iio/devices/iio:deviceX/averaging_ratio_available
>> +KernelVersion:    4.x.x
>> +Contact:    linux-iio@vger.kernel.org
>> +Description:
>> +        Hardware dependent values supported by the averaging filter.
>> +
>>  What:        /sys/bus/iio/devices/iio:deviceX/oversampling_ratio
>>  KernelVersion:    2.6.38
>>  Contact:    linux-iio@vger.kernel.org
>> diff --git a/drivers/iio/industrialio-core.c
>> b/drivers/iio/industrialio-core.c
>> index b3fcc2c..e4745f0 100644
>> --- a/drivers/iio/industrialio-core.c
>> +++ b/drivers/iio/industrialio-core.c
>> @@ -142,6 +142,7 @@ static const char * const iio_chan_info_postfix[] = {
>>      [IIO_CHAN_INFO_DEBOUNCE_TIME] = "debounce_time",
>>      [IIO_CHAN_INFO_CALIBEMISSIVITY] = "calibemissivity",
>>      [IIO_CHAN_INFO_OVERSAMPLING_RATIO] = "oversampling_ratio",
>> +    [IIO_CHAN_INFO_AVERAGING_RATIO] = "averaging_ratio",
>>  };
>>
>>  /**
>> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
>> index 7bb7f67..4c84de5 100644
>> --- a/include/linux/iio/iio.h
>> +++ b/include/linux/iio/iio.h
>> @@ -46,6 +46,7 @@ enum iio_chan_info_enum {
>>      IIO_CHAN_INFO_DEBOUNCE_TIME,
>>      IIO_CHAN_INFO_CALIBEMISSIVITY,
>>      IIO_CHAN_INFO_OVERSAMPLING_RATIO,
>> +    IIO_CHAN_INFO_AVERAGING_RATIO,
>>  };
>>
>>  enum iio_shared_by {
>> diff --git a/include/linux/iio/sysfs.h b/include/linux/iio/sysfs.h
>> index 9cd8f74..4478ba1 100644
>> --- a/include/linux/iio/sysfs.h
>> +++ b/include/linux/iio/sysfs.h
>> @@ -76,6 +76,15 @@ struct iio_const_attr {
>>  /* Generic attributes of onetype or another */
>>
>>  /**
>> + * IIO_CONST_ATTR_AVERAGING_RATIO_AVAIL - list available averaging
>> ratios
>> + * @_string: ratio string for the attribute
>> + *
>> + * Constant version
>> + **/
>> +#define IIO_CONST_ATTR_AVERAGING_RATIO_AVAIL(_string) \
>> +    IIO_CONST_ATTR(averaging_ratio_available, _string)
>> +
>> +/**
>>   * IIO_DEV_ATTR_SAMP_FREQ - sets any internal clock frequency
>>   * @_mode: sysfs file mode/permissions
>>   * @_show: output method for the attribute
>
