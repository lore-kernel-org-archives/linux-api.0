From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [Question or BUG] [NUMA]: I feel puzzled at the function
 cpumask_of_node
Date: Thu, 8 Jun 2017 16:12:15 +0200
Message-ID: <20170608141214.GJ19866@dhcp22.suse.cz>
References: <5937C608.7010905@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <5937C608.7010905@huawei.com>
Sender: owner-linux-mm@kvack.org
To: "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, chenchunxiao <chenchunxiao@huawei.com>, x86l <x86@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[CC linux-api]

On Wed 07-06-17 17:23:20, Leizhen (ThunderTown) wrote:
> When I executed numactl -H(print cpumask_of_node for each node), I got
> different result on X86 and ARM64.  For each numa node, the former
> only displayed online CPUs, and the latter displayed all possible
> CPUs.  Actually, all other ARCHs is the same to ARM64.
> 
> So, my question is: Which case(online or possible) should function
> cpumask_of_node be? Or there is no matter about it?

Unfortunatelly the documentation is quite unclear
What:		/sys/devices/system/node/nodeX/cpumap
Date:		October 2002
Contact:	Linux Memory Management list <linux-mm@kvack.org>
Description:
		The node's cpumap.

not really helpeful, is it? Semantically I _think_ printing online cpus
makes more sense because it doesn't really make much sense to bind
anything on offline nodes. Generic implementtion of cpumask_of_node
indeed provides only online cpus. I haven't checked specific
implementations of arch specific code but listing offline cpus sounds
confusing to me.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
