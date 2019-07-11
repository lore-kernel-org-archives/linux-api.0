From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 3/4] mm: account nr_isolated_xxx in
 [isolate|putback]_lru_page
Date: Thu, 11 Jul 2019 14:07:27 -0400
Message-ID: <20190711180727.GC20341@cmpxchg.org>
References: <20190711012528.176050-1-minchan@kernel.org>
 <20190711012528.176050-4-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190711012528.176050-4-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 11, 2019 at 10:25:27AM +0900, Minchan Kim wrote:
> The isolate counting is pecpu counter so it would be not huge gain
> to work them by batch. Rather than complicating to make them batch,
> let's make it more stright-foward via adding the counting logic
> into [isolate|putback]_lru_page API.
> 
> * v1
>  * fix accounting bug - Hillf
> 
> Link: http://lkml.kernel.org/r/20190531165927.GA20067@cmpxchg.org
> Acked-by: Michal Hocko <mhocko@suse.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

This is tricky to review, but fwiw it looks correct to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
