From: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 2/2] staging: ion: create one device entry per heap
Date: Mon, 23 Oct 2017 17:19:24 +0200
Message-ID: <CA+M3ks6qi1quXdQZc8W7721eptsWL0g+Axa+KsWBsCpPDWy64g@mail.gmail.com>
References: <1506518409-16887-1-git-send-email-benjamin.gaignard@linaro.org>
 <1506518409-16887-3-git-send-email-benjamin.gaignard@linaro.org> <bff3d0c7-110d-d702-165b-855daaca6382@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bff3d0c7-110d-d702-165b-855daaca6382-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Riley Andrews <riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

2017-10-18 22:07 GMT+02:00 Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On 09/27/2017 06:20 AM, Benjamin Gaignard wrote:
>> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
>> index 93e2c90..092b24c 100644
>> --- a/drivers/staging/android/ion/ion.c
>> +++ b/drivers/staging/android/ion/ion.c
>> @@ -40,6 +40,8 @@
>>
>>  #include "ion.h"
>>
>> +#define ION_DEV_MAX 32
>> +
>>  static struct ion_device *internal_dev;
>>  static int heap_id;
>>
>> @@ -537,15 +539,28 @@ static int debug_shrink_get(void *data, u64 *val)
>>  DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
>>                       debug_shrink_set, "%llu\n");
>>
>> -void ion_device_add_heap(struct ion_heap *heap)
>> +int ion_device_add_heap(struct ion_heap *heap)
>>  {
>>       struct dentry *debug_file;
>>       struct ion_device *dev = internal_dev;
>> +     int ret = 0;
>>
>>       if (!heap->ops->allocate || !heap->ops->free)
>>               pr_err("%s: can not add heap with invalid ops struct.\n",
>>                      __func__);
>>
>> +     if (heap_id >= ION_DEV_MAX)
>> +             return -EBUSY;
>> +
>> +     heap->ddev.devt = MKDEV(MAJOR(dev->devt), heap_id);
>> +     dev_set_name(&heap->ddev, "ion%d", heap_id);
>> +     device_initialize(&heap->ddev);
>> +     cdev_init(&heap->chrdev, &ion_fops);
>> +     heap->chrdev.owner = THIS_MODULE;
>> +     ret = cdev_device_add(&heap->chrdev, &heap->ddev);
>> +     if (ret < 0)
>> +             return ret;
>> +
>>       spin_lock_init(&heap->free_lock);
>>       heap->free_list_size = 0;
>>
>> @@ -583,6 +598,8 @@ void ion_device_add_heap(struct ion_heap *heap)
>>
>>       dev->heap_cnt++;
>>       up_write(&dev->lock);
>> +
>> +     return ret;
>>  }
>>  EXPORT_SYMBOL(ion_device_add_heap);
>>
>> @@ -595,6 +612,7 @@ static int ion_device_create(void)
>>       if (!idev)
>>               return -ENOMEM;
>>
>> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
>>       idev->dev.minor = MISC_DYNAMIC_MINOR;
>>       idev->dev.name = "ion";
>>       idev->dev.fops = &ion_fops;
>> @@ -605,6 +623,17 @@ static int ion_device_create(void)
>>               kfree(idev);
>>               return ret;
>>       }
>> +#endif
>> +
>> +     ret = alloc_chrdev_region(&idev->devt, 0, ION_DEV_MAX, "ion");
>> +     if (ret) {
>> +             pr_err("ion: unable to allocate device\n");
>> +#ifdef CONFIG_ION_LEGACY_DEVICE_API
>> +             misc_deregister(&idev->dev);
>> +#endif
>> +             kfree(idev);
>> +             return ret;
>> +     }
>>
>>       idev->debug_root = debugfs_create_dir("ion", NULL);
>>       if (!idev->debug_root) {
>
> I'm not 100% sure about the device hierarchy here. We're
> ending up with devices at the root of /sys/devices
>
> /sys/devices # ls
> breakpoint ion0 ion1 ion2 platform software system virtual
>
> and the Android init system doesn't pick this up. I'll
> admit to being out of my area here but I don't think
> this looks quite right.
>

You are right it is because ion devices are parentless so they
directly put under /sys/devices directory. I will give them platform_bus
as parent to solve that problem.

Benjamin

> Thanks,
> Laura
>
>
