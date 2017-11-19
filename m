From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC v2] prctl: prctl(PR_SET_IDLE, PR_IDLE_MODE_KILLME), for
 stateless idle loops
Date: Sat, 18 Nov 2017 20:19:54 -0800
Message-ID: <20171119041954.GA12039@bombadil.infradead.org>
References: <20171101053244.5218-1-slandden@gmail.com>
 <20171103063544.13383-1-slandden@gmail.com>
 <20171103090915.uuaqo56phdbt6gnf@dhcp22.suse.cz>
 <CA+49okqZ8CME0EN1xS_cCTc5Q-fGRreg0makhzNNuRpGs3mjfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+49okqZ8CME0EN1xS_cCTc5Q-fGRreg0makhzNNuRpGs3mjfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shawn Landden <slandden-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 17, 2017 at 08:45:03PM -0800, Shawn Landden wrote:
> On Fri, Nov 3, 2017 at 2:09 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Thu 02-11-17 23:35:44, Shawn Landden wrote:
> > > 16 bytes per process is kinda spendy, but I want to keep
> > > lru behavior, which mem_score_adj does not allow. When a supervisor,
> > > like Android's user input is keeping track this can be done in
> > user-space.
> > > It could be pulled out of task_struct if an cross-indexing additional
> > > red-black tree is added to support pid-based lookup.
> >
> > This is still an abuse and the patch is wrong. We really do have an API
> > to use I fail to see why you do not use it.
> >
> When I looked at wait_queue_head_t it was 20 byes.

24 bytes actually; the compiler will add 4 bytes of padding between
the spinlock and the list_head.  But there's one for the entire system.
Then you add a 40 byte structure (wait_queue_entry) on the stack for each
sleeping process.  There's no per-process cost.
