From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v8 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Tue, 21 Jul 2015 19:51:03 +0100
Message-ID: <55AE9497.1040101@linaro.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403392-4136-1-git-send-email-srinivas.kandagatla@linaro.org> <55AD6412.9070205@codeaurora.org> <55AE13D8.6020301@linaro.org> <55AE8864.6020608@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <55AE8864.6020608@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com, Maxime Ripard <maxime.ripard@free-electrons.com>
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

My bad, I think I miss understood your suggestion, Yes, we can allocate 
pointers using kzalloc.

--srini
>
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
