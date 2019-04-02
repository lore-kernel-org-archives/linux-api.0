From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv8 00/10] Heterogenous memory node attributes
Date: Tue, 2 Apr 2019 16:56:28 +0200
Message-ID: <20190402145628.GA16110@kroah.com>
References: <20190311205606.11228-1-keith.busch@intel.com>
 <20190315175049.GA18389@localhost.localdomain>
 <20190316030407.GA1607@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190316030407.GA1607@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <keith.busch@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, Brice Goglin <Brice.Goglin@inria.fr>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 15, 2019 at 08:04:07PM -0700, Greg Kroah-Hartman wrote:
> On Fri, Mar 15, 2019 at 11:50:57AM -0600, Keith Busch wrote:
> > Hi Greg,
> > 
> > Just wanted to check with you on how we may proceed with this series.
> > The main feature is exporting new sysfs attributes through driver core,
> > so I think it makes most sense to go through you unless you'd prefer
> > this go through a different route.
> > 
> > The proposed interface has been pretty stable for a while now, and we've
> > received reviews, acks and tests on all patches. Please let me know if
> > there is anything else you'd like to see from this series, or if you
> > just need more time to get around to this.
> 
> I can't do anything with patches until after -rc1 is out, sorry.  Once
> that happens I'll work to dig through my pending queue and will review
> these then.

Sorry for the delay, all now queued up, thanks!

greg k-h
