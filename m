From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 00/10] Heterogenous memory node attributes
Date: Fri, 15 Mar 2019 11:50:57 -0600
Message-ID: <20190315175049.GA18389@localhost.localdomain>
References: <20190311205606.11228-1-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190311205606.11228-1-keith.busch@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, Brice Goglin <Brice.Goglin@inria.fr>
List-Id: linux-api@vger.kernel.org

Hi Greg,

Just wanted to check with you on how we may proceed with this series.
The main feature is exporting new sysfs attributes through driver core,
so I think it makes most sense to go through you unless you'd prefer
this go through a different route.

The proposed interface has been pretty stable for a while now, and we've
received reviews, acks and tests on all patches. Please let me know if
there is anything else you'd like to see from this series, or if you
just need more time to get around to this.

Thanks,
Keith
