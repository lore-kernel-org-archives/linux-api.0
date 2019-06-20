From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 4/5] mm: introduce MADV_PAGEOUT
Date: Thu, 20 Jun 2019 12:55:15 +0200
Message-ID: <20190620105515.GE12083@dhcp22.suse.cz>
References: <20190610111252.239156-1-minchan@kernel.org>
 <20190610111252.239156-5-minchan@kernel.org>
 <20190619132450.GQ2968@dhcp22.suse.cz>
 <20190620041620.GB105727@google.com>
 <20190620070444.GB12083@dhcp22.suse.cz>
 <20190620084040.GD105727@google.com>
 <20190620092209.GD12083@dhcp22.suse.cz>
 <20190620103215.GF105727@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190620103215.GF105727@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com
List-Id: linux-api@vger.kernel.org

On Thu 20-06-19 19:32:15, Minchan Kim wrote:
[...]
> Then, okay, I will add can_do_mincore similar check for the MADV_PAGEOUT syscall
> if others have different ideas.

Great that we are on the same page. We can simply skip over those pages.
-- 
Michal Hocko
SUSE Labs
