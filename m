From: Sanchayan Maity <maitysanchayan@gmail.com>
Subject: Re: [PATCH v6 0/9] Add simple NVMEM Framework via regmap.
Date: Wed, 24 Jun 2015 11:24:29 +0530
Message-ID: <20150624055429.GC11753@Sanchayan-Arch.toradex.int>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
 <235181230.251177.1435088854197.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <235181230.251177.1435088854197.JavaMail.open-xchange@oxbsltgw00.schlund.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Stefan Wahren <stefan.wahren@i2se.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, arnd@arndb.de, linux-api@vger.kernel.org, s.hauer@pengutronix.de, sboyd@codeaurora.org, linux-kernel@vger.kernel.org, pantelis.antoniou@konsulko.com, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, Kumar Gala <galak@codeaurora.org>, mporter@konsulko.com, Maxime Ripard <maxime.ripard@free-electrons.com>, linux-arm-msm@vger.kernel.org, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org

Hello,

On 15-06-23 21:47:34, Stefan Wahren wrote:
> Hi Srinivas,
> 
> > Srinivas Kandagatla <srinivas.kandagatla@linaro.org> hat am 23. Juni 2015 um
> > 01:07 geschrieben:
> >
> >
> > [...]
> >
> > Device Tree:
> >
> > /* Provider */
> > qfprom: qfprom@00700000 {
> > ...
> >
> > /* Data cells */
> > tsens_calibration: calib@404 {
> > reg = <0x404 0x10>;
> > };
> >
> > tsens_calibration_bckp: calib_bckp@504 {
> > reg = <0x504 0x11>;
> > bit-offset = 6;
> > nbits = 128;
> > };
> >
> > pvs_version: pvs-version@6 {
> > reg = <0x6 0x2>
> > bit-offset = 7;
> > nbits = 2;
> > };
> >
> > speed_bin: speed-bin@c{
> > reg = <0xc 0x1>;
> > bit-offset = 2;
> > nbits = 3;
> >
> > };
> > ...
> > };
> >
> > userspace interface: binary file in /sys/class/nvmem/*/nvmem
> >
> > ex:
> > hexdump /sys/class/nvmem/qfprom0/nvmem
> >
> > 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> > *
> > 00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
> > 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> > ...
> > *
> > 0001000
> >
> 
> i want to port OCOTP driver for MXS, which hasn't MMIO. From my understanding
> hexdump would readout the complete register range defined in provider DT node.
> 
> How can i achieve that hexdump only reads the data area within the register
> range?

I also had a similar question in my mind.

- Sanchayan.
