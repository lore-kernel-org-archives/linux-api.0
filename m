From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCHv6 06/10] node: Add memory-side caching attributes
Date: Fri, 22 Feb 2019 11:22:12 +0100
Message-ID: <16221be9-2f60-3a39-fd6c-5299cd94dc02@inria.fr>
References: <20190214171017.9362-1-keith.busch@intel.com>
 <20190214171017.9362-7-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214171017.9362-7-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

Le 14/02/2019 à 18:10, Keith Busch a écrit :
> System memory may have caches to help improve access speed to frequently
> requested address ranges. While the system provided cache is transparent
> to the software accessing these memory ranges, applications can optimize
> their own access based on cache attributes.
>
> Provide a new API for the kernel to register these memory-side caches
> under the memory node that provides it.
>
> The new sysfs representation is modeled from the existing cpu cacheinfo
> attributes, as seen from /sys/devices/system/cpu/<cpu>/cache/.  Unlike CPU
> cacheinfo though, the node cache level is reported from the view of the
> memory. A higher level number is nearer to the CPU, while lower levels
> are closer to the last level memory.
>
> The exported attributes are the cache size, the line size, associativity,
> and write back policy, and add the attributes for the system memory
> caches to sysfs stable documentation.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  Documentation/ABI/stable/sysfs-devices-node |  35 +++++++
>  drivers/base/node.c                         | 151 ++++++++++++++++++++++++++++
>  include/linux/node.h                        |  34 +++++++
>  3 files changed, 220 insertions(+)
>
> diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
> index cd64b62152ba..5c88cb9ca14e 100644
> --- a/Documentation/ABI/stable/sysfs-devices-node
> +++ b/Documentation/ABI/stable/sysfs-devices-node
> @@ -143,3 +143,38 @@ Contact:	Keith Busch <keith.busch@intel.com>
>  Description:
>  		This node's write latency in nanoseconds when access
>  		from nodes found in this class's linked initiators.
> +
> +What:		/sys/devices/system/node/nodeX/memory_side_cache/indexY/
> +Date:		December 2018
> +Contact:	Keith Busch <keith.busch@intel.com>
> +Description:
> +		The directory containing attributes for the memory-side cache
> +		level 'Y'.
> +
> +		The caches associativity: 0 for direct mapped, non-zero if
> +What:		/sys/devices/system/node/nodeX/memory_side_cache/indexY/associativity
> +Date:		December 2018
> +Contact:	Keith Busch <keith.busch@intel.com>
> +Description:
> +		The caches associativity: 0 for direct mapped, non-zero if
> +		indexed.


Should we rename "associativity" into "indexing" or something else?

When I see "associativity" that contains 0, I tend to interpret this as
the associativity value itself, which would mean fully-associative here
(as in CPU-side cache "ways_of_associativity" attribute), while actually
0 means direct-mapped (ie 1-associative) with yout semantics.

Brice
