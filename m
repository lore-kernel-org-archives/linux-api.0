From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] iio: export mounting matrix information
Date: Mon, 4 May 2015 20:48:23 +0300
Message-ID: <CAE1zot+X5RV7iexE4dUPY_YBGP4Zet1S1hSmauP8-e5P59nXRQ@mail.gmail.com>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
	<1430146908-27919-2-git-send-email-octavian.purdila@intel.com>
	<55475710.9050707@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55475710.9050707-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael J Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 4, 2015 at 2:25 PM, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On 27/04/15 16:01, Octavian Purdila wrote:
>> Export a new sysfs attribute that describes the placement of the
>> sensor on the device in the form of a mounting matrix so that
>> userspace can do the required correction to get accurate data:
>>
>> corrected X = MM[0] * X + MM[1] Y + MM[2] * Z
>> corrected Y = MM[3] * X + MM[4] Y + MM[5] * Z
>> corrected Z = MM[6] * X + MM[7] Y + MM[8] * Z
>>
>> This information is read from the device properties of the parent of
>> the IIO device.
>>
>> Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Hmm.  This could be done with existing code and a new info_mask element.
> The disadvantage is you'd have to change the read_raw to read_raw_multi
> callback, but that's hardly a big job.  If I could be bothered, I'd
> move the whole subsystem over and drop read_raw entirely.
>
> It was introduced precisely for this sort of element.

If I understand this correctly this will require changing every driver
that want to expose this information. However, this information is
independent of the driver, as this information is read from the device
tree or ACPI. As such, doesn't this fits better in the IIO core?

> As I mentioned deeper in the thread.  If we are going to introduce a mounting
> matrix, I'd prefer a version that includes translation.  It might not matter
> to many devices but it has mattered a lot to me in the past and doesn't hurt
> others that much (I used to write papers on how to estimate this stuff
> from black box devices).

OK, I will look into that.


