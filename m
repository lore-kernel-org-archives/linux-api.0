From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH] Add virtio gpu driver.
Date: Mon, 30 May 2016 15:50:36 +0200
Message-ID: <1464616236.5179.41.camel@redhat.com>
References: <1427213239-8775-1-git-send-email-kraxel@redhat.com>
	 <20150324165057.GN1349@phenom.ffwll.local>
	 <1427718227.3372.33.camel@nilsson.home.kraxel.org>
	 <20150330144927.GN23521@phenom.ffwll.local>
	 <CAKMK7uFUNT193f5djZD6T8cgRxxnZL73yrqbupPHOd2P-+Y=pQ@mail.gmail.com>
	 <1464335302.10663.10.camel@redhat.com>
	 <20160527090313.GX27098@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160527090313.GX27098@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Vetter <daniel@ffwll.ch>
Cc: virtio-dev@lists.oasis-open.org, "Michael S. Tsirkin" <mst@redhat.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, Dave Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

  Hi,

> - add a small core function to registerr HOT_X/HOT_Y for a (cursor) plane,
>   e.g. drm_plane_register_hotspot(). That should allocate the properties
>   (if they don't exist yet) and then attach those props to the cursor. We
>   don't want those props everywhere, but only on drivers that support/need
>   them, aka virtual hw.

Hmm, why is this special to virtual hw?

>  	if (crtc->cursor) {
> -		ret = drm_mode_cursor_universal(crtc, req, file_priv);
> +		if (drm_core_check_feature(DRIVER_ATOMIC))
> +			ret = drm_mode_cursor_atomic(crtc, req, file_priv);
> +		else
> +			ret = drm_mode_cursor_universal(crtc, req, file_priv);
>  		goto out;

>   drm_mode_cursor_atomic would simply be a fusing of
>   drm_mode_cursor_universal + drm_atomic_helper_update_plane (dump all the
>   intermediate variables and store directly in the plane state), with the
>   addition of also storing hot_x/y into the plane state.

Hmm, that'll either make drm_mode_cursor_atomic a big cut+pasted
function, or need quite some refactoring to move common code into
functions callable from both drm_mode_cursor_atomic
+drm_mode_cursor_universal ...

Why attach the hotspot to the plane?  Wouldn't it make more sense to
make it a framebuffer property?

cheers,
  Gerd
