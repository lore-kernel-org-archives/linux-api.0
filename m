From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] mmap.2: MAP_FIXED updated documentation
Date: Wed, 13 Dec 2017 14:16:40 +0100
Message-ID: <20171213131640.GJ25185@dhcp22.suse.cz>
References: <20171213092550.2774-1-mhocko@kernel.org>
 <20171213093110.3550-1-mhocko@kernel.org>
 <20171213093110.3550-2-mhocko@kernel.org>
 <20171213125540.GA18897@amd>
 <20171213130458.GI25185@dhcp22.suse.cz>
 <20171213130900.GA19932@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20171213130900.GA19932@amd>
Sender: owner-linux-mm@kvack.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Cyril Hrubis <chrubis@suse.cz>
List-Id: linux-api@vger.kernel.org

On Wed 13-12-17 14:09:00, Pavel Machek wrote:
> On Wed 2017-12-13 14:04:58, Michal Hocko wrote:
> > On Wed 13-12-17 13:55:40, Pavel Machek wrote:
> > > On Wed 2017-12-13 10:31:10, Michal Hocko wrote:
> > > > From: John Hubbard <jhubbard@nvidia.com>
> > > > 
> > > >     -- Expand the documentation to discuss the hazards in
> > > >        enough detail to allow avoiding them.
> > > > 
> > > >     -- Mention the upcoming MAP_FIXED_SAFE flag.
> > > 
> > > Pretty map everyone agreed MAP_FIXED_SAFE was a bad
> > > name. MAP_FIXED_NOREPLACE (IIRC) was best replacement.
> > 
> > Please read http://lkml.kernel.org/r/20171213092550.2774-1-mhocko@kernel.org
> 
> Please fix your patches according to the feedback...
> 
> NACCKED-by: Pavel Machek <pavel@ucw.cz>

Good luck pursuing this further then. I am not going to spend time on
naming bikeheds. I have more pressing stuff to work on.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
