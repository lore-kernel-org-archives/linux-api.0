From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Add /proc/PID/{smaps, numa_maps} support for DAX
Date: Wed, 25 Oct 2017 10:14:34 -0700
Message-ID: <1f673f36-74b0-3321-32a4-a8031d5f268a@intel.com>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
 <1508891255-15427-2-git-send-email-fan.du@intel.com>
 <20171025093045.s3rpcuovld22bhqu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025093045.s3rpcuovld22bhqu-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/25/2017 02:30 AM, Michal Hocko wrote:
>>
>> 7f6c17800000-7f6c17e00000 rw-s 00000000 00:06 20559  /dev/dax12.0
>> Size:               6144 kB
>> .
>> .
>> .
>> Ptes@2MB:      		6144 kB
> This says how but it doesn't tell why and who is going to use the
> information and what for.

The original motivation was for DAX.  They have parallel large page
infrastructure separate from hugetlbfs and THP.  Their constraints about
when they can use large pages differ from the normal mm cases, so it is
hard to tell when large pages are in use.  For instance, the file on
*disk* has to be 2MB contiguous and aligned to map with 2MB pages even
if the mmap() address is >2MB and 2MB-aligned.

But, in general, this seems like the thing that we probably should have
done in the first place for THP.  It's a lot more generic and does not
require someone reading the file to know what the particular
architecture's page sizes are.
