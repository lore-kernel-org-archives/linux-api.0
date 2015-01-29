From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's comp_mask
Date: Thu, 29 Jan 2015 11:09:56 -0700
Message-ID: <20150129180956.GG11842@obsidianresearch.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
 <54C50A67.6040306@mellanox.com>
 <1422271029.3133.68.camel@opteya.com>
 <54C73549.5000003@mellanox.com>
 <1422451151.3133.130.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422451151.3133.130.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 28, 2015 at 02:19:11PM +0100, Yann Droneaud wrote:

> But the same program (either binary or source code) might fail on
> newer kernel where some bits in comp_mask gain a meaning not supported
> by the program.

To clarify some of this:

The intention of the comp_mask scheme was to define a growing
structure.

The invariant is: A bigger structure allways has all smaller
structures (past versions) as a prefix.

So the size alone is enough for user space to know what is going
on. userspace only processes structure members up to the size returned
by the kernel, and there is only one structure layout.

The purpose of the output comp_mask is to allow drivers to declare
they do not support the new structure members, and comp_mask bits
should only be used with new structure members do not have a natural
'null' value.

Further, we need to distinguish cases where additional data is
mandatory or optional.

query_device is clearly optional, the only purpose the input comp mask
serves is to reduce expensive work in the driver by indicating that
some result bits are not needed. It is perfectly OK for the kernel to
ignore the input comp mask, and OK for userspace to typically request
all bits. (indeed, I think this is a pretty silly optimization myself,
and the original patch that motivated this was restructured so it is
not needed)

Other verbs must be more strict, if one side does not understand the
comp mask then the verb must fail in some way. Presumably the valid
comp mask values are inferred in some way (eg query_device says the
extended function is supported)

Everything should fit in one of those two general cases..
  
> Thanks for the link to the presentation.

If I recall the presentation is old and had some flaws that were
addressed before things made it into libibverbs..

Thank you for looking at this, it is very important that this scheme
is used properly, and it is very easy to make mistakes. I haven't had
time to review any of these new patches myself.

Regards,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
