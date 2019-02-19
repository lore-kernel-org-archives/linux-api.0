From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv6 00/10] Heterogenous memory node attributes
Date: Tue, 19 Feb 2019 10:20:07 -0700
Message-ID: <20190219172004.GD16341@localhost.localdomain>
References: <20190214171017.9362-1-keith.busch@intel.com>
 <f2add663-a9e1-86df-0afd-22ef03d3d943@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f2add663-a9e1-86df-0afd-22ef03d3d943@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 18, 2019 at 03:25:31PM +0100, Brice Goglin wrote:
> Le 14/02/2019 à 18:10, Keith Busch a écrit :
> >   Determining the cpu and memory node local relationships is quite
> >   different this time (PATCH 7/10). The local relationship to a memory
> >   target will be either *only* the node from the Initiator Proximity
> >   Domain if provided, or if it is not provided, all the nodes that have
> >   the same highest performance. Latency was chosen to take prioirty over
> >   bandwidth when ranking performance.
> 
> 
> Hello Keith
> 
> I am trying to understand what this last paragraph means.
> 
> Let's say I have a machine with DDR and NVDIMM both attached to the same
> socket, and I use Dave Hansen's kmem patchs to make the NVDIMM appear as
> "normal memory" in an additional NUMA node. Let's call node0 the DDR and
> node1 the NVDIMM kmem node.
> 
> Now user-space wants to find out which CPUs are actually close to the
> NVDIMMs. My understanding is that SRAT says that CPUs are local to the
> DDR only. Hence /sys/devices/system/node/node1/cpumap says there are no
> CPU local to the NVDIMM. And HMAT won't change this, right?

HMAT actually does change this. The relationship is in 6.2's HMAT
Address Range or 6.3's Proximity Domain Attributes, and that's
something SRAT wasn't providing.

The problem with these HMAT structures is that the CPU node is
optional. The last paragraph is saying that if that optional information
is provided, we will use that. If it is not provided, we will fallback
to performance attributes to determine what is the "local" CPU domain.
 
> Will node1 contain access0/initiators/node0 to clarify that CPUs local
> to the NVDIMM are those of node0? Even if latency from node0 to node1
> latency is higher than node0 to node0?

Exactly, yes. To expand on this, what you'd see from sysfs:

  /sys/devices/system/node/node0/access0/targets/node1 -> ../../../node1

And

  /sys/devices/system/node/node1/access0/initiators/node0 -> ../../../node0

> Another way to ask this: Is the latency/performance only used for
> distinguishing the local initiator CPUs among multiple CPU nodes
> accesing the same memory node? Or is it also used to distinguish the
> local memory target among multiple memories access by a single CPU node?

It's the first one. A single CPU domain may have multiple local targets,
but each of those targets may have different performance.

For example, you could have something like this with "normal" DDR
memory, high-bandwidth memory, and slower nvdimm:

 +------------------+    +------------------+
 | CPU Node 0       +----+ CPU Node 1       |
 | Node0 DDR Mem    |    | Node1 DDR Mem    |
 +--------+---------+    +--------+---------+
          |                       |
 +--------+---------+    +--------+---------+
 | Node2 HBMem      |    | Node3 HBMem      |
 +--------+---------+    +--------+---------+
          |                       |
 +--------+---------+    +--------+---------+
 | Node4 Slow NVMem |    | Node5 Slow NVMem |
 +------------------+    +------------------+

In the above, Initiator node0 is "local" to targets 0, 2, and 4, and
would show up in node0's access0/targets/. Each memory target node,
though, has different performance than the others that are local to the
same intiator domain.

> The Intel machine I am currently testing patches on doesn't have a HMAT
> in 1-level-memory unfortunately.

Platforms providing HMAT tables are still rare at the moment, but expect
will become more common.
