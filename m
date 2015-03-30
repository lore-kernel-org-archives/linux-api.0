From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: fix definition of the
 DRM_IOCTL_I915_GET_SPRITE_COLORKEY ioctl
Date: Mon, 30 Mar 2015 08:54:55 +0200
Message-ID: <20150330065455.GG23521@phenom.ffwll.local>
References: <1427399236-14012-1-git-send-email-tt.rantala@gmail.com>
 <87a8yzq6yr.fsf@intel.com>
 <20150327080427.GB23521@phenom.ffwll.local>
 <551574C4.6000804@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <551574C4.6000804-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jesse Barnes <jesse.barnes-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tommi Rantala <tt.rantala-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Vetter <daniel.vetter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Mar 27, 2015 at 08:18:28AM -0700, Jesse Barnes wrote:
> On 03/27/2015 01:04 AM, Daniel Vetter wrote:
> > On Fri, Mar 27, 2015 at 08:39:56AM +0200, Jani Nikula wrote:
> >> On Thu, 26 Mar 2015, Tommi Rantala <tt.rantala-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>> Fix definition of the DRM_IOCTL_I915_GET_SPRITE_COLORKEY ioctl, so that it
> >>> is different from the DRM_IOCTL_I915_SET_SPRITE_COLORKEY ioctl.
> >>>
> >>> Signed-off-by: Tommi Rantala <tt.rantala-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Whoa. Broken since its introduction in
> >>
> >> commit 8ea30864229e54b01ac0e9fe88c4b733a940ec4e
> >> Author: Jesse Barnes <jbarnes-Y1mF5jBUw70BENJcbMCuUQ@public.gmane.org>
> >> Date:   Tue Jan 3 08:05:39 2012 -0800
> >>
> >>     drm/i915: add color key support v4
> >>
> >> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > 
> > Nope, we'll just rip it out and replace it all with the drm_noop ioctl. At
> > least I didn't find any userspace anywhere and only broken definitions.
> > Proof enough this isn't useful.
> > 
> > Even more so since that means we don't have to convert the get ioctl over
> > to atomic, yay! I'll send patches.
> 
> Can we just skip the noop part and delete it altogether?  It was only
> added speculatively and obviously never used at all...

The table is indexed, we need a dummy entry. I guess we could do a
drm_invalid_ioctl function too for these, but then whether you get an
error or not doesn't really matter for unused ioctls. Hence I've stuck
with drm_noop for all these removed ioctl (except when we need a more
tailore-made lie to keep userspace happy).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
