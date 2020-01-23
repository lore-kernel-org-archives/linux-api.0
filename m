From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Thu, 23 Jan 2020 08:29:04 +0100
Message-ID: <20200123072904.ludphxkxseyg2qli@butterfly.localdomain>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <20200117155837.bowyjpndfiym6cgs@box>
 <20200117173239.GB140922@google.com>
 <20200117212653.7uftw3lk35oykkmb@box>
 <20200121181113.GE140922@google.com>
 <20200122104424.7gvrfivymjvdous4@butterfly.localdomain>
 <20200123014316.GB249784@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200123014316.GB249784@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, ktkhai@virtuozzo.com, christian.brauner@ubuntu.com, sjpark@amazon.de
List-Id: linux-api@vger.kernel.org

On Wed, Jan 22, 2020 at 05:43:16PM -0800, Minchan Kim wrote:
> > It seems I've overlooked an important piece of this submission: one
> > cannot apply the hint to all the anonymous mapping regardless of address
> > range. For KSM I'd rather either have a possibility to hint all the
> > anonymous mappings, or, as it was suggested previously, be able to iterate
> > over existing mappings using some (fd-based?) API.
> 
> Thing is how you could identify a certan range is better for KSM than
> others from external process?

I think the info like this is kinda available via /proc/pid/smaps. It
lists the ranges and the vmflags. But using it raises 2 concerns: one is
the absence of guarantee the mappings won't change after smaps is read
and the second one is that there's no separate vmflag for marking a vma
as non-meregable (and IIRC from previous attempts on addressing this,
we've already exhausted all the flags on 32-bit arches, so it is not
something that can be trivially addressed).

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