>> ---
>>  Documentation/ABI/testing/sysfs-bus-iio | 11 +++++++++
>>  drivers/iio/industrialio-core.c         | 42 +++++++++++++++++++++++++++++++++
>>  include/linux/iio/iio.h                 |  9 +++++++
>>  3 files changed, 62 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
>> index 866b4ec..d36476e 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-iio
>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
>> @@ -1375,3 +1375,14 @@ Description:
>>               The emissivity ratio of the surface in the field of view of the
>>               contactless temperature sensor.  Emissivity varies from 0 to 1,
>>               with 1 being the emissivity of a black body.
>> +
>> +What:                /sys/bus/iio/devices/iio:deviceX/mounting_matrix
>> +KernelVersion:       4.2
>> +Contact:     linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> +Description:
>> +             A list of 9 floating point values that describes the
>> +             transformation needed to account for the way the sensor has been
>> +             placed on the PCB:
>> +             corrected X = MM[0] * X + MM[1] Y + MM[2] * Z
>> +             corrected Y = MM[3] * X + MM[4] Y + MM[5] * Z
>> +             corrected Z = MM[6] * X + MM[7] Y + MM[8] * Z
>> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
>> index 7c98bc1..9000c53 100644
>> --- a/drivers/iio/industrialio-core.c
>> +++ b/drivers/iio/industrialio-core.c
>> @@ -871,6 +871,45 @@ static ssize_t iio_show_dev_name(struct device *dev,
>>
>>  static DEVICE_ATTR(name, S_IRUGO, iio_show_dev_name, NULL);
>>
>> +static bool iio_get_mounting_matrix(struct iio_dev *indio_dev)
>> +{
>> +     int i, err;
>> +
>> +     err = device_property_read_u32_array(&indio_dev->dev, "mounting-matrix",
>> +                                          indio_dev->mounting_matrix, 9);
>> +     if (!err) {
>> +             int *mm = indio_dev->mounting_matrix;
>> +
>> +             for (i = IIO_MM_SIZE - 2; i > 0; i -= 2) {
>> +                     mm[i] = mm[i / 2];
>> +                     mm[i + 1] = 0;
>> +             }
>> +
>> +             return true;
>> +     }
>> +
>> +     return false;
>> +}
>> +
>> +static ssize_t iio_show_mounting_matrix(struct device *dev,
>> +                                     struct device_attribute *attr,
>> +                                     char *buf)
>> +{
>> +     struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>> +     char *tmp = buf;
>> +     int i;
>> +
>> +     for (i = 0; i < IIO_MM_SIZE; i += 2) {
>> +             tmp += iio_format_value(tmp, IIO_VAL_INT_PLUS_MICRO, 2,
>> +                                     &indio_dev->mounting_matrix[i]);
>> +             if (((i + 2) / 2) % 3)
> Hmm. if (i != 8) should also do the job with slightly less feedling of
> magic..
>> +                     tmp[-1] = ' ';
>> +     }
>> +     return tmp - buf;
>> +}
>> +
>> +static DEVICE_ATTR(mounting_matrix, S_IRUGO, iio_show_mounting_matrix, NULL);
>> +
>>  static int iio_device_register_sysfs(struct iio_dev *indio_dev)
>>  {
>>       int i, ret = 0, attrcount, attrn, attrcount_orig = 0;
>> @@ -920,6 +959,9 @@ static int iio_device_register_sysfs(struct iio_dev *indio_dev)
>>               indio_dev->chan_attr_group.attrs[attrn++] = &p->dev_attr.attr;
>>       if (indio_dev->name)
>>               indio_dev->chan_attr_group.attrs[attrn++] = &dev_attr_name.attr;
>> +     if (iio_get_mounting_matrix(indio_dev))
>> +             indio_dev->chan_attr_group.attrs[attrn++] =
>> +                     &dev_attr_mounting_matrix.attr;
>>
>>       indio_dev->groups[indio_dev->groupcounter++] =
>>               &indio_dev->chan_attr_group;
>> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
>> index b1e46ae..c1fa852 100644
>> --- a/include/linux/iio/iio.h
>> +++ b/include/linux/iio/iio.h
>> @@ -434,6 +434,8 @@ struct iio_buffer_setup_ops {
>>                                  const unsigned long *scan_mask);
>>  };
>>
>> +#define IIO_MM_SIZE          18
>> +
>>  /**
>>   * struct iio_dev - industrial I/O device
>>   * @id:                      [INTERN] used to identify device internally
>> @@ -469,6 +471,12 @@ struct iio_buffer_setup_ops {
>>   * @groups:          [INTERN] attribute groups
>>   * @groupcounter:    [INTERN] index of next attribute group
>>   * @flags:           [INTERN] file ops related flags including busy flag.
> Hmm. No absolute need to have this new data in the iio_dev.  I'd do it
> via the read_raw_multi callback, though this will require converting read_raw
> over to that more flexible version.
>> + * @mounting_matrix: [INTERN] the mounting matrix is a series of 9
>> + *                   IIO_VAL_INT_PLUS_MICRO pairs that describes the
>> + *                   transformation needed to account for the way the sensor
>> + *                   has been placed on the PCB. See the mounting_matrix
>> + *                   entry in Documentation/ABI/testing/sysfs-bus-iio about
>> + *                   details of the transformation operations.
>>   * @debugfs_dentry:  [INTERN] device specific debugfs dentry.
>>   * @cached_reg_addr: [INTERN] cached register address for debugfs reads.
>>   */
>> @@ -509,6 +517,7 @@ struct iio_dev {
>>       int                             groupcounter;
>>
>>       unsigned long                   flags;
>> +     int                             mounting_matrix[IIO_MM_SIZE];
>>  #if defined(CONFIG_DEBUG_FS)
>>       struct dentry                   *debugfs_dentry;
>>       unsigned                        cached_reg_addr;
>>
>
