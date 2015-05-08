From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for
 eeprom consumers
Date: Fri, 8 May 2015 07:23:18 +0200
Message-ID: <20150508052318.GZ6325@pengutronix.de>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150407184533.GA10278@codeaurora.org>
 <55243982.7020907@linaro.org>
 <20150409144522.GB9663@codeaurora.org>
 <5548AD98.50801@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5548AD98.50801@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On Tue, May 05, 2015 at 12:46:32PM +0100, Srinivas Kandagatla wrote:
> Hi Stephen,
> 
> Sorry I took so long to reply.
> 
> 
> On 09/04/15 15:45, Stephen Boyd wrote:
> >On 04/07, Srinivas Kandagatla wrote:
> >>On 07/04/15 19:45, Stephen Boyd wrote:
> >>>On 03/30, Srinivas Kandagatla wrote:
> >>>
> >>>Do you have an overview of how to use these APIs? Maybe some
> >>>Documentation/ is in order? I'm mostly interested in how the
> >>>blocks array is supposed to work and how this hooks up to drivers
> >>>that are using DT.
> >>
> >>Only doc ATM is function level kernel doc in c file.
> >>May be I can explain you for now and I will try to add some
> >>documentation with some usage examples in next version.
> >
> >Thanks.
> >
> >>
> >>eeprom block array is just another way intended to get hold of
> >>eeprom content for non-DT providers/consumers, but DT
> >>consumers/providers can also use it. As of today SOC/mach level code
> >>could use it as well.
> >>
> >>In eeprom_cell_get() case the lookup of provider is done based on
> >>provider name, this provider name is generally supplied by all the
> >>providers (both DT/non DT).
> >>
> >>for example in qfprom case,
> >>provider is registered from DT with eeprom config containing a unique name:
> >>static struct eeprom_config econfig = {
> >>	.name = "qfprom",
> >>	.id = 0,
> >>};
> >>
> >>In the consumer case, the tsens driver could do some like in non DT way:
> >>
> >>	struct eeprom_block blocks[4] ={
> >>		{
> >>		.offset = 0x404,
> >>		.count = 0x4,
> >>		},
> >>		{
> >>		.offset = 0x408,
> >>		.count = 0x4,
> >>		},
> >>		{
> >>		.offset = 0x40c,
> >>		.count = 0x4,
> >>		},
> >>		{
> >>		.offset = 0x410,
> >>		.count = 0x4,
> >>		},
> >>	};
> >>	calib_cell = eeprom_cell_get("qfprom0", blocks, 4);
> >>
> >>
> >>Or in DT way
> >>calib_cell  = of_eeprom_cell_get(np, "calib");
> >>
> >
> >Ok. I guess I was hoping for a more device centric approach like
> >we have for clks/regulators/etc. That way a driver doesn't need
> >to know it's using DT or not to figure out which API to call.
> 
> That would be the best. Its easy to wrap up whats in eeprom core to
> eeprom_get_cell(dev, "cell-name") for both DT and non-dt cases, if I
> remove the nasty global name space thing.
> 
> Only thing which is limiting it is the existing bindings which are
> just phandle based. For eeprom to be more of device centric we need
> more
> generic bindings/property names like
> 
> nvrom-cell = <&abc>, <&edf>
> nvrom-cell-names = "cell1", "cell2";
> 
> Also we can have name associated to each eeprom cell which would
> help for non-dt cases. So they can just lookup by the cell name.
> 
> 
> Sacha, Are you ok with such binding?  As this can provide a single
> interface for dt and non-dt. I remember you requested for changing
> from generic properties to specific property names.

Yes, I am fine with such a binding. The same type of binding is used for
clocks and other stuff already, so it has proven good and people are
famliar with it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
