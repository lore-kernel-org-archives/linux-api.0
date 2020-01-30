From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v2 PATCH] move_pages.2: Returning positive value is a new error
 case
Date: Thu, 30 Jan 2020 13:56:20 +0100
Message-ID: <cce2e784-8092-00f5-32bf-d23ab7a53476@suse.cz>
References: <1580334531-80354-1-git-send-email-yang.shi@linux.alibaba.com>
 <f276d8ec-b1be-4f8e-792b-5c3ca2de4714@suse.cz>
 <20200130120253.GU24244@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200130120253.GU24244-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 1/30/20 1:02 PM, Michal Hocko wrote:
> On Thu 30-01-20 10:06:28, Vlastimil Babka wrote:
>> On 1/29/20 10:48 PM, Yang Shi wrote:
>>> Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>>> the semantic of move_pages() has changed to return the number of
>>> non-migrated pages if they were result of a non-fatal reasons (usually a
>>> busy page).  This was an unintentional change that hasn't been noticed
>>> except for LTP tests which checked for the documented behavior.
>>>
>>> There are two ways to go around this change.  We can even get back to the
>>> original behavior and return -EAGAIN whenever migrate_pages is not able
>>
>> The manpage says EBUSY, not EAGAIN? And should its description be
>> updated too?
> 
> The idea was that we _could_ return EAGAIN from the syscall if
> migrate_pages > 0.
> 
>> I.e. that it's no longer returned since 4.17?
> 
> I am pretty sure this will require a deeper consideration. Do we return
> EIO/EINVAL?

I thought the manpage says we return -EBUSY, but I misread it, this part
was not about errno, but the status array. So there's nothing to update
there, sorry about the noise.

BTW, the suggestion to "Pre-initialization of the array to -1" means
effectively it's pre-initialized to -EPERM. That's fine now as -EPERM is
not one of the codes listed as possible to be returned via the array,
but perhaps it's not entirely future-proof?
