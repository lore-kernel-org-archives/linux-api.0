From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 3/6] mm: Introduce VM_LOCKONFAULT
Date: Wed, 26 Aug 2015 09:20:16 +0200
Message-ID: <20150826072016.GD25196@dhcp22.suse.cz>
References: <20150812115909.GA5182@dhcp22.suse.cz>
 <20150819213345.GB4536@akamai.com>
 <20150820075611.GD4780@dhcp22.suse.cz>
 <20150820170309.GA11557@akamai.com>
 <20150821072552.GF23723@dhcp22.suse.cz>
 <20150821183132.GA12835@akamai.com>
 <20150825134154.GB6285@dhcp22.suse.cz>
 <20150825142902.GF17005@akamai.com>
 <20150825185829.GA10222@dhcp22.suse.cz>
 <20150825190300.GG17005@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150825190300.GG17005-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 25-08-15 15:03:00, Eric B Munson wrote:
[...]
> Would you drop your objections to the VMA flag if I drop the portions of
> the patch that expose it to userspace?
> 
> The rework to not use the VMA flag is pretty sizeable and is much more
> ugly IMO.  I know that you are not wild about using bit 30 of 32 for
> this, but perhaps we can settle on not exporting it to userspace so we
> can reclaim it if we really need it in the future?

Yes, that would be definitely more acceptable for me. I do understand
that you are not wild about changing mremap behavior.

Anyway, I would really prefer if the vma flag was really used only at
few places - when we are clearing it along with VM_LOCKED (which could
be hidden in VM_LOCKED_CLEAR_MASK or something like that) and when we
decide whether the populate or not (this should be __mm_populate). But
maybe I am missing some call paths where gup is called unconditionally,
I haven't checked that.
-- 
Michal Hocko
SUSE Labs
