From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Tue, 24 Mar 2015 19:26:45 +0000
Message-ID: <5511BA75.3020305@linaro.org>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org> <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org> <20150323210918.GS14954@sirena.org.uk> <55108E2B.7050305@linaro.org> <55112BD6.2070600@linaro.org> <20150324172346.GW17265@sirena.org.uk> <5511AE38.3000108@linaro.org> <20150324190226.GB17265@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150324190226.GB17265@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-api@vger.kernel.org



On 24/03/15 19:02, Mark Brown wrote:
> On Tue, Mar 24, 2015 at 06:34:32PM +0000, Srinivas Kandagatla wrote:
>> >On 24/03/15 17:23, Mark Brown wrote:
>>>> > >>regmap_get_size(regmap)
>>> > >This is already there.
>> >Sorry, I can't see any such api atleast in v4.0-rc5 and linux-next? Are you
>> >referring to another api which does the same job?
> regmap_get_val_bytes()
>
This would return value bytes, but I wanted is the regmap->max_register 
value which would be used for sanity checks in eeprom-core.

--srini
