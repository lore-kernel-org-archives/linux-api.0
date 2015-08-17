From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH RFC 3/3] nvmem: add permission flags in nvmem_config
Date: Mon, 17 Aug 2015 13:31:34 +0100
Message-ID: <55D1D426.8020504@linaro.org>
References: <1439290931-18232-1-git-send-email-srinivas.kandagatla@linaro.org> <1439291024-18375-1-git-send-email-srinivas.kandagatla@linaro.org> <1634428787.18822.1439623316281.JavaMail.open-xchange@oxbsltgw04.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1634428787.18822.1439623316281.JavaMail.open-xchange@oxbsltgw04.schlund.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, p.zabel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>, sboyd@codeaurora.org, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, khilman@kernel.org, maitysanchayan@gmail.com, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org



On 15/08/15 08:21, Stefan Wahren wrote:
> Hi Srinivas,
>
>> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> hat am 11. August 2015 um
>> 13:03 geschrieben:
>>
>>
>> This patch adds perm variable to nvmem_config structure which will allow
>> providers to specify the permissions required for the sysfs binary file.
>> This permission is applied on top of root-only access permissions set by
>> the core.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> ---
>> drivers/nvmem/core.c | 1 +
>> include/linux/nvmem-provider.h | 1 +
>> 2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>> index 414ed23..7481387 100644
>> --- a/drivers/nvmem/core.c
>> +++ b/drivers/nvmem/core.c
>> @@ -312,6 +312,7 @@ struct nvmem_device *nvmem_register(const struct
>> nvmem_config *config)
>> config->read_only;
>> nvmem->bin = bin_attr_template;
>> nvmem->bin.attr.mode = nvmem->read_only ? : (S_IRUSR | S_IWUSR);
>> + nvmem->bin.attr.mode |= config->perm;
>> nvmem->bin.size = nvmem->size;
>> device_initialize(&nvmem->dev);
>>
>> diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
>> index 0b68caf..de9a61f 100644
>> --- a/include/linux/nvmem-provider.h
>> +++ b/include/linux/nvmem-provider.h
>> @@ -23,6 +23,7 @@ struct nvmem_config {
>> const struct nvmem_cell_info *cells;
>> int ncells;
>> bool read_only;
>> + u16 perm; /* visibility in sysfs */
>
> how about "umode_t mode" or "umode_t sysfs_mode"?
>
Yep, "umode_t mode" sounds much better.
I will use it that.

--srini
> Beside that the whole series looks good to me.
>
> Thanks Stefan
>
