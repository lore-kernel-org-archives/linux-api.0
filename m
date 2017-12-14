From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] mmap.2: MAP_FIXED updated documentation
Date: Thu, 14 Dec 2017 08:07:18 +0100
Message-ID: <20171214070718.GA16951@dhcp22.suse.cz>
References: <20171213092550.2774-1-mhocko@kernel.org>
 <20171213093110.3550-1-mhocko@kernel.org>
 <20171213093110.3550-2-mhocko@kernel.org>
 <20171213125540.GA18897@amd>
 <20171213130458.GI25185@dhcp22.suse.cz>
 <20171213130900.GA19932@amd>
 <20171213131640.GJ25185@dhcp22.suse.cz>
 <20171213132105.GA20517@amd>
 <20171213144050.GG11493@rei>
 <CAGXu5jLqE6cUxk-Girx6PG7upEzz8jmu1OH_3LVC26iJc2vTxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLqE6cUxk-Girx6PG7upEzz8jmu1OH_3LVC26iJc2vTxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 13-12-17 15:19:00, Kees Cook wrote:
> On Wed, Dec 13, 2017 at 6:40 AM, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
> > Hi!
> >> You selected stupid name for a flag. Everyone and their dog agrees
> >> with that. There's even consensus on better name (and everyone agrees
> >> it is better than .._SAFE). Of course, we could have debate if it is
> >> NOREPLACE or NOREMOVE or ... and that would be bikeshed. This was just
> >> poor naming on your part.
> >
> > Well while everybody agrees that the name is so bad that basically
> > anything else would be better, there does not seem to be consensus on
> > which one to pick. I do understand that this frustrating and fruitless.
> 
> Based on the earlier threads where I tried to end the bikeshedding, it
> seemed like MAP_FIXED_NOREPLACE was the least bad option.
> 
> > So what do we do now, roll a dice to choose new name?
> >
> > Or do we ask BFDL[1] to choose the name?
> 
> I'd like to hear feedback from Michael Kerrisk, as he's had to deal
> with these kinds of choices in the past. I'm fine to ask Linus too. I
> just want to get past the name since the feature is quite valuable.
> 
> And if Michal doesn't want to touch this patch any more, I'm happy to
> do the search/replace/resend. :P

I think Andrew can do the s@MAP_FIXED_SAFE@MAP_$FOO@ when adding the
patch to the mmotm tree. The reason why I refuse to repost is that a)
functionality doesn't really need a further rework (at least not based
on the review feedback) and b) I do not really see any large consensus
here. People claim to like this or that more but nobody (except of you
Kees) was willing to put their name under their preference in a form of
Acked-by. And that worries me, because generating "better" names sounds
too easy to allow a forward progress.
-- 
Michal Hocko
SUSE Labs
