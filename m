From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 3/3] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Tue, 27 Nov 2018 14:17:07 +0100
Message-ID: <20181127131707.GW12455@dhcp22.suse.cz>
References: <20181120103515.25280-1-mhocko@kernel.org>
 <20181120103515.25280-4-mhocko@kernel.org>
 <0ACDD94B-75AD-4DD0-B2E3-32C0EDFBAA5E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0ACDD94B-75AD-4DD0-B2E3-32C0EDFBAA5E@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: William Kucharski <william.kucharski@oracle.com>
Cc: linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon 26-11-18 17:33:32, William Kucharski wrote:
> 
> 
> This determines whether the page can theoretically be THP-mapped , but
> is the intention to also check for proper alignment and/or preexisting
> PAGESIZE page cache mappings for the address range?

This is only about the process wide flag to disable THP. I do not see
how this can be alighnement related. I suspect you wanted to ask in the
smaps patch?

> I'm having to deal with both these issues in the text page THP
> prototype I've been working on for some time now.

Could you be more specific about the issue and how the alignment comes
into the game? The only thing I can think of is to not report VMAs
smaller than the THP as eligible. Is this what you are looking for?
-- 
Michal Hocko
SUSE Labs
