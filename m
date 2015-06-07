From: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 0/4] idle memory tracking
Date: Sun, 7 Jun 2015 11:41:15 +0530
Message-ID: <CAC4Lta1isOa+OK7mqCDjL+aV1j=mXBA8p5xnrMEMj+jy6dRMaw@mail.gmail.com>
References: <cover.1431437088.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1431437088.git.vdavydov@parallels.com>
Sender: linux-doc-owner@vger.kernel.org
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 7:04 PM, Vladimir Davydov
<vdavydov@parallels.com> wrote:
> Hi,
>
> This patch set introduces a new user API for tracking user memory pages
> that have not been used for a given period of time. The purpose of this
> is to provide the userspace with the means of tracking a workload's
> working set, i.e. the set of pages that are actively used by the
> workload. Knowing the working set size can be useful for partitioning
> the system more efficiently, e.g. by tuning memory cgroup limits
> appropriately, or for job placement within a compute cluster.
>
> ---- USE CASES ----
>
> The unified cgroup hierarchy has memory.low and memory.high knobs, which
> are defined as the low and high boundaries for the workload working set
> size. However, the working set size of a workload may be unknown or
> change in time. With this patch set, one can periodically estimate the
> amount of memory unused by each cgroup and tune their memory.low and
> memory.high parameters accordingly, therefore optimizing the overall
> memory utilization.
>

Hi Vladimir,

Thanks for the patches, I was able test how the series is helpful to determine
docker container workingset / idlemem with these patches. (tested on ppc64le
after porting to a distro kernel).
