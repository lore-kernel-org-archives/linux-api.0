From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 3/3] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Tue, 27 Nov 2018 17:25:44 +0100
Message-ID: <20181127162544.GA6923@dhcp22.suse.cz>
References: <20181120103515.25280-1-mhocko@kernel.org>
 <20181120103515.25280-4-mhocko@kernel.org>
 <0ACDD94B-75AD-4DD0-B2E3-32C0EDFBAA5E@oracle.com>
 <20181127131707.GW12455@dhcp22.suse.cz>
 <04647F77-FE93-4A8E-90C1-4245709B88A5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <04647F77-FE93-4A8E-90C1-4245709B88A5@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: William Kucharski <william.kucharski@oracle.com>
Cc: linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue 27-11-18 07:50:08, William Kucharski wrote:
> 
> 
> > On Nov 27, 2018, at 6:17 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > 
> > This is only about the process wide flag to disable THP. I do not see
> > how this can be alighnement related. I suspect you wanted to ask in the
> > smaps patch?
> 
> No, answered below.
> 
> > 
> >> I'm having to deal with both these issues in the text page THP
> >> prototype I've been working on for some time now.
> > 
> > Could you be more specific about the issue and how the alignment comes
> > into the game? The only thing I can think of is to not report VMAs
> > smaller than the THP as eligible. Is this what you are looking for?
> 
> Basically, if the faulting VA is one that cannot be mapped with a THP
> due to alignment or size constraints, it may be "eligible" for THP
> mapping but ultimately can't be.
> 
> I was just double checking that this was meant to be more of a check done
> before code elsewhere performs additional checks and does the actual THP
> mapping, not an all-encompassing go/no go check for THP mapping.

I am still not sure I follow you completely here. This just reports
per-task eligibility. The system wide eligibility is reported via sysfs
and the per vma eligibility is reported via /proc/<pid>/smaps.

-- 
Michal Hocko
SUSE Labs
