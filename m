From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 1/3] mm, proc: be more verbose about unstable VMA
 flags in /proc/<pid>/smaps
Date: Tue, 20 Nov 2018 12:41:36 +0100
Message-ID: <20181120114136.GE22247@dhcp22.suse.cz>
References: <20181120103515.25280-1-mhocko@kernel.org>
 <20181120103515.25280-2-mhocko@kernel.org>
 <20181120105135.GF8842@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181120105135.GF8842@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Rientjes <rientjes@google.com>
List-Id: linux-api@vger.kernel.org

On Tue 20-11-18 11:51:35, Jan Kara wrote:
> Honestly, it just shows that no amount of documentation is going to stop
> userspace from abusing API that's exposing too much if there's no better
> alternative.

Yeah, I agree. And we should never expose such a low level stuff in the
first place. But, well, this ship has already sailed...

> But this is a good clarification regardless. So feel free to
> add:
> 
> Acked-by: Jan Kara <jack@suse.cz>

Thanks!
-- 
Michal Hocko
SUSE Labs
