From: "Leizhen (ThunderTown)" <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question or BUG] [NUMA]: I feel puzzled at the function
 cpumask_of_node
Date: Thu, 15 Jun 2017 10:00:25 +0800
Message-ID: <5941EA39.8090501@huawei.com>
References: <5937C608.7010905@huawei.com>
 <20170608141214.GJ19866@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608141214.GJ19866-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, chenchunxiao <chenchunxiao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, x86l <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 2017/6/8 22:12, Michal Hocko wrote:
> [CC linux-api]
> 
> On Wed 07-06-17 17:23:20, Leizhen (ThunderTown) wrote:
>> When I executed numactl -H(print cpumask_of_node for each node), I got
>> different result on X86 and ARM64.  For each numa node, the former
>> only displayed online CPUs, and the latter displayed all possible
>> CPUs.  Actually, all other ARCHs is the same to ARM64.
>>
>> So, my question is: Which case(online or possible) should function
>> cpumask_of_node be? Or there is no matter about it?
> 
> Unfortunatelly the documentation is quite unclear
> What:		/sys/devices/system/node/nodeX/cpumap
> Date:		October 2002
> Contact:	Linux Memory Management list <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
> Description:
> 		The node's cpumap.
> 
> not really helpeful, is it? Semantically I _think_ printing online cpus
> makes more sense because it doesn't really make much sense to bind
> anything on offline nodes. Generic implementtion of cpumask_of_node
> indeed provides only online cpus. I haven't checked specific
> implementations of arch specific code but listing offline cpus sounds
> confusing to me.
> 
OK, thank you very much. So, how about we directly add "cpumask_and with cpu_online_mask", as below:

diff --git a/drivers/base/node.c b/drivers/base/node.c
index b10479c..199723d 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -28,12 +28,14 @@ static struct bus_type node_subsys = {
 static ssize_t node_read_cpumap(struct device *dev, bool list, char *buf)
 {
        struct node *node_dev = to_node(dev);
-   const struct cpumask *mask = cpumask_of_node(node_dev->dev.id);
+ struct cpumask mask;
+
+ cpumask_and(&mask, cpumask_of_node(node_dev->dev.id), cpu_online_mask);

        /* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
        BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));

-   return cpumap_print_to_pagebuf(list, buf, mask);
+ return cpumap_print_to_pagebuf(list, buf, &mask);
 }

 static inline ssize_t node_read_cpumask(struct device *dev,


-- 
Thanks!
BestRegards
