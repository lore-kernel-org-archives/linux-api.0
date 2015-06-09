From: Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 0/4] idle memory tracking
Date: Tue, 09 Jun 2015 13:56:19 +0530
Message-ID: <5576A32B.40008@linux.vnet.ibm.com>
References: <cover.1431437088.git.vdavydov@parallels.com> <CAC4Lta1isOa+OK7mqCDjL+aV1j=mXBA8p5xnrMEMj+jy6dRMaw@mail.gmail.com> <20150608123535.d82543cedbb9060612a10113@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150608123535.d82543cedbb9060612a10113-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/09/2015 01:05 AM, Andrew Morton wrote:
> On Sun, 7 Jun 2015 11:41:15 +0530 Raghavendra KT <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>
>> On Tue, May 12, 2015 at 7:04 PM, Vladimir Davydov
>> <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>>> Hi,
>>>
>>> This patch set introduces a new user API for tracking user memory pages
>>> that have not been used for a given period of time. The purpose of this
>>> is to provide the userspace with the means of tracking a workload's
>>> working set, i.e. the set of pages that are actively used by the
>>> workload. Knowing the working set size can be useful for partitioning
>>> the system more efficiently, e.g. by tuning memory cgroup limits
>>> appropriately, or for job placement within a compute cluster.
>>>
>>> ---- USE CASES ----
>>>
>>> The unified cgroup hierarchy has memory.low and memory.high knobs, which
>>> are defined as the low and high boundaries for the workload working set
>>> size. However, the working set size of a workload may be unknown or
>>> change in time. With this patch set, one can periodically estimate the
>>> amount of memory unused by each cgroup and tune their memory.low and
>>> memory.high parameters accordingly, therefore optimizing the overall
>>> memory utilization.
>>>
>>
>> Hi Vladimir,
>>
>> Thanks for the patches, I was able test how the series is helpful to determine
>> docker container workingset / idlemem with these patches. (tested on ppc64le
>> after porting to a distro kernel).
>
> And what were the results of your testing?  The more details the
> better, please.
>
>

Hi Andrew,
This is what I had done in my experiment (Theoretical):
1) created a docker container
2)
Ran the python script (example in first patch) provided by Vladimir
to get idle memory in the docker container. This would further help
in analyzing what is the rss docker container would ideally use
and hence we could set the memory limit for the container and we will
know how much we should ideally scale without degrading the performance 
of other containers.

# ~/raghu/idlemmetrack/idlememtrack.py
Setting the idle flag for each page...
Wait until the workload accesses its working set, then press Enter
Counting idle pages..
/sys/fs/cgroup/memory: 9764 KB
[...]
/sys/fs/cgroup/memory/system.slice/docker-[...].scope: 224 K
....

I understand that you might probably want how did the scaling experiment 
with memory limit tuning went after that, but I have not got
that data yet.. :(..
