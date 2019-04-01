From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv8 07/10] acpi/hmat: Register processor domain to its
 memory
Date: Sun, 31 Mar 2019 23:00:16 -0600
Message-ID: <20190401050016.GA16792@localhost.localdomain>
References: <20190311205606.11228-1-keith.busch@intel.com>
 <20190311205606.11228-8-keith.busch@intel.com>
 <CAPcyv4j5bLiUtmjdnjt7KNOtNm4sRHWp=5T3m1bWD=U1zBXeqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4j5bLiUtmjdnjt7KNOtNm4sRHWp=5T3m1bWD=U1zBXeqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Keith Busch <keith.busch@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, Brice Goglin <Brice.Goglin@inria.fr>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 29, 2019 at 02:15:03PM -0700, Dan Williams wrote:
> On Mon, Mar 11, 2019 at 1:55 PM Keith Busch <keith.busch@intel.com> wrote:
> > +static __init struct memory_target *find_mem_target(unsigned int mem_pxm)
> > +{
> > +       struct memory_target *target;
> > +
> > +       list_for_each_entry(target, &targets, node)
> > +               if (target->memory_pxm == mem_pxm)
> > +                       return target;
> > +       return NULL;
> 
> The above implementation assumes that every SRAT entry has a unique
> @mem_pxm. I don't think that's valid if the memory map is sparse,
> right?

Oh, we don't really care if multiple entries report the same PXM. We do
assume there may be multiple entires with the same PXM and have tested
this, but we're just allocating one memory target per unique memory
PXM and consider multiple entires comprise the same memory target. That
is okay if since we only need to identify unique PXMs and have no use
for the adderss ranges that make up that target, which is the case
for this series. I see you have a future use that has address ranges
considerations, so separate targets for sparse ranges can definitely
be added.
