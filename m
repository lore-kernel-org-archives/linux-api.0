From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] mmap.2: MAP_FIXED updated documentation
Date: Sun, 10 Dec 2017 18:22:05 -0800
Message-ID: <fba147b0-06b6-fbf9-8194-171a3e146a63@nvidia.com>
References: <20171206031434.29087-1-jhubbard@nvidia.com>
 <20171210103147.GC20234@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171210103147.GC20234-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/10/2017 02:31 AM, Michal Hocko wrote:
> On Tue 05-12-17 19:14:34, john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> Previously, MAP_FIXED was "discouraged", due to portability
>> issues with the fixed address. In fact, there are other, more
>> serious issues. Also, alignment requirements were a bit vague.
>> So:
>>
>>     -- Expand the documentation to discuss the hazards in
>>        enough detail to allow avoiding them.
>>
>>     -- Mention the upcoming MAP_FIXED_SAFE flag.
>>
>>     -- Enhance the alignment requirement slightly.
>>
>> Some of the wording is lifted from Matthew Wilcox's review
>> (the "Portability issues" section). The alignment requirements
>> section uses Cyril Hrubis' wording, with light editing applied.
>>
>> Suggested-by: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Suggested-by: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
>> Signed-off-by: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> 
> Would you mind if I take this patch and resubmit it along with my
> MAP_FIXED_SAFE (or whatever name I will end up with) next week?
> 
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Sure, that works for me. A tiny complication: I see that Michael
Kerrisk has already applied the much smaller v2 of this patch (the
one that "no longer discourages" the option, but that's all), as:

   ffa518803e14 mmap.2: MAP_FIXED is no longer discouraged

so this one here will need to be adjusted slightly to merge
gracefully. Let me know if you want me to respin, or if you
want to handle the merge.

thanks,
-- 
John Hubbard
NVIDIA
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
