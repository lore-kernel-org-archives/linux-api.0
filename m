From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] Add /proc/PID/{smaps, numa_maps} support for DAX
Date: Thu, 26 Oct 2017 16:16:04 +0200
Message-ID: <20171026141604.susqkaniglc5aqw2@dhcp22.suse.cz>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
 <1508891255-15427-2-git-send-email-fan.du@intel.com>
 <20171025093045.s3rpcuovld22bhqu@dhcp22.suse.cz>
 <1f673f36-74b0-3321-32a4-a8031d5f268a@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f673f36-74b0-3321-32a4-a8031d5f268a@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Fan Du <fan.du@intel.com>, akpm@linux-foundation.org, hch@lst.de, dan.j.williams@intel.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 25-10-17 10:14:34, Dave Hansen wrote:
> On 10/25/2017 02:30 AM, Michal Hocko wrote:
> >>
> >> 7f6c17800000-7f6c17e00000 rw-s 00000000 00:06 20559  /dev/dax12.0
> >> Size:               6144 kB
> >> .
> >> .
> >> .
> >> Ptes@2MB:      		6144 kB
> > This says how but it doesn't tell why and who is going to use the
> > information and what for.
> 
> The original motivation was for DAX.  They have parallel large page
> infrastructure separate from hugetlbfs and THP.  Their constraints about
> when they can use large pages differ from the normal mm cases, so it is
> hard to tell when large pages are in use.  For instance, the file on
> *disk* has to be 2MB contiguous and aligned to map with 2MB pages even
> if the mmap() address is >2MB and 2MB-aligned.

I assume there is some tool which is going to use this information?

> But, in general, this seems like the thing that we probably should have
> done in the first place for THP.  It's a lot more generic and does not
> require someone reading the file to know what the particular
> architecture's page sizes are.

I fully agree. This just shows how single usecase focus driven smaps
file was. That is why I am asking about usecases when somebody want to
try yet another special field there. Smaps has become a dump of of
special cases which is not really easy to understand and so people tend
to use it incorrectly.

-- 
Michal Hocko
SUSE Labs
