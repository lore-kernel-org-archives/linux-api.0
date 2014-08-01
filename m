From: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: Implement ioctl to restrict
 privcmd to a specific domain
Date: Fri, 1 Aug 2014 14:44:18 +0100
Message-ID: <1406900658.27080.12.camel@hamster.uk.xensource.com>
References: <E1XCqEY-0005zn-V2@lists.xen.org>
	 <53DB6B8D02000078000284D3@mail.emea.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53DB6B8D02000078000284D3-tRfBTM6QL9aeHWOVceGJHFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2014-08-01 at 09:27 +0100, Jan Beulich wrote:
> >>> On 31.07.14 at 15:16, <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> > Add a RESTRICT ioctl to /dev/xen/privcmd, which allows privileged commands
> > file descriptor to be restricted to only working with a particular domain.
> 
> The "with" here has been quite confusing, and I realized that you
> mean the subject domain rather than the actor one only after
> having gone through quite some parts of the patch. For a patch
> this size, a little more of a description (and the original motivation)
> would have helped.
> 

Yes, you are right.

> Wrt motivation: Why does this need enforcing in the kernel at all?
> Doesn't XSM_DM_PRIV mode deal specifically with what you're
> trying to do here? Or else I guess I really need some better
> explanation of what this is about.
> 
> Jan
> 

This is quite old for me but you are right, perhaps is not that clear
for other people. In XenServer we have some patches that allow Qemu
running in dom0 but work only for a specific domain. The patches
required changes to libxc, kernel and Qemu. We are reimplementing these
patches as the old implementation has some problems (one is that the
patch for libxc was quite big). This feature was removed as kernel
patches did not work with newer (3.x) kernels.

Now, XSM_DM_PRIV works checking if the domain target is the domain we
are going to handle. However if your dom0 (as in XenServer) has all Qemu
to handle all VMs it cannot be bound to a single target so XSM is not
usable. Xen has no knowledge of process or file descriptor (which are
kernel specific) so there is actually no way it can distinguish which
domain should be restricted to. It would solve if the restriction would
be done for system call (so we can say execute this hypercall(s) with
these policies). However this require to change the target to be at
least CPU specific and handle preemption correctly in order to not mix
policies. This could be quite heavy so we hack the kernel in order to do
the restriction instead (it also was easier to port the patches).

Actually changes in Qemu to handle the privcmd/evtchn restrictions are
quite small, mainly restrict these two handles with an ioctl. Other
parts of the patch (chroot, setuid, groups, resource limits, and mostly
xenstore accesses) are more heavy.

Frediano
