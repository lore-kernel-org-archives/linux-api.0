From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Mon, 10 Aug 2015 13:24:38 +0200 (CEST)
Message-ID: <997560650.82109.1439205878609.JavaMail.open-xchange@oxbsltgw00.schlund.de>
References: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org> <1438693367.3793.29.camel@pengutronix.de> <20150809151916.GF14271@lunn.ch> <55C87EEF.6020609@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55C87EEF.6020609@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Cc: wxt@rock-chips.com, linux-api@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, sboyd@codeaurora.org, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, khilman@kernel.org, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, mporter@konsulko.com, pantelis.antoniou@konsulko.com, devicetree@vger.kernel.org, Mark Brown <broonie@kernel.org>, maitysanchayan@gmail.com, p.zabel@pengutronix.de
List-Id: linux-api@vger.kernel.org

Hi Srinivas,
hi Andrew,

[add Sanchayan and Philipp]

> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> hat am 10. August 2015 um
> 12:37 geschrieben:
>
>
> Hi Andrew,
>
> On 09/08/15 16:19, Andrew Lunn wrote:
> > Hi Srinivas
> >
> > The AT24 eeprom driver contains the comment:
> >
> > /*
> > * Export the EEPROM bytes through sysfs, since that's convenient.
> > * By default, only root should see the data (maybe passwords etc)
> > */
> >
> > and as you would expect from this:
> >
> > # ls -l
> > ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/eeprom
> > -rw------- 1 root root 512 Aug 9 10:16
> > ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/eeprom
> >
> > The AT25 and the MAX6875 driver are the same.
> >
> > However nvmem has different defaults:
> >
> > # ls -l
> > ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/0-00500/nvmem
> > -rw-r--r-- 1 root root 0 Aug 9 10:16
> > ./devices/platform/soc/soc:aips-bus@40000000/40066000.i2c/i2c-0/0-0050/0-00500/nvmem
> >
> Yes, nvmem by default sets the read permission for everyone S_IRUGO.
> Which was the most common use case.

i can only speak for mxs-ocotp, but root-only access is sufficient.

>
> > Has this been considered and discussed?
> Thanks for bringing this up, No, we did not discuss this explicitly, but
> it should not be an issue to accommodate this. Provider still have
> flexibility to configure such things.

IMHO it would better the default settings of the framework would be compatible
and same restrictive as the eeprom drivers.

In case a provider needs more privileges, it should be his job.

>
> As a first patchset we wanted to keep the framework simple and add
> features as we move on.

That's true, but it's an ABI too. So changing default settings soon is better.

Regards
Stefan

>
> Thanks,
> srini
> >
> > Thanks
> > Andrew
> >
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
