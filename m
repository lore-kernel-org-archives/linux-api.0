From: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v5 03/11] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Tue, 23 Jun 2015 17:24:34 -0700
Message-ID: <5589F8C2.3030502@codeaurora.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226583-8775-1-git-send-email-srinivas.kandagatla@linaro.org> <5580A678.4080304@codeaurora.org> <5582BDAE.5040008@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5582BDAE.5040008-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/18/2015 05:46 AM, Srinivas Kandagatla wrote:
> Many thanks for review.
>
> On 16/06/15 23:43, Stephen Boyd wrote:
>> On 05/21/2015 09:43 AM, Srinivas Kandagatla wrote:
>>>
>>>> +
>>>> +static int nvmem_add_cells(struct nvmem_device *nvmem,
>>>> +               struct nvmem_config *cfg)
>>>> +{
>>>> +    struct nvmem_cell **cells;
>>>> +    struct nvmem_cell_info *info = cfg->cells;
>>>> +    int i, rval;
>>>> +
>>>> +    cells = kzalloc(sizeof(*cells) * cfg->ncells, GFP_KERNEL);
>>>
>>> kcalloc
> This is temporary array, I did this on intention, to make it easy to
> kfree cells which are found invalid at runtime.

Ok, but how does that change using kcalloc over kzalloc? I must have
missed something.

>
>
>>> + *
>>> + * The return value will be an ERR_PTR() on error or a valid pointer
>>> +    nvmem->dev.of_node = config->dev->of_node;
>>> +    dev_set_name(&nvmem->dev, "%s%d",
>>> +             config->name ? : "nvmem", config->id);
>>
>> It may be better to always name it nvmem%d so that we don't allow the
>> possibility of conflicts.
> We can do that, but I wanted to make the sysfs and dev entries more
> readable than just nvmem0, nvmem1...

Well sysfs is not really for humans. It's for machines. The nvmem
devices could have a name property so that a more human readable string
is present.

>
>>> +
>>> +    device_initialize(&nvmem->dev);
>>> +
>>> +    dev_dbg(&nvmem->dev, "Registering nvmem device %s\n",
>>> +        dev_name(&nvmem->dev));
>>> +
>>> +    rval = device_add(&nvmem->dev);
>>> +    if (rval) {
>>> +        ida_simple_remove(&nvmem_ida, nvmem->id);
>>> +        kfree(nvmem);
>>> +        return ERR_PTR(rval);
>>> +    }
>>> +
>>> +    /* update sysfs attributes */
>>> +    if (nvmem->read_only)
>>> +        sysfs_update_group(&nvmem->dev.kobj, &nvmem_bin_ro_group);
>>
>> It would be nice if this could be done before the device was registered.
>> Perhaps have two device_types, one for read-only and one for read/write?
>
> The attributes are actually coming from the class object, so we have
> no choice to update the attributes before the device is registered.
>
> May it would be more safe to have default as read-only and modify it
> to read/write based on read-only flag?
>
>

Can you assign the attributes to the device_type in the nvmem::struct
device? I don't see why these attributes need to be part of the class.

>>
>>> +{
>>> +    return class_register(&nvmem_class);
>>
>> I thought class was on the way out? Aren't we supposed to use bus types
>> for new stuff?
> Do you remember any conversation on the list about this? I could not
> find it on web.
>
> on the other hand, nvmem is not really a bus, making it a bus type
> sounds incorrect to me.
>

I found this post on the cpu class that Sudeep tried to introduce[1].
And there's this post from Kay that alludes to a unification of busses
and classes[2]. And some other post where Kay says class is dead [3].

[1] https://lkml.org/lkml/2014/8/21/191
[2] https://lwn.net/Articles/471821/
[3] https://lkml.org/lkml/2010/11/11/17

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
