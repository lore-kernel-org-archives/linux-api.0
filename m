From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC PATCH 3/3] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Fri, 23 Nov 2018 16:49:04 +0100
Message-ID: <d07d9742-e7dc-0fe7-c4be-3bd9a60fde98@suse.cz>
References: <20181120103515.25280-1-mhocko@kernel.org>
 <20181120103515.25280-4-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181120103515.25280-4-mhocko@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

On 11/20/18 11:35 AM, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> David Rientjes has reported that 1860033237d4 ("mm: make
> PR_SET_THP_DISABLE immediately active") has changed the way how
> we report THPable VMAs to the userspace. Their monitoring tool is
> triggering false alarms on PR_SET_THP_DISABLE tasks because it considers
> an insufficient THP usage as a memory fragmentation resp. memory
> pressure issue.
> 
> Before the said commit each newly created VMA inherited VM_NOHUGEPAGE
> flag and that got exposed to the userspace via /proc/<pid>/smaps file.
> This implementation had its downsides as explained in the commit message
> but it is true that the userspace doesn't have any means to query for
> the process wide THP enabled/disabled status.
> 
> PR_SET_THP_DISABLE is a process wide flag so it makes a lot of sense
> to export in the process wide context rather than per-vma. Introduce

Agreed.

> a new field to /proc/<pid>/status which export this status.  If
> PR_SET_THP_DISABLE is used then it reports false same as when the THP is
> not compiled in. It doesn't consider the global THP status because we
> already export that information via sysfs
> 
> Fixes: 1860033237d4 ("mm: make PR_SET_THP_DISABLE immediately active")
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>
