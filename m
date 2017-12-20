From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 0/3] create sysfs representation of ACPI HMAT
Date: Wed, 20 Dec 2017 10:19:37 -0800
Message-ID: <20171220181937.GB12236@bombadil.infradead.org>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214130032.GK16951@dhcp22.suse.cz>
 <20171218203547.GA2366@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171218203547.GA2366-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Anaczkowski, Lukasz" <lukasz.anaczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Box, David E" <david.e.box-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kogut, Jaroslaw" <Jaroslaw.Kogut-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Koss, Marcin" <marcin.koss-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Koziej, Artur" <artur.koziej-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Lahtinen, Joonas" <joonas.lahtinen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Moore, Robert" <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Odzioba, Lukasz" <lukasz.odzioba-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Schmauss, Erik" <erik.schmauss-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Verma, Vishal L" <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Balbir Singh <bsingharora@gm>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 18, 2017 at 01:35:47PM -0700, Ross Zwisler wrote:
> What I'm hoping to do with this series is to just provide a sysfs
> representation of the HMAT so that applications can know which NUMA nodes to
> select with existing utilities like numactl.  This series does not currently
> alter any kernel behavior, it only provides a sysfs interface.
> 
> Say for example you had a system with some high bandwidth memory (HBM), and
> you wanted to use it for a specific application.  You could use the sysfs
> representation of the HMAT to figure out which memory target held your HBM.
> You could do this by looking at the local bandwidth values for the various
> memory targets, so:
> 
> 	# grep . /sys/devices/system/hmat/mem_tgt*/local_init/write_bw_MBps
> 	/sys/devices/system/hmat/mem_tgt2/local_init/write_bw_MBps:81920
> 	/sys/devices/system/hmat/mem_tgt3/local_init/write_bw_MBps:40960
> 	/sys/devices/system/hmat/mem_tgt4/local_init/write_bw_MBps:40960
> 	/sys/devices/system/hmat/mem_tgt5/local_init/write_bw_MBps:40960
> 
> and look for the one that corresponds to your HBM speed. (These numbers are
> made up, but you get the idea.)

Presumably ACPI-based platforms will not be the only ones who have the
ability to expose different bandwidth memories in the future.  I think
we need a platform-agnostic way ... right, PowerPC people?

I don't know what the right interface is, but my laptop has a set of
/sys/devices/system/memory/memoryN/ directories.  Perhaps this is the
right place to expose write_bw (etc).

> Once you know the NUMA node of your HBM, you can figure out the NUMA node of
> it's local initiator:
> 
> 	# ls -d /sys/devices/system/hmat/mem_tgt2/local_init/mem_init*
> 	/sys/devices/system/hmat/mem_tgt2/local_init/mem_init0
> 
> So, in our made-up example our HBM is located in numa node 2, and the local
> CPU for that HBM is at numa node 0.

initiator is a CPU?  I'd have expected you to expose a memory controller
abstraction rather than re-use storage terminology.
