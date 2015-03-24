From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] Add virtio-input driver.
Date: Tue, 24 Mar 2015 11:26:50 +0100
Message-ID: <1427192810.18768.4.camel@nilsson.home.kraxel.org>
References: <1427182321-19451-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427182321-19451-1-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org
Cc: virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  Hi,

> +static void virtinput_cfg_abs(struct virtio_input *vi, int abs)
> +{
> +	u32 mi, ma, re, fu, fl;
> +
> +	virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.res, &re);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
> +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
> +	input_set_abs_params(vi->idev, abs, mi, ma, fu, fl);
> +	input_abs_set_res(vi->idev, abs, re);
> +}

> +struct virtio_input_absinfo {
> +	__virtio32  min;
> +	__virtio32  max;
> +	__virtio32  fuzz;
> +	__virtio32  flat;
> +	__virtio32  res;
> +};

Damn, had sparse disabled for the test builds.  [ Too bad there are way
too many warnings on a full kernel build so having sparse enabled all
the time doesn't fly. ]

So this doesn't work either.

Hmm, back to using "u32" in the virtio config structs?

cheers,
  Gerd
