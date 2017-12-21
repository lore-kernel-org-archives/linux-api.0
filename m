From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Date: Thu, 21 Dec 2017 01:41:15 +0000
Message-ID: <AT5PR8401MB0387011EAD8858CC99548ED2AB0D0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
 <20171220181937.GB12236@bombadil.infradead.org>
 <20171220211350.GA2688@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20171220211350.GA2688@linux.intel.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>, "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Anaczkowski, Lukasz" <lukasz.anaczkowski@intel.com>, "Moore, Robert" <robert.moore@intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Schmauss, Erik" <erik.schmauss@intel.com>, Len Brown <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, Jerome Glisse <jglisse@redhat.com>, "devel@acpica.org" <devel@acpica.org>, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, linux-mm@kvack.
List-Id: linux-api@vger.kernel.org



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Ross Zwisler
...
> 
> On Wed, Dec 20, 2017 at 10:19:37AM -0800, Matthew Wilcox wrote:
...
> > initiator is a CPU?  I'd have expected you to expose a memory controller
> > abstraction rather than re-use storage terminology.
> 
> Yea, I agree that at first blush it seems weird.  It turns out that
> looking at it in sort of a storage initiator/target way is beneficial,
> though, because it allows us to cut down on the number of data values
> we need to represent.
> 
> For example the SLIT, which doesn't differentiate between initiator and
> target proximity domains (and thus nodes) always represents a system
> with N proximity domains using a NxN distance table.  This makes sense
> if every node contains both CPUs and memory.
> 
> With the introduction of the HMAT, though, we can have memory-only
> initiator nodes and we can explicitly associate them with their local 
> CPU.  This is necessary so that we can separate memory with different
> performance characteristics (HBM vs normal memory vs persistent memory,
> for example) that are all attached to the same CPU.
> 
> So, say we now have a system with 4 CPUs, and each of those CPUs has 3
> different types of memory attached to it.  We now have 16 total proximity
> domains, 4 CPU and 12 memory.

The CPU cores that make up a node can have performance restrictions of
their own; for example, they might max out at 10 GB/s even though the
memory controller supports 120 GB/s (meaning you need to use 12 cores
on the node to fully exercise memory).  It'd be helpful to report this,
so software can decide how many cores to use for bandwidth-intensive work.

> If we represent this with the SLIT we end up with a 16 X 16 distance table
> (256 entries), most of which don't matter because they are memory-to-
> memory distances which don't make sense.
> 
> In the HMAT, though, we separate out the initiators and the targets and
> put them into separate lists.  (See 5.2.27.4 System Locality Latency and
> Bandwidth Information Structure in ACPI 6.2 for details.)  So, this same
> config in the HMAT only has 4*12=48 performance values of each type, all
> of which convey meaningful information.
> 
> The HMAT indeed even uses the storage "initiator" and "target"
> terminology. :)

Centralized DMA engines (e.g., as used by the "DMA based blk-mq pmem
driver") have performance differences too.  A CPU might include
CPU cores that reach 10 GB/s, DMA engines that reach 60 GB/s, and
memory controllers that reach 120 GB/s.  I guess these would be
represented as extra initiators on the node?


---
Robert Elliott, HPE Persistent Memory



