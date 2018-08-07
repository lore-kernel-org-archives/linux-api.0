From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] proc: add percpu populated pages count to meminfo
Date: Tue, 7 Aug 2018 11:51:41 -0700
Message-ID: <20180807185141.GC3978217@devbig004.ftw2.facebook.com>
References: <20180807184723.74919-1-dennisszhou@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807184723.74919-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, kernel-team@fb.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello, Dennis.

On Tue, Aug 07, 2018 at 11:47:23AM -0700, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> Currently, percpu memory only exposes allocation and utilization
> information via debugfs. This more or less is only really useful for
> understanding the fragmentation and allocation information at a
> per-chunk level with a few global counters. This is also gated behind a
> config. BPF and cgroup, for example, have seen an increase use causing
> increased use of percpu memory. Let's make it easier for someone to
> identify how much memory is being used.
> 
> This patch adds the "Percpu" stat to meminfo to more easily look up how
> much percpu memory is in use. This number includes the cost for all
> allocated backing pages and not just isnight at the a unit, per chunk
> level. Metadata is excluded. I think excluding metadata is fair because
> the backing memory scales with the numbere of cpus and can quickly
> outweigh the metadata. It also makes this calculation light.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Andrew, if this looks good, can you please route this?

Thanks.

-- 
tejun
