From: Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 1/8] virtio: introduce virtio_is_little_endian()
 helper
Date: Thu, 23 Apr 2015 19:26:13 +0200
Message-ID: <20150423192613.6c58042f@thh440s>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152617.11795.13272.stgit@bahia.local>
	<20150423192215.12182311@thh440s>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150423192215.12182311@thh440s>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Thu, 23 Apr 2015 19:22:15 +0200
schrieb Thomas Huth <thuth-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:

> Am Thu, 23 Apr 2015 17:26:20 +0200
> schrieb Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>:
> 
> > Signed-off-by: Greg Kurz <gkurz-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > ---
> >  include/linux/virtio_config.h |   17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> > index ca3ed78..bd1a582 100644
> > --- a/include/linux/virtio_config.h
> > +++ b/include/linux/virtio_config.h
> > @@ -205,35 +205,40 @@ int virtqueue_set_affinity(struct virtqueue *vq, int cpu)
> >  	return 0;
> >  }
> >  
> > +static inline bool virtio_is_little_endian(struct virtio_device *vdev)
> > +{
> > +	return virtio_has_feature(vdev, VIRTIO_F_VERSION_1);
> > +}
> 
> So this function returns false when _not_ using version 1, but running
> on a little endian host + guest? Sounds confusing. Maybe you could name
> it "virtio_is_v1()" or so instead?

Ah, never mind, I should have looked at patch 6 first, then it makes
sense. (maybe you could put a note to the later patch in this patch
description?)

 Thomas
