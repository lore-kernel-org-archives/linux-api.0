From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 1/3] mm, proc: be more verbose about unstable VMA
 flags in /proc/<pid>/smaps
Date: Wed, 21 Nov 2018 18:58:09 +0100
Message-ID: <20181121175809.GT12932@dhcp22.suse.cz>
References: <20181120103515.25280-1-mhocko@kernel.org>
 <20181120103515.25280-2-mhocko@kernel.org>
 <20181121175427.GB5704@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121175427.GB5704@rapoport-lnx>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, David Rientjes <rientjes@google.com>
List-Id: linux-api@vger.kernel.org

On Wed 21-11-18 18:54:28, Mike Rapoport wrote:
> On Tue, Nov 20, 2018 at 11:35:13AM +0100, Michal Hocko wrote:
[...]
> > diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> > index 12a5e6e693b6..b1fda309f067 100644
> > --- a/Documentation/filesystems/proc.txt
> > +++ b/Documentation/filesystems/proc.txt
> > @@ -496,7 +496,9 @@ flags associated with the particular virtual memory area in two letter encoded
> > 
> >  Note that there is no guarantee that every flag and associated mnemonic will
> >  be present in all further kernel releases. Things get changed, the flags may
> > -be vanished or the reverse -- new added.
> > +be vanished or the reverse -- new added. Interpretatation of their meaning
> > +might change in future as well. So each consumnent of these flags have to
> 
>                                            consumer?                 has

fixed. Thanks!

-- 
Michal Hocko
SUSE Labs
