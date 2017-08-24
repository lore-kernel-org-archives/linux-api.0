From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/1] mm: only dispaly online cpus of the numa node
Date: Thu, 24 Aug 2017 10:32:26 +0200
Message-ID: <20170824083225.GA5943@dhcp22.suse.cz>
References: <1497962608-12756-1-git-send-email-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1497962608-12756-1-git-send-email-thunder.leizhen@huawei.com>
Sender: owner-linux-mm@kvack.org
To: Zhen Lei <thunder.leizhen@huawei.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm <linux-mm@kvack.org>, Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>, Tianhong Ding <dingtianhong@huawei.com>, Hanjun Guo <guohanjun@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-api@vger.kernel.org

It seems this has slipped through cracks. Let's CC arm64 guys

On Tue 20-06-17 20:43:28, Zhen Lei wrote:
> When I executed numactl -H(which read /sys/devices/system/node/nodeX/cpumap
> and display cpumask_of_node for each node), but I got different result on
> X86 and arm64. For each numa node, the former only displayed online CPUs,
> and the latter displayed all possible CPUs. Unfortunately, both Linux
> documentation and numactl manual have not described it clear.
> 
> I sent a mail to ask for help, and Michal Hocko <mhocko@kernel.org> replied
> that he preferred to print online cpus because it doesn't really make much
> sense to bind anything on offline nodes.

Yes printing offline CPUs is just confusing and more so when the
behavior is not consistent over architectures. I believe that x86
behavior is the more appropriate one because it is more logical to dump
the NUMA topology and use it for affinity setting than adding one
additional step to check the cpu state to achieve the same.

It is true that the online/offline state might change at any time so the
above might be tricky on its own but if we should at least make the
behavior consistent.

> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  drivers/base/node.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 5548f96..d5e7ce7 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -28,12 +28,14 @@ static struct bus_type node_subsys = {
>  static ssize_t node_read_cpumap(struct device *dev, bool list, char *buf)
>  {
>  	struct node *node_dev = to_node(dev);
> -	const struct cpumask *mask = cpumask_of_node(node_dev->dev.id);
> +	struct cpumask mask;
> +
> +	cpumask_and(&mask, cpumask_of_node(node_dev->dev.id), cpu_online_mask);
> 
>  	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
>  	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
> 
> -	return cpumap_print_to_pagebuf(list, buf, mask);
> +	return cpumap_print_to_pagebuf(list, buf, &mask);
>  }
> 
>  static inline ssize_t node_read_cpumask(struct device *dev,
> --
> 2.5.0
> 
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
