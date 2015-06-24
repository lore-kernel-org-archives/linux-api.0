From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH v6 0/9] Add simple NVMEM Framework via regmap.
Date: Wed, 24 Jun 2015 14:30:26 +0200
Message-ID: <558AA2E2.1010606@i2se.com>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <235181230.251177.1435088854197.JavaMail.open-xchange@oxbsltgw00.schlund.de> <558A7C92.2040102@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <558A7C92.2040102@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-arm-kernel@lists.infradead.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, wxt@rock-chips.com, linux-api@vger.kernel.org, Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, Maxime Ripard <maxime.ripard@free-electrons.com>, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

Am 24.06.2015 um 11:46 schrieb Srinivas Kandagatla:
>
>
> On 23/06/15 20:47, Stefan Wahren wrote:
>>> 0001000
>>> >
>> i want to port OCOTP driver for MXS, which hasn't MMIO. From my
>> understanding
> That's cool.
>
>> hexdump would readout the complete register range defined in provider
>> DT node.
>>
>> How can i achieve that hexdump only reads the data area within the
>> register
>> range?
>
> If the question is just about hexdump, then hexdump itself can read
> file from given offset and size.

yes, this is my question at first. Let me show the difference between
the current implementation and my expectations as a user.

$ hexdump /sys/class/nvmem/mxs-ocotp/nvmem

Current implementation: dump the complete register range defined in DT

User expectation: dump only the data from OCOTP block

Let me explain it for i.MX28 OCOTP

0x8002c000 // Start of OCOTP register block (defined in DT)

0x8002c020 // First data register

0x8002c290 // Last data register

0x8002dfff // End of OCOTP register block (defined in DT)

My knowledge about regmap is limited, but how can i achieve that hexdump
give me only the data registers? From my understanding this should be
handled in regmap and not in the read function.

Are my expectations about the raw access wrong?


>
> But I believe the real question is "How can we dump each nvmem cell
> independently"
>
> In one of my replies I mentioned that am planning to add sysfs entries
> under /sys/class/nvmem/<provider>/cells/
>
> ex:
> for qfprom tsens calibration it would look like:
>
> $ hexdump /sys/class/nvmem/qfprom0/cells/tsens_calibration
>
> 0000000 e000 0c00 0c00 0000 0c00
> ...
>
> Is that what you guys are looking for?

That would be nice, too :-)

>
> --srini
>>
>> Stefan

TIA

Stefan
