From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's comp_mask
Date: Thu, 29 Jan 2015 12:14:23 -0700
Message-ID: <20150129191423.GL11842@obsidianresearch.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
 <54C50A67.6040306@mellanox.com>
 <1422271029.3133.68.camel@opteya.com>
 <54C73549.5000003@mellanox.com>
 <1422451151.3133.130.camel@opteya.com>
 <20150129180956.GG11842@obsidianresearch.com>
 <1422556514.3133.165.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422556514.3133.165.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 29, 2015 at 07:35:14PM +0100, Yann Droneaud wrote:

> Unfortunately, the userspace don't get the size of the returned data:
> it's only a single "write()" syscall after all.

A write syscall that behaves nothing like write() actually should, so
I don't see why we can't have

resp_len = write(fd,inout_buf,sizeof(input_len));

Returning 0 from write makes no sense at all.

In the fullness of your patchset it will maintain the invariant that
resp_len <= sizeof(input_len)

Which seems OK to me considering what we have to work with, and a
significantly better choice than 0.

> So the kernel is left with the comp_mask in the response to express
> the returned size.

It was never the intent that the size should be computed from
comp_mask. If the size is necessary it must be explicit.

In this instance if the size is not returned then libibverbs will have
to zero the entire user buffer before passing it to the kernel,
because it has to ensure any tail for the user app is 0'd.

Remember for santity we want comp mask bits for things that can't be 0
and we want 0 for things that are not set.

struct ib_query_device_ex res;
ibv_query_device_ex(..,res,sizeof(res));

printf("%u",res.foo_cap); // 0 if unsupported is OK
if (res.comp_mask & COMP_BAR)
  printf("%u",res.bar_thingy);  // 0 has meaning, must use COMP_BAR

Ideally we want to minimize the number of COMP bits because it is a
huge burden on the end user to work with them.

> > The purpose of the output comp_mask is to allow drivers to declare
> > they do not support the new structure members, and comp_mask bits
> > should only be used with new structure members do not have a natural
> > 'null' value.

> It's not (yet) about drivers as the output's comp_mask (in the 
> response), is set by uverbs layer.
> 
> Do you think we have to enforce a 1 to 1 relation between the request 
> comp_mask's bits and the response comp_mask's bits ?

In the query context I would be happy enough to just treat the in
bound buffer as uninitialized buffer space, but certainly generally
speaking the comp_mask+size should refer to the structure - so
input/output are not directly related.

> > Further, we need to distinguish cases where additional data is
> > mandatory or optional.
> > 
> > query_device is clearly optional, the only purpose the input comp mask
> > serves is to reduce expensive work in the driver by indicating that
> > some result bits are not needed.
> 
> That's not how I've understand the purpose of the request's comp_mask
> after reading the presentation: request's comp_mask describe the content
> of the request. Then that additional content can trigger the presence 
> of additional fields in the response if needed.

Agreed - what I described was an abuse that some early Mellanox
patches for a query_ex included and it was just a shortcut to avoid
defining a dedicated input structure. It seems that same scheme was
copied into these new patches.

> >  It is perfectly OK for the kernel to
> > ignore the input comp mask, and OK for userspace to typically request
> > all bits. (indeed, I think this is a pretty silly optimization myself,
> > and the original patch that motivated this was restructured so it is
> > not needed)
> > 
> 
> It's not at all OK to ignore request's comp_mask: it has to be checked
> to find if there's a feature requested the kernel cannot fullfil, and 
> any unknown bit is a possible feature request. So the kernel has to 
> reject the request as a whole as it don't know how to process it.

In the context of the above scheme the input structure was just this:

struct query_input
{
  u64 requested_output;
};

ie it wasn't actually a comp_mask, it just overlapped the comp_mask
bytes on output.

Such a use was never explicitly documented, and IIRC was never
actually included in libibverbs.

Unless someone has a strong reason we need to do this I am inclined to
think that your interpretation is the better one, and we could always
add a requested_output to the input someday if it became urgent.

In any event, you are right, we can't ingore the input bytes today and
expect to give them meaning tomorrow.

> As we don't know yet how we would extend the extended QUERY_DEVICE
> uverbs, the kernel have to refuse any random value.
> 
> http://blog.ffwll.ch/2013/11/botching-up-ioctls.html

or the kernel treats QUERY_DEVICE as an output only function and never
inspects the in/out buffer at all.

> > > Thanks for the link to the presentation.
> > 
> > If I recall the presentation is old and had some flaws that were
> > addressed before things made it into libibverbs..
> 
> I have to have a look to this part of libibverbs: I'm not sure
> the extended QUERY_DEVICE is already implemented.

The patches turned out to be unnecessary and were dropped, IIRC.
 
> > Thank you for looking at this, it is very important that this scheme
> > is used properly, and it is very easy to make mistakes. I haven't had
> > time to review any of these new patches myself.

> I hope you would find some time to review my latest patchset so that
> we don't miss a corner case. It's starting to become urgent.

I have and will, thank you

Jason
