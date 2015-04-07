From: Matt Porter <mporter@konsulko.com>
Subject: Re: [PATCH v4 05/10] eeprom: Add bindings for simple eeprom framework
Date: Tue, 7 Apr 2015 15:46:36 -0400
Message-ID: <20150407194636.GB6662@beef>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427752679-17261-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150406133208.GH30984@beef>
 <CAL_Jsq++9pyJMLXssgyz2WRU4e7ikT_6FwzWMo1fKS82FJvEyg@mail.gmail.com>
 <20150406150442.GA26319@beef>
 <55241575.7040809@linaro.org>
 <20150407174624.GO6023@sirena.org.uk>
 <55241BF2.4050609@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55241BF2.4050609@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Rob Herring <robherring2@gmail.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sascha Hauer <s.hauer@pengutronix.de>, Stephen Boyd <sboyd@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Maxime Ripard <maxime.ripard@free-electrons.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 07, 2015 at 07:03:30PM +0100, Srinivas Kandagatla wrote:
> 
> 
> On 07/04/15 18:46, Mark Brown wrote:
> >On Tue, Apr 07, 2015 at 06:35:49PM +0100, Srinivas Kandagatla wrote:
> >>On 06/04/15 16:04, Matt Porter wrote:
> >>>On Mon, Apr 06, 2015 at 09:11:05AM -0500, Rob Herring wrote:
> >
> >>>>>The generic binding could really use a "read-only" property here as this
> >>>>>is a common hardware attribute for many nvmem devices. A serial EEPROM
> >
> >>Correct me If am wrong.
> >
> >>Regarding write protection/read-only, regmap already has provisions to
> >>support this feature. regmap would bail out with errors if any attempt to
> >>write to non-writable regions. It all depends on the data providers how they
> >>setup the regmap and the bindings for those are specific individual data
> >>providers I think.
> >
> >There is the ability to flag read/write permissions in regmap but I
> >think there's some suggestion that this should be exposed to userspace
> >so that it's easier for it to handle things rather than just writing
> >then coping with any errors.
> 
> Yes, That's possible if the data provider use the "read-only" generic
> binding like MTD partitions which the eeprom framwork could use to set the
> binary file mode appropriately.

Right, that's what Rob suggested as to how it should be exposed to
userspace. I think Mark is suggesting that it can also be done by
returning appropriately fine-grained error codes from a writeable
attribute.

Just to clarify here, I brought this up because if we only allow
the writes to fail, there's not necessarily not enough information
available to know if they failed due to a real error (perhaps write
cycles for the underlying nvmem device have been exhausted) or is
it simply that the underlying device has been hardware write protected
(such as as the write protect pin hardwired that way or it's an OTP
device). The client, whether userspace or otherwise is going to need
to know this information to make informed policy decisions.

-Matt

> "read-only" property seems to be more generic for all types of data
> providers.
> 
> I will give it a try and document this in the bindings too in next version.
> 
> --srini
> >
