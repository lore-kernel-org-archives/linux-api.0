From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: MADV_DONTNEED semantics? Was: [RFC PATCH] mm: madvise: Ignore
 repeated MADV_DONTNEED hints
Date: Tue, 03 Feb 2015 17:25:08 +0100
Message-ID: <54D0F664.3070606@gmail.com>
References: <20150202165525.GM2395@suse.de> <54CFF8AC.6010102@intel.com> <54D08483.40209@suse.cz> <20150203111600.GR2395@suse.de> <20150203152121.GC8914@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150203152121.GC8914-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.orgMinchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/03/2015 04:21 PM, Michal Hocko wrote:
> On Tue 03-02-15 11:16:00, Mel Gorman wrote:
>> On Tue, Feb 03, 2015 at 09:19:15AM +0100, Vlastimil Babka wrote:
> [...]
>>> And if we agree that there is indeed no guarantee, what's the actual semantic
>>> difference from MADV_FREE? I guess none? So there's only a possible perfomance
>>> difference?
>>>
>>
>> Timing. MADV_DONTNEED if it has an effect is immediate, is a heavier
>> operations and RSS is reduced. MADV_FREE only has an impact in the future
>> if there is memory pressure.
> 
> JFTR. the man page for MADV_FREE has been proposed already
> (https://lkml.org/lkml/2014/12/5/63 should be the last version AFAIR). I
> do not see it in the man-pages git tree but the patch was not in time
> for 3.19 so I guess it will only appear in 3.20.
> 

Yikes! That patch was buried in the bottom of a locked filing cabinet
in a disused lavatory. I unfortunately don't read every thread that comes
my way, especially if it doesn't look like a man-pages patch (i.e., falls
in the middle of an LKML thread that starts on another topic, and doesn't 
see linux-man@). I'll respond to that patch soon. (There are some problems
that mean I could not accept it, AFAICT.)

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
