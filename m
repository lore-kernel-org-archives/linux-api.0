From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v3 0/5] Introduce MADV_COLD and MADV_PAGEOUT
Date: Mon, 1 Jul 2019 12:22:56 +0200
Message-ID: <20190701102256.GN6376@dhcp22.suse.cz>
References: <20190627115405.255259-1-minchan@kernel.org>
 <20190701073848.GB136163@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190701073848.GB136163@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Mon 01-07-19 16:38:48, Minchan Kim wrote:
> 
> Hi Folks,
> 
> Do you guys have comments? I think it would be long enough to be
> pending. If there is no further comments, I want to ask to merge.

This is definitely on my todo list for this week. But please be patient.
It's been _one_ work day since you posted this last version so I do not
think this is stalling for too long. Sure the current version is
probably not too much different from the previous but I didn't get to
review it in the depth yet. All the code duplication doesn't make it
much easier but I understand your reasoning that sharing more code is
not really straightforward.
-- 
Michal Hocko
SUSE Labs
