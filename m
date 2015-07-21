From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Tue, 21 Jul 2015 19:40:53 +0100
Message-ID: <55AE9235.4080809@linaro.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403392-4136-1-git-send-email-srinivas.kandagatla@linaro.org> <55AD6412.9070205@codeaurora.org> <55AE13D8.6020301@linaro.org> <55AE8864.6020608@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AE8864.6020608-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 21/07/15 18:59, Stephen Boyd wrote:
> On 07/21/2015 02:41 AM, Srinivas Kandagatla wrote:
>> Thanks Stephen for review,
>>
>> On 20/07/15 22:11, Stephen Boyd wrote:
>>> On 07/20/2015 07:43 AM, Srinivas Kandagatla wrote:
>>>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>>>> new file mode 100644
>>>> index 0000000..bde5528
>>>> --- /dev/null
>>>> +++ b/drivers/nvmem/core.c
>>>> @@ -0,0 +1,384 @@
>>>>
>>>> +
>>>> +static int nvmem_add_cells(struct nvmem_device *nvmem,
>>>> +               const struct nvmem_config *cfg)
>>>> +{
>>>> +    struct nvmem_cell **cells;
>>>> +    const struct nvmem_cell_info *info = cfg->cells;
>>>> +    int i, rval;
>>>> +
>>>> +    cells = kzalloc(sizeof(*cells) * cfg->ncells, GFP_KERNEL);
>>>
>>> kcalloc?
>>
>> Only reason for using kzalloc is to give the code more flexibility to
>> free any pointer in the array in case of errors.
>
> Still lost. The arrays are allocated down below in the for loop. This is
> allocating a bunch of pointers so using kcalloc() here avoids problems
> with overflows causing kzalloc() to allocate fewer pointers than
> requested. I'm not suggesting we replace the for loop with a kcalloc,
> just this single line.
>
Yes we could replace the loop with kcalloc, but the problem is how can 
we handle freeing an element from that array?

AFAIK we can only free the full array rather than each element if we 
allocate it via kcalloc, correct me if Am wrong?

>>
>>>
>>>> +    if (!cells)
>>>> +        return -ENOMEM;
>>>> +
>>>> +    for (i = 0; i < cfg->ncells; i++) {
>>>> +        cells[i] = kzalloc(sizeof(**cells), GFP_KERNEL);
>>>> +        if (!cells[i]) {
>>>> +            rval = -ENOMEM;
>>>> +            goto err;
>>>> +        }
>>>> +
>
