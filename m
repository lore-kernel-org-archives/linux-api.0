From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v4 05/10] eeprom: Add bindings for simple eeprom framework
Date: Tue, 07 Apr 2015 19:03:30 +0100
Message-ID: <55241BF2.4050609@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org> <1427752679-17261-1-git-send-email-srinivas.kandagatla@linaro.org> <20150406133208.GH30984@beef> <CAL_Jsq++9pyJMLXssgyz2WRU4e7ikT_6FwzWMo1fKS82FJvEyg@mail.gmail.com> <20150406150442.GA26319@beef> <55241575.7040809@linaro.org> <20150407174624.GO6023@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150407174624.GO6023@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Matt Porter <mporter@konsulko.com>, Rob Herring <robherring2@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sascha Hauer <s.hauer@pengutronix.de>, Stephen Boyd <sboyd@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



On 07/04/15 18:46, Mark Brown wrote:
> On Tue, Apr 07, 2015 at 06:35:49PM +0100, Srinivas Kandagatla wrote:
>> On 06/04/15 16:04, Matt Porter wrote:
>>> On Mon, Apr 06, 2015 at 09:11:05AM -0500, Rob Herring wrote:
>
>>>>> The generic binding could really use a "read-only" property here as this
>>>>> is a common hardware attribute for many nvmem devices. A serial EEPROM
>
>> Correct me If am wrong.
>
>> Regarding write protection/read-only, regmap already has provisions to
>> support this feature. regmap would bail out with errors if any attempt to
>> write to non-writable regions. It all depends on the data providers how they
>> setup the regmap and the bindings for those are specific individual data
>> providers I think.
>
> There is the ability to flag read/write permissions in regmap but I
> think there's some suggestion that this should be exposed to userspace
> so that it's easier for it to handle things rather than just writing
> then coping with any errors.

Yes, That's possible if the data provider use the "read-only" generic 
binding like MTD partitions which the eeprom framwork could use to set 
the binary file mode appropriately.

"read-only" property seems to be more generic for all types of data 
providers.

I will give it a try and document this in the bindings too in next version.

--srini
>
