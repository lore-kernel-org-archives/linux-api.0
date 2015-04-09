From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for
 eeprom consumers
Date: Thu, 9 Apr 2015 07:45:22 -0700
Message-ID: <20150409144522.GB9663@codeaurora.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150407184533.GA10278@codeaurora.org>
 <55243982.7020907@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55243982.7020907@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On 04/07, Srinivas Kandagatla wrote:
> On 07/04/15 19:45, Stephen Boyd wrote:
> >On 03/30, Srinivas Kandagatla wrote:
> >
> >Do you have an overview of how to use these APIs? Maybe some
> >Documentation/ is in order? I'm mostly interested in how the
> >blocks array is supposed to work and how this hooks up to drivers
> >that are using DT.
> 
> Only doc ATM is function level kernel doc in c file.
> May be I can explain you for now and I will try to add some
> documentation with some usage examples in next version.

Thanks.

> 
> eeprom block array is just another way intended to get hold of
> eeprom content for non-DT providers/consumers, but DT
> consumers/providers can also use it. As of today SOC/mach level code
> could use it as well.
> 
> In eeprom_cell_get() case the lookup of provider is done based on
> provider name, this provider name is generally supplied by all the
> providers (both DT/non DT).
> 
> for example in qfprom case,
> provider is registered from DT with eeprom config containing a unique name:
> static struct eeprom_config econfig = {
> 	.name = "qfprom",
> 	.id = 0,
> };
> 
> In the consumer case, the tsens driver could do some like in non DT way:
> 
> 	struct eeprom_block blocks[4] ={
> 		{
> 		.offset = 0x404,
> 		.count = 0x4,
> 		},
> 		{
> 		.offset = 0x408,
> 		.count = 0x4,
> 		},
> 		{
> 		.offset = 0x40c,
> 		.count = 0x4,
> 		},
> 		{
> 		.offset = 0x410,
> 		.count = 0x4,
> 		},
> 	};
> 	calib_cell = eeprom_cell_get("qfprom0", blocks, 4);
> 
> 
> Or in DT way
> calib_cell  = of_eeprom_cell_get(np, "calib");
> 

Ok. I guess I was hoping for a more device centric approach like
we have for clks/regulators/etc. That way a driver doesn't need
to know it's using DT or not to figure out which API to call.
Also the global namespace is sort of worrying (qfprom0 part). How
do we know it's qfprom0? What if it's qfprom1 sometimes?

Also, how are we supposed to encode certain bits inside the
stream of bytes (blocks)? In some situations (e.g. the qcom CPR
stuff) we have quite a few fuse bits we need to read that are
packed into different bytes and may cross byte boundaries (i.e.
bits 6 to 10 of a 32-bit word). The current API looks to be byte
focused when I have bit based/non-byte aligned data.

My current feeling is that I don't want to use any of the block
stuff at all. I just want a simple byte-based API that allows me
to read a number of contiguous bytes from the fuses. Then I'll
need to shift that data down by a few bits and mask it with the
width of the data I want to read to extract the data needed.

The only thing after that where I have a problem is figuring out
which eeprom is present in the consumer driver. I think I may
need to open-code it and look at the phandle for the eeprom and
do a compatible check to figure out which bits I want to read.

The DT would be like this (note I left eeprom-cells/eeproms here
because that allows us to generically find eeproms used by a
device and find eeprom providers):

	qfprom: eeprom@58000 {
		compatible = "qcom,qfprom-msm8916";
		reg = <0x58000 0x7000>;
		#eeprom-cells = <0>;
	};
	
	cpr@b018000 {
		compatible = "qcom,cpr";
		reg = <0xb018000 0x1000>;
		interrupts = <0 15 1>, <0 16 1>, <0 17 1>;
		eeproms = <&qfprom>;
		...
	};

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
