From: Andreas Dannenberg <dannenberg@ti.com>
Subject: Re: [PATCH v7 06/15] power: bq24257: Add basic support for
 bq24250/bq24251
Date: Mon, 28 Sep 2015 08:38:10 -0500
Message-ID: <20150928133810.GB12676@borg>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-7-git-send-email-dannenberg@ti.com>
 <56093D50.5010604@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56093D50.5010604@samsung.com>
Sender: linux-pm-owner@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 10:14:56PM +0900, Krzysztof Kozlowski wrote:
> W dniu 26.09.2015 o 00:54, Andreas Dannenberg pisze:
> > This patch adds basic support for bq24250 and bq24251 which are very
> > similar to the bq24257 the driver was originally written for. Basic
> > support means the ability to select a device through Kconfig, DT and
> > ACPI, an instance variable allowing to check which chip is active, and
> > the reporting back of the selected device through the model_name power
> > supply sysfs property.
> > 
> > This patch by itself is not sufficient to actually use those two added
> > devices in a real-world setting due to some feature differences which
> > are addressed by other patches in this series.
> > 
> > Signed-off-by: Andreas Dannenberg <dannenberg@ti.com>
> 
> For the second time (after 1st patch changing DT documentation) I am
> confused - my reviewed-by was not added.
> 
> I assume it got lost due to misunderstanding or something else but
> anyway I won't insist. If you want it, just let me know.

Hi Krzysztof, thanks for the reviewed-by's. Yes there was a
misunderstanding. Will make sure to carry them forward from now on.

Regards,

--
Andreas Dannenberg
Texas Instruments Inc
