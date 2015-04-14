From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [RFC/PATCH v2 0/5] Add live source objects to DRM
Date: Tue, 14 Apr 2015 11:56:14 +0200
Message-ID: <20150414095614.GG6092@phenom.ffwll.local>
References: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1428950387-6913-1-git-send-email-laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurent Pinchart <laurent.pinchart+renesas-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Cc: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Magnus Damm <magnus.damm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 13, 2015 at 09:39:42PM +0300, Laurent Pinchart wrote:
> Hello,
> 
> Here's a proposal for a different approach to live source in DRM based on an
> idea by Daniel Vetter. The previous version can be found at
> http://lists.freedesktop.org/archives/dri-devel/2015-March/079319.html.

msm is also interested in a drm/v4l bridge on the capture/writeback side.
Although I haven't convinced them yet that rolling their own isn't
awesome.

> The need comes from the Renesas R-Car SoCs in which a video processing engine
> (named VSP1) that operates from memory to memory has one output directly
> connected to a plane of the display engine (DU) without going through memory.
> 
> The VSP1 is supported by a V4L2 driver. While it could be argued that it
> should instead be supported directly by the DRM rcar-du driver, this wouldn't
> be a good idea for at least two reasons. First, the R-Car SoCs contain several
> VSP1 instances, of which only a subset have a direct DU connection. The only
> other instances operate solely in memory to memory mode. Then, the VSP1 is a
> video processing engine and not a display engine. Its features are easily
> supported by the V4L2 API, but don't map to the DRM/KMS API. Significant
> changes to DRM/KMS would be required, beyond what is in my opinion an
> acceptable scope for a display API.
> 
> Now that the need to interface two separate devices supported by two different
> drivers in two separate subsystems has been established, we need an API to do
> so. It should be noted that while that API doesn't exist in the mainline
> kernel, the need isn't limited to Renesas SoCs.
> 
> This patch set proposes one possible solution for the problem in the form of a
> new DRM object named live source. Live sources are created by drivers to model
> hardware connections between a plane input and an external source, and are
> attached to planes through the KMS userspace API.
> 
> Patch 1/5 adds live source objects to DRM, with an in-kernel API for drivers
> to register the sources, and a userspace API to enumerate them.
> 
> Patch 2/5 implements connection between live sources and planes through
> framebuffers. It introduces a new live source flag for framebuffers. When a
> framebuffer is created with that flag set, a live source is associated with
> the framebuffer instead of buffer objects. The framebuffer can then be used
> with a plane to connect it with the live source. This is the biggest
> difference compared to the previous approach, and has several benefits:
> 
> - Changes are less intrusive in the DRM core
> - The implementation supports both the legacy API and atomic updates without
>   any code specific to either
> - No changes to existing drivers are needed
> - The framebuffer format and size configuration API is reused
> 
> The framebuffer format and size should ideally be validated using information
> queried directly from the driver that supports the live source device, but
> I've decided not to implement such communication between V4L2 and DRM/KMS at
> the moment to keep the proposal simple.
> 
> Patches 3/5 to 5/5 then implement support for live sources in the R-Car DU
> driver. The rcar_du_live_framebuffer structure and its associated helper
> functions could be moved to the DRM core later if other drivers need a similar
> implementation. I've decided to keep them in the rcar-du driver for now as
> it's not clear yet what other drivers might need.
> 
> Once again nothing here is set in stone.

Yeah, this looks rather nice&tidy. A few questions/ideas:
- Should we also go right ahead and add live sinks here with this and
  enumerate both live sinks and sources as live resources or something
  similar? The only big difference I see is that sinks will have different
  attachment points than sources.

- Not fully sure about possible_planes. I guess if the justification is
  that the drm core can take care of some input validation for drivers
  then it's useful. But if the idea is that userspace can use this to
  figure out the routing then I think this won't work.

- Do we need other basic checks like max/min width/height? Same concern as
  above.

- I think a live_resource_create callback would be useful so that the
  driver can check additional constraints (maybe just some size will work
  if e.g. it feeds directly into an mpeg encoder). Also I think we should
  figure out whether the addfb2 call or only attaching the live
  source/sink locks down the configuration on the v4l side of things.
  Imo locking down the settings has the advantage that you can do that all
  upfront on both v4l and drm side, and then immediately start the
  pipeline with just connecting it.

- Some helper to connect the drm and v4l side of things might be useful,
  especially to make sure you don't end up with incompatible settings on
  either end. Ties in with the above question of where we want to lock
  down the settings.

- Do we need some additional properties on live sources/sinks to at least
  make the connection with v4l? Or is the idea that we'll do this with the
  media link framework (in which case another part of some helper)?

Ok that's it for first thoughts from me.
-Daniel

> 
> Laurent Pinchart (5):
>   drm: Add live source object
>   drm: Connect live source to framebuffers
>   drm/rcar-du: Add VSP1 support to the planes allocator
>   drm/rcar-du: Add VSP1 live source support
>   drm/rcar-du: Restart the DU group when a plane source changes
> 
>  drivers/gpu/drm/drm_crtc.c              | 287 +++++++++++++++++++++++++++++---
>  drivers/gpu/drm/drm_ioctl.c             |   2 +
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c  |  10 +-
>  drivers/gpu/drm/rcar-du/rcar_du_drv.c   |   6 +-
>  drivers/gpu/drm/rcar-du/rcar_du_drv.h   |   3 +
>  drivers/gpu/drm/rcar-du/rcar_du_group.c |  21 ++-
>  drivers/gpu/drm/rcar-du/rcar_du_group.h |   2 +
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c   | 132 ++++++++++++++-
>  drivers/gpu/drm/rcar-du/rcar_du_kms.h   |   3 +
>  drivers/gpu/drm/rcar-du/rcar_du_plane.c | 191 ++++++++++++++++-----
>  drivers/gpu/drm/rcar-du/rcar_du_plane.h |  11 ++
>  drivers/gpu/drm/rcar-du/rcar_du_regs.h  |   1 +
>  include/drm/drm_crtc.h                  |  35 ++++
>  include/uapi/drm/drm.h                  |   3 +
>  include/uapi/drm/drm_mode.h             |  23 +++
>  15 files changed, 647 insertions(+), 83 deletions(-)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
