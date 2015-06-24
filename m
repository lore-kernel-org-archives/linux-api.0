From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v6 8/9] nvmem: sunxi: Move the SID driver to the nvmem
 framework
Date: Wed, 24 Jun 2015 10:48:56 +0100
Message-ID: <558A7D08.1000403@linaro.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014583-26478-1-git-send-email-srinivas.kandagatla@linaro.org> <1335062615.252618.1435092272970.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1335062615.252618.1435092272970.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stefan Wahren <stefan.wahren@i2se.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, Maxime Ripard <maxime.ripard@free-electrons.com>, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org



On 23/06/15 21:44, Stefan Wahren wrote:
>
>> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> hat am 23. Juni 2015 um
>> 01:09 geschrieben:
>>
>>
>> From: Maxime Ripard <maxime.ripard@free-electrons.com>
>>
>> Now that we have the nvmem framework, we can consolidate the common
>> driver code. Move the driver to the framework, and hopefully, it will
>> fix the sysfs file creation race.
>> --- /dev/null
>> +++ b/drivers/nvmem/sunxi-sid.c
>> [...]
>> +
>> +static int sunxi_sid_write(void *context, const void *data, size_t count)
>> +{
>> + /* Unimplemented */
>> + return 0;
>> +}
>> +
>
> I think it should be clear that the write operation isn't implemented. It's more
> important to know the function should make
> regmap_init happy.


I totally agree with you.. It was just to make regmap_init happy. Indeed 
I thought of adding this comment, but forgot over the time :-) I will 
fix it.

--srini


> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
