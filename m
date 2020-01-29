From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] move_pages.2: Returning positive value is a new error
 case
Date: Wed, 29 Jan 2020 20:11:05 +0100
Message-ID: <20200129191105.GQ24244@dhcp22.suse.cz>
References: <1580322632-93332-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200129185842.GP24244@dhcp22.suse.cz>
 <0db6a002-d067-8acd-65ee-8c87a32ff769@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0db6a002-d067-8acd-65ee-8c87a32ff769-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 29-01-20 11:05:11, Yang Shi wrote:
> 
> 
> On 1/29/20 10:58 AM, Michal Hocko wrote:
> > On Thu 30-01-20 02:30:32, Yang Shi wrote:
> > > Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
> > > the semantic of move_pages() has changed to return the number of
> > > non-migrated pages if they were result of a non-fatal reasons (usually a
> > > busy page).  This was an unintentional change that hasn't been noticed
> > > except for LTP tests which checked for the documented behavior.
> > > 
> > > There are two ways to go around this change.  We can even get back to the
> > > original behavior and return -EAGAIN whenever migrate_pages is not able
> > > to migrate pages due to non-fatal reasons.  Another option would be to
> > > simply continue with the changed semantic and extend move_pages
> > > documentation to clarify that -errno is returned on an invalid input or
> > > when migration simply cannot succeed (e.g. -ENOMEM, -EBUSY) or the
> > > number of pages that couldn't have been migrated due to ephemeral
> > > reasons (e.g. page is pinned or locked for other reasons).
> > > 
> > > We decided to keep the second option in kernel because this behavior is in
> > > place for some time without anybody complaining and possibly new users
> > > depending on it.  Also it allows to have a slightly easier error handling
> > > as the caller knows that it is worth to retry when err > 0.
> > > 
> > > Update man pages to reflect the new semantic.
> > Thanks a lot! Looks good to me. I would just add a note that it is
> > generally recommended to pre-initialize status array by -1 to have a
> > reliable way to check which pages have been migrated. The man page says
> > "The array contains valid values only if move_pages() did not return an
> > error."
> > 
> > I would just add. "Pre initialization of the array to -1 or similar
> > value which cannot represent a real numa node could help to identify
> > pages that have been migrated".
> 
> Sure. Adding this note right after the explanation of positive value error
> seems fine?

I would just follow up on the existing note about valid values.

-- 
Michal Hocko
SUSE Labs
