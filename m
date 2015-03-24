From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Tue, 24 Mar 2015 18:34:32 +0000
Message-ID: <5511AE38.3000108@linaro.org>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org> <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org> <20150323210918.GS14954@sirena.org.uk> <55108E2B.7050305@linaro.org> <55112BD6.2070600@linaro.org> <20150324172346.GW17265@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20150324172346.GW17265@sirena.org.uk>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 24/03/15 17:23, Mark Brown wrote:
> On Tue, Mar 24, 2015 at 09:18:14AM +0000, Srinivas Kandagatla wrote:
>
>> I did try your suggestion, by which I could remove the regmap from config.
>> One thing I did not like was eeprom-core getting size/stride info directly
>> from providers and regmap from regmap apis. I was wondering if we could take
>> a step further and introduce new regmap helpers like
>
>> regmap_get_size(regmap)
>
> This is already there.
Sorry, I can't see any such api atleast in v4.0-rc5 and linux-next? Are 
you referring to another api which does the same job?

>
>> regmap_get_stride(regmap)
>
>> Which would be give eeprom-core the size and stride info, doing this way
>> would cut down regmap related things from eeprom_config structure to minimal
>> and also the source of information would come from just regmap apis.
>
> Documentation/SubmittingPatches...
>
Am not sure what you meant here, Am guessing that you asked me to keep 
the respective maintainers in the loop and follow the guide, when I 
resend the patch?

--srini
