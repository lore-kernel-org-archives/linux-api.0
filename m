From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/2] mm: introduce MAP_FIXED_SAFE
Date: Thu, 7 Dec 2017 13:07:35 +0100
Message-ID: <20171207120735.GA24547@atrey.karlin.mff.cuni.cz>
References: <20171129144219.22867-1-mhocko@kernel.org>
 <20171129144219.22867-2-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171129144219.22867-2-mhocko@kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

Hi!

> MAP_FIXED is used quite often to enforce mapping at the particular
> range. The main problem of this flag is, however, that it is inherently
> dangerous because it unmaps existing mappings covered by the requested
> range. This can cause silent memory corruptions. Some of them even with
> serious security implications. While the current semantic might be
> really desiderable in many cases there are others which would want to
> enforce the given range but rather see a failure than a silent memory
> corruption on a clashing range. Please note that there is no guarantee
> that a given range is obeyed by the mmap even when it is free - e.g.
> arch specific code is allowed to apply an alignment.
> 
> Introduce a new MAP_FIXED_SAFE flag for mmap to achieve this behavior.
> It has the same semantic as MAP_FIXED wrt. the given address request

Could we get some better name? Functionality seems reasonable, but
_SAFE suffix does not really explain what is going on to the user.

MAP_ADD_FIXED ?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
