From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCHv6 00/10] Heterogenous memory node attributes
Date: Mon, 18 Feb 2019 15:25:31 +0100
Message-ID: <f2add663-a9e1-86df-0afd-22ef03d3d943@inria.fr>
References: <20190214171017.9362-1-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214171017.9362-1-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org


Le 14/02/2019 à 18:10, Keith Busch a écrit :
> == Changes since v5 ==
>
>   Updated HMAT parsing to account for the recently released ACPI 6.3
>   changes.
>
>   HMAT attribute calculation overflow checks.
>
>   Fixed memory leak if HMAT parse fails.
>
>   Minor change to the patch order. All the base node attributes occur
>   before HMAT usage for these new node attributes to resolve a
>   dependency on a new struct.
>
>   Reporting failures to parse HMAT or allocate structures are elevated
>   to a NOTICE level from DEBUG. Any failure will result in just one
>   print so that it is obvious something may need to be investigated
>   rather than silently fail, but also not to be too alarming either.
>
>   Determining the cpu and memory node local relationships is quite
>   different this time (PATCH 7/10). The local relationship to a memory
>   target will be either *only* the node from the Initiator Proximity
>   Domain if provided, or if it is not provided, all the nodes that have
>   the same highest performance. Latency was chosen to take prioirty over
>   bandwidth when ranking performance.


Hello Keith

I am trying to understand what this last paragraph means.

Let's say I have a machine with DDR and NVDIMM both attached to the same
socket, and I use Dave Hansen's kmem patchs to make the NVDIMM appear as
"normal memory" in an additional NUMA node. Let's call node0 the DDR and
node1 the NVDIMM kmem node.

Now user-space wants to find out which CPUs are actually close to the
NVDIMMs. My understanding is that SRAT says that CPUs are local to the
DDR only. Hence /sys/devices/system/node/node1/cpumap says there are no
CPU local to the NVDIMM. And HMAT won't change this, right?

Will node1 contain access0/initiators/node0 to clarify that CPUs local
to the NVDIMM are those of node0? Even if latency from node0 to node1
latency is higher than node0 to node0?

Another way to ask this: Is the latency/performance only used for
distinguishing the local initiator CPUs among multiple CPU nodes
accesing the same memory node? Or is it also used to distinguish the
local memory target among multiple memories access by a single CPU node?

The Intel machine I am currently testing patches on doesn't have a HMAT
in 1-level-memory unfortunately.

Thanks

Brice
