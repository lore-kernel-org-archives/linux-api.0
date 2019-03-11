From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv7 07/10] acpi/hmat: Register processor domain to its
 memory
Date: Mon, 11 Mar 2019 13:52:44 -0600
Message-ID: <20190311195244.GF10411@localhost.localdomain>
References: <20190227225038.20438-1-keith.busch@intel.com>
 <20190227225038.20438-8-keith.busch@intel.com>
 <20190311112041.000015ba@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190311112041.000015ba@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Keith Busch <keith.busch@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 11, 2019 at 11:20:41AM +0000, Jonathan Cameron wrote:
> On Wed, 27 Feb 2019 15:50:35 -0700
> Keith Busch <keith.busch@intel.com> wrote:
> > +static __init void hmat_register_target_initiators(struct memory_target *target)
> > +{
> > +	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
> > +	struct memory_initiator *initiator;
> > +	unsigned int mem_nid, cpu_nid;
> > +	struct memory_locality *loc = NULL;
> > +	u32 best = 0;
> > +	int i;
> > +
> (upshot of the below is I removed this test :)
> > +	if (target->processor_pxm == PXM_INVAL)
> > +		return;
> 
> This doesn't look right.  We check first if it is invalid  and return....

Yeah, Brice mentioned the same bug. I must have been mistakenly
reintroduced that when I rebased to linux-next. I also have a test case
for this and recall it was working at one point. I've got it fixed up
now for the next revision.
