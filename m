From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Wed, 29 Jul 2015 09:55:22 +0100
Message-ID: <55B894FA.8050008@linaro.org>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org> <55B893A7.2030206@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <55B893A7.2030206@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Rajendra Nayak <rnayak@codeaurora.org>, khilman@kernel.org, linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org



On 29/07/15 09:49, Rajendra Nayak wrote:
> On 07/27/2015 04:42 PM, Srinivas Kandagatla wrote:
>> Hi Greg/Kevin,
>>
>> This patchset adds a new simple NVMEM framework to kernel, and it is
>> tested
>> with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
>> "begal bone cape manager" and few more on the way.
>>
>> Can you please consider this as 4.3 material, AFAIK there are more
>> than 3 drivers
>> depending on this framework which are wating since last 2 merge windows.
>
> I have been testing these with the qcom tsens driver, and did test v9
> as well, so feel free to add my tested by for the entire series,
>
> Tested-by: Rajendra Nayak <rnayak@codeaurora.org>

Thanks Rajendra for the tested-by.
