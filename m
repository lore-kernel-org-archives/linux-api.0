From: Chunyan Zhang <zhang.chunyan@linaro.org>
Subject: Re: [PATCH V2 2/6] stm class: adds a loop to extract the first valid
 STM device name
Date: Fri, 5 Feb 2016 11:18:41 +0800
Message-ID: <CAG2=9p_JACdQrrwqUaU6uqY9JzsO_xHjz7W0MXBP6Ss5B-AExA@mail.gmail.com>
References: <1454487337-30184-3-git-send-email-zhang.chunyan@linaro.org>
	<1454576179-27224-1-git-send-email-zhang.chunyan@linaro.org>
	<871t8se62k.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <871t8se62k.fsf@ashishki-desk.ger.corp.intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>, robh@kernel.org, Mark Brown <broonie@kernel.org>, pratikp@codeaurora.org, nicolas.guion@st.com, Jon Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, Mike Leach <mike.leach@arm.com>, Tor Jeremiassen <tor@ti.com>, Al Grant <al.grant@arm.com>, Lyra Zhang <zhang.lyra@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 5, 2016 at 1:30 AM, Alexander Shishkin
<alexander.shishkin@linux.intel.com> wrote:
> Chunyan Zhang <zhang.chunyan@linaro.org> writes:
>
> I few comments below:
>
>> The node name of STM master management policy is a concatenation of an
>> STM device name to which this policy applies and following an arbitrary
>> string, these two strings are concatenated with a dot.
>
> This is true.
>
>> This patch adds a loop for extracting the STM device name when an
>> arbitrary number of dot(s) are found in this STM device name.
>
> It's not very easy to tell what's going on here from this
> description. The reader be left curious as to why an arbitrary number of
> dots is a reason to run a loop. When in doubt, try to imagine as if
> you're seeing this patch for the first time and ask yourself, does the
> message give a clear explanation of what's going on in it.
>
>> Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
>> ---
>>  drivers/hwtracing/stm/policy.c | 27 ++++++++++++++++-----------
>>  1 file changed, 16 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
>> index 11ab6d0..691686e 100644
>> --- a/drivers/hwtracing/stm/policy.c
>> +++ b/drivers/hwtracing/stm/policy.c
>> @@ -321,21 +321,26 @@ stp_policies_make(struct config_group *group, const char *name)
>>       /*
>>        * node must look like <device_name>.<policy_name>, where
>>        * <device_name> is the name of an existing stm device and
>> -      * <policy_name> is an arbitrary string
>> +      * <policy_name> is an arbitrary string, when an arbitrary
>> +      * number of dot(s) are found in the <device_name>, the
>> +      * first matched STM device name would be extracted.
>>        */
>
> This leaves room for a number of suspicious situations. What if both
> "xyz" and "xyz.0" are stm devices, how would you create a policy for the
> latter, for example?
>
> The rules should be such that you can tell exactly what the intended stm
> device is from a policy directory name, otherwise it's just asking for
> trouble.
>
>> -     p = strchr(devname, '.');
>> -     if (!p) {
>> -             kfree(devname);
>> -             return ERR_PTR(-EINVAL);
>> -     }
>> +     for (p = devname; ; p++) {
>> +             p = strchr(p, '.');
>> +             if (!p) {
>> +                     kfree(devname);
>> +                     return ERR_PTR(-EINVAL);
>> +             }
>>
>> -     *p++ = '\0';
>> +             *p = '\0';
>>
>> -     stm = stm_find_device(devname);
>> -     kfree(devname);
>> +             stm = stm_find_device(devname);
>> +             if (stm)
>> +                     break;
>> +             *p = '.';
>> +     }
>>
>> -     if (!stm)
>> -             return ERR_PTR(-ENODEV);
>> +     kfree(devname);
>
> In the existing code there is a clear distinction between -ENODEV, which
> is to say "we didn't find the device" and -EINVAL, "directory name
> breaks rules/is badly formatted". After the change, it's all -EINVAL,
> which also becomes "we tried everything, sorry".
>
> So, having said all that, does the following patch solve your problem:

Yes, I originally modified as well like your following patch, but at
that moment, I didn't get your agreement that the policy name (i.e. an
arbitrary string) cannot contain dots, so I had to consider the case.
Whatever, there isn't a panacea.  I'm very good with your patch.  Many
thanks for your review and providing the patch.


Chunyan

>
> From 870dc5fefa5623c39552511d31e0fa0da984d581 Mon Sep 17 00:00:00 2001
> From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Date: Thu, 4 Feb 2016 18:56:34 +0200
> Subject: [PATCH] stm class: Support devices with multiple instances
>
> By convention, the name of the stm policy directory in configfs consists of
> the device name to which it applies and the actual policy name, separated
> by a dot. Now, some devices already have dots in their names that separate
> name of the actual device from its instance identifier. Such devices will
> result in two (or more, who can tell) dots in the policy directory name.
>
> Existing policy code, however, will treat the first dot as the one that
> separates device name from policy name, therefore failing the above case.
>
> This patch makes the last dot in the directory name be the separator, thus
> prohibiting dots from being used in policy names.
>
> Suggested-by: Chunyan Zhang <zhang.chunyan@linaro.org>
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> ---
>  drivers/hwtracing/stm/policy.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
> index 94d3abfb73..1db189657b 100644
> --- a/drivers/hwtracing/stm/policy.c
> +++ b/drivers/hwtracing/stm/policy.c
> @@ -332,10 +332,11 @@ stp_policies_make(struct config_group *group, const char *name)
>
>         /*
>          * node must look like <device_name>.<policy_name>, where
> -        * <device_name> is the name of an existing stm device and
> -        * <policy_name> is an arbitrary string
> +        * <device_name> is the name of an existing stm device; may
> +        *               contain dots;
> +        * <policy_name> is an arbitrary string; may not contain dots
>          */
> -       p = strchr(devname, '.');
> +       p = strrchr(devname, '.');
>         if (!p) {
>                 kfree(devname);
>                 return ERR_PTR(-EINVAL);
> --
> 2.7.0
>
