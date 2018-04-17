From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mmap.2: MAP_FIXED is okay if the address range has been
 reserved
Date: Tue, 17 Apr 2018 08:23:10 +0200
Message-ID: <20180417062310.GW17484@dhcp22.suse.cz>
References: <CAG48ez3-xtmAt2EpRFR8GNKKPcsDsyg7XdwQ=D5w3Ym6w4Krjw@mail.gmail.com>
 <CAG48ez1PdzMs8hkatbzSLBWYucjTc75o8ovSmeC66+e9mLvSfA@mail.gmail.com>
 <20180416100736.GG17484@dhcp22.suse.cz>
 <CAG48ez3DwRXMtiinUWKnan6hAppLYLdx-w+VzXG6ubioZUacQg@mail.gmail.com>
 <20180416191805.GS17484@dhcp22.suse.cz>
 <CAG48ez1nf96nHj8a+aZy22RwqYTUZBGrsGFcz=ZhZBUWzaEZ9w@mail.gmail.com>
 <20180416195726.GT17484@dhcp22.suse.cz>
 <CAG48ez1bV_zZP3Y2ioDndP+H8mLCcxOtU1vCbWe7Q8myEGfXQQ@mail.gmail.com>
 <20180416211115.GU17484@dhcp22.suse.cz>
 <CAG48ez2fXcQS7sw_aCC6_wBKjYphOxFRN4rrRzSk2+-T_mFaxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez2fXcQS7sw_aCC6_wBKjYphOxFRN4rrRzSk2+-T_mFaxw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, John Hubbard <jhubbard@nvidia.com>, linux-man <linux-man@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon 16-04-18 23:12:48, Jann Horn wrote:
> On Mon, Apr 16, 2018 at 11:11 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 16-04-18 22:17:40, Jann Horn wrote:
> >> On Mon, Apr 16, 2018 at 9:57 PM, Michal Hocko <mhocko@kernel.org> wrote:
> >> > On Mon 16-04-18 21:30:09, Jann Horn wrote:
> >> >> On Mon, Apr 16, 2018 at 9:18 PM, Michal Hocko <mhocko@kernel.org> wrote:
> >> > [...]
> >> >> > Yes, reasonably well written application will not have this problem.
> >> >> > That, however, requires an external synchronization and that's why
> >> >> > called it error prone and racy. I guess that was the main motivation for
> >> >> > that part of the man page.
> >> >>
> >> >> What requires external synchronization? I still don't understand at
> >> >> all what you're talking about.
> >> >>
> >> >> The following code:
> >> >>
> >> >> void *try_to_alloc_addr(void *hint, size_t len) {
> >> >>   char *x = mmap(hint, len, ...);
> >> >>   if (x == MAP_FAILED) return NULL;
> >> >>   if (x == hint) return x;
> >> >
> >> > Any other thread can modify the address space at this moment.
> >>
> >> But not parts of the address space that were returned by this mmap() call.
> > ?
> >> > Just
> >> > consider that another thread would does mmap(x, MAP_FIXED) (or any other
> >> > address overlapping [x, x+len] range)
> >>
> >> If the other thread does that without previously having created a
> >> mapping covering the area in question, that would be a bug in the
> >> other thread.
> >
> > MAP_FIXED is sometimes used without preallocated address ranges.
> 
> Wow, really? Can you point to an example?

Just from top of my head.

Some of that is for historical reasons because the hint address used to
be ignored on some operating systems so MAP_FIXED had to be used.

Currently not user I guess but MAP_FIXED for addresses above 47b address
space AFAIR.

And I am pretty sure there would be much more if you actually browsed
code search.
-- 
Michal Hocko
SUSE Labs
