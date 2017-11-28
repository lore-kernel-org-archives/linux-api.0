From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Tue, 28 Nov 2017 09:12:59 +0100
Message-ID: <20171128081259.gnkiw5227dtmfm4l@dhcp22.suse.cz>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
 <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <CAM43=SPVvBTPz31Uu=iz3fpS9tb75uSmL=pYP3AfsfmYr9u4Og@mail.gmail.com>
 <20171127195207.vderbbkbgygawuhx@dhcp22.suse.cz>
 <b6faf739-1a4a-12e1-ad84-0b42166d68c1@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <b6faf739-1a4a-12e1-ad84-0b42166d68c1@nvidia.com>
Sender: owner-linux-mm@kvack.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, linux-mm@kvack.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon 27-11-17 15:26:27, John Hubbard wrote:
[...]
> Let me add a belated report, then: we ran into this limit while implementing 
> an early version of Unified Memory[1], back in 2013. The implementation
> at the time depended on tracking that assumed "one allocation == one vma".

And you tried hard to make those VMAs really separate? E.g. with
prot_none gaps?

> So, with only 64K vmas, we quickly ran out, and changed the design to work
> around that. (And later, the design was *completely* changed to use a separate
> tracking system altogether). 
> 
> The existing limit seems rather too low, at least from my perspective. Maybe
> it would be better, if expressed as a function of RAM size?

Dunno. Whenever we tried to do RAM scaling it turned out a bad idea
after years when memory grown much more than the code author expected.
Just look how we scaled hash table sizes... But maybe you can come up
with something clever. In any case tuning this from the userspace is a
trivial thing to do and I am somehow skeptical that any early boot code
would trip over the limit.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
