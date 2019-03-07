From: Brice Goglin <Brice.Goglin@inria.fr>
Subject: Re: [PATCHv6 07/10] acpi/hmat: Register processor domain to its
 memory
Date: Thu, 7 Mar 2019 12:49:15 +0100
Message-ID: <8fb27d2c-2165-7029-6ea1-94fc379b3be7@inria.fr>
References: <20190214171017.9362-1-keith.busch@intel.com>
 <20190214171017.9362-8-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190214171017.9362-8-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rafael Wysocki <rafael@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-api@vger.kernel.org

Le 14/02/2019 à 18:10, Keith Busch a écrit :
> If the HMAT Subsystem Address Range provides a valid processor proximity
> domain for a memory domain, or a processor domain matches the performance
> access of the valid processor proximity domain, register the memory
> target with that initiator so this relationship will be visible under
> the node's sysfs directory.
>
> By registering only the best performing relationships, this provides the
> most useful information applications may want to know when considering
> which CPU they should run on for a given memory node, or which memory
> node they should allocate memory from for a given CPU.
>
> Since HMAT requires valid address ranges have an equivalent SRAT entry,
> verify each memory target satisfies this requirement.
>
> Signed-off-by: Keith Busch <keith.busch@intel.com>

[...]

> +static __init struct memory_initiator *find_mem_initiator(unsigned int cpu_pxm)
> +{
> +	struct memory_initiator *intitator;
> +
> +	list_for_each_entry(intitator, &initiators, node)
> +		if (intitator->processor_pxm == cpu_pxm)
> +			return intitator;
> +	return NULL;
> +}

Typo intitator -> initiator

> +static __init void alloc_memory_initiator(unsigned int cpu_pxm)
> +{
> +	struct memory_initiator *intitator;
> +
> +	if (pxm_to_node(cpu_pxm) == NUMA_NO_NODE)
> +		return;
> +
> +	intitator = find_mem_initiator(cpu_pxm);
> +	if (intitator)
> +		return;
> +
> +	intitator = kzalloc(sizeof(*intitator), GFP_KERNEL);
> +	if (!intitator)
> +		return;
> +
> +	intitator->processor_pxm = cpu_pxm;
> +	list_add_tail(&intitator->node, &initiators);
> +}

Same typo


> +static __init void hmat_register_target_initiators(struct memory_target *target)
> +{
> +	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
> +	struct memory_initiator *initiator;
> +	unsigned int mem_nid, cpu_nid;
> +	struct memory_locality *loc = NULL;
> +	u32 best = 0;
> +	int i;
> +
> +	if (target->processor_pxm == PXM_INVAL)
> +		return;


This test above looks wrong to me. First, it means that either you
return from here, or from the next branch below, hence the loop that
looks for best performance is dead code. Secondly, it means that memory
targets without a PXM never get an initiator.

I verified that removing this test makes things look better on my HMAT
tests.


> +	mem_nid = pxm_to_node(target->memory_pxm);
> +
> +	/*
> +	 * If the Address Range Structure provides a local processor pxm, link
> +	 * only that one. Otherwise, find the best performance attribtes and
> +	 * register all initiators that match.
> +	 */
> +	if (target->processor_pxm != PXM_INVAL) {
> +		cpu_nid = pxm_to_node(target->processor_pxm);
> +		register_memory_node_under_compute_node(mem_nid, cpu_nid, 0);
> +		return;
> +	}


This seems to contradict your first paragraph in the header where you say

"or a processor domain matches the performance access of the valid processor proximity domain".

By returning here, you're only keeping the the local PXM and ignoring
other initiators that may have the same performance.

I am testing a HMAT where one memory target has same performance to two
processor proxdomains. If no processor proxdomain is set in the HMAT for
this target, I get two initiators as expected. If proxdomain is
explicitly set in the HMAT, I get only that one as initiator.

Brice
