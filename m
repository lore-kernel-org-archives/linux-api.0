From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's comp_mask
Date: Thu, 29 Jan 2015 14:34:36 -0700
Message-ID: <20150129213436.GB22099@obsidianresearch.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
 <54C50A67.6040306@mellanox.com>
 <1422271029.3133.68.camel@opteya.com>
 <54C73549.5000003@mellanox.com>
 <1422451151.3133.130.camel@opteya.com>
 <20150129180956.GG11842@obsidianresearch.com>
 <1422556514.3133.165.camel@opteya.com>
 <20150129191423.GL11842@obsidianresearch.com>
 <1422566069.3133.218.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422566069.3133.218.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 10:14:29PM +0100, Yann Droneaud wrote:
> > > Unfortunately, the userspace don't get the size of the returned data:
> > > it's only a single "write()" syscall after all.
> > 
> > A write syscall that behaves nothing like write() actually should, so
> > I don't see why we can't have
> > 
> > resp_len = write(fd,inout_buf,sizeof(input_len));
> > 
> > Returning 0 from write makes no sense at all.

Okay, yes, I see, the flow is different for the ex versions from the
non-ex versions.

> > In the fullness of your patchset it will maintain the invariant that
> > resp_len <= sizeof(input_len)

> I don't catch your point: the response can be bigger than the request.

Indeed, I forgot the scheme used that indirection buffer with
pointers. My comments on write() result are all wrong. Sorry

> > It was never the intent that the size should be computed from
> > comp_mask. If the size is necessary it must be explicit.
> > 
> > In this instance if the size is not returned then libibverbs will have
> > to zero the entire user buffer before passing it to the kernel,
> > because it has to ensure any tail for the user app is 0'd.
>
> The proposed patch ensure the integrity of the response regarding
> comp_mask: if a bit is set in response's comp_mask that means the
> related fields are presents (and valid).

The patch it is good, but sitting this into the larger framework where
we have libibverbs consumers compiled against arbitrary versions of
the structure creates a broader complexity that someone has to deal
with.

libibverbs needs to ensure the trailer portion of the structure from
the end user is 0'd.

> > Remember for santity we want comp mask bits for things that can't be 0
> 
> For me, it's better if a bit is set in response's comp_mask by the 
> kernel when the kernel have written something in the related fields
> even if the those fields are all 0.

Yes, but my point is that comp mask bit should only be used to protect
fields where 0 is not an acceptable 'do not support' answer.

Primarily we should rely on memset(0) to provide compatibility, and
only when really necessary introduce a comp mask bit.

This is why the size is important, we can't deduce the size from
comp_mask, and without the size we can't know where the kernel stopped
writing and the whole thing becomes a little more fragile.

Zeroing the response buffer before calling into the kernel is not a
great general pattern.

Perhaps having the kernel zero the trailing portion it doesn't write
too is okay, but it still feels like not telling user space the size
is asking for future trouble.

> > Ideally we want to minimize the number of COMP bits because it is a
> > huge burden on the end user to work with them.
> 
> Sure. So I think comp_mask is just an overly complicated way of
> expressing the version and the size of the response.

Yes. But understand it is selected to try and provide a good end user
experience, exposing structure versions or size directly to the user
is very difficult to work with.

Ideally the end user will not see many comp mask bits (ie I would drop
the ODP one) and things will 'just work' as compiled.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
