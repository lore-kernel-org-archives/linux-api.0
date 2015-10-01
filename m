From: Andreas Dannenberg <dannenberg@ti.com>
Subject: Re: [PATCH v8 00/14] power: bq24257: Add support for bq24250/bq24251
Date: Thu, 1 Oct 2015 11:53:48 -0500
Message-ID: <20151001165348.GA31342@beast>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
 <20151001025847.GA12283@earth>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151001025847.GA12283@earth>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 01, 2015 at 04:58:47AM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Mon, Sep 28, 2015 at 05:33:48PM -0500, Andreas Dannenberg wrote:
> > This patch series extends the driver to also support bq24250/bq24251.
> > 
> > The bq24250/251/257 devices have a very similar feature set and are
> > virtually identical from a control register point of view so it made
> > sense to extend the existing driver rather than submitting a new driver.
> > In addition to the new device support the driver is also extended to
> > allow access to some device features previously hidden. Basic and
> > potentially dangerous charger config parameters affecting the actual
> > charging of the Li-Ion battery are only configurable through firmware
> > rather than sysfs properties. However some newly introduced properties
> > are exposed through sysfs properties as access to them may be desired
> > from userspace. For example, it is now possible to manually configure
> > the maximum current drawn from the input source to accommodate different
> > chargers (0.5A, 1.5A, 2.0A and so on) based on system knowledge a
> > userspace application may have rather than rely on the auto-detection
> > mechanism that may not work in all possible scenarios.
> 
> Thanks, I queued all remaining patches except for

Sebastian, I just pulled your tree and re-ran some of my tests. Looks
like everything is still working as it should. Thanks again for your
help reviewing. Same goes for Krzysztof and Laurentiu -- thanks for
your time and feedback too.

> >   power: bq24257: Add platform data based initialization
> 
> I'm still not convinced, that it should be added without any
> consumer in the mainline kernel.

Well I tried to make my case (giving access to the largest audience
possible). If you don't want to include it that's fine. I guess it can
always get added if a specific need arises... For future reference here
is the link to the latest version of that patch:

http://marc.info/?l=linux-pm&m=144347973708093&w=2

--
Andreas Dannenberg
Texas Instruments Inc

