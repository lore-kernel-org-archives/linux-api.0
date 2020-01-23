From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 2/5] mm: introduce external memory hinting API
Date: Wed, 22 Jan 2020 17:43:16 -0800
Message-ID: <20200123014316.GB249784@google.com>
References: <20200116235953.163318-1-minchan@kernel.org>
 <20200116235953.163318-3-minchan@kernel.org>
 <20200117115225.GV19428@dhcp22.suse.cz>
 <20200117155837.bowyjpndfiym6cgs@box>
 <20200117173239.GB140922@google.com>
 <20200117212653.7uftw3lk35oykkmb@box>
 <20200121181113.GE140922@google.com>
 <20200122104424.7gvrfivymjvdous4@butterfly.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200122104424.7gvrfivymjvdous4@butterfly.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, ktkhai@virtuozzo.com, christian.brauner@ubuntu.com, sjpark@amazon.de
List-Id: linux-api@vger.kernel.org

On Wed, Jan 22, 2020 at 11:44:24AM +0100, Oleksandr Natalenko wrote:
> Hello.
> 
> On Tue, Jan 21, 2020 at 10:11:13AM -0800, Minchan Kim wrote:
> > > > I also think people don't want to give an KSM hint to non-mergeable area.
> > > 
> > > And how the manager knows which data is mergable?
> > 
> > Oleksandr, could you say your thought why you need address range based
> > API?
> 
> It seems I've overlooked an important piece of this submission: one
> cannot apply the hint to all the anonymous mapping regardless of address
> range. For KSM I'd rather either have a possibility to hint all the
> anonymous mappings, or, as it was suggested previously, be able to iterate
> over existing mappings using some (fd-based?) API.

Thing is how you could identify a certan range is better for KSM than
others from external process?
