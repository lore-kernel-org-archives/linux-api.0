From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3] Add virtio-input driver.
Date: Tue, 24 Mar 2015 11:48:02 +0100
Message-ID: <20150324114254-mutt-send-email-mst@redhat.com>
References: <1427182321-19451-1-git-send-email-kraxel@redhat.com>
	<1427192810.18768.4.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1427192810.18768.4.camel@nilsson.home.kraxel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 11:26:50AM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > +static void virtinput_cfg_abs(struct virtio_input *vi, int abs)
> > +{
> > +	u32 mi, ma, re, fu, fl;
> > +
> > +	virtinput_cfg_select(vi, VIRTIO_INPUT_CFG_ABS_INFO, abs);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.min, &mi);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.max, &ma);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.res, &re);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.fuzz, &fu);
> > +	virtio_cread(vi->vdev, struct virtio_input_config, u.abs.flat, &fl);
> > +	input_set_abs_params(vi->idev, abs, mi, ma, fu, fl);
> > +	input_abs_set_res(vi->idev, abs, re);
> > +}
> 
> > +struct virtio_input_absinfo {
> > +	__virtio32  min;
> > +	__virtio32  max;
> > +	__virtio32  fuzz;
> > +	__virtio32  flat;
> > +	__virtio32  res;
> > +};
> 
> Damn, had sparse disabled for the test builds.  [ Too bad there are way
> too many warnings on a full kernel build so having sparse enabled all
> the time doesn't fly. ]
> 
> So this doesn't work either.
> 
> Hmm, back to using "u32" in the virtio config structs?
> 
> cheers,
>   Gerd
> 

You are right, I was confused. Currently everyone uses simple
__u32 and friends in config structs, under the understanding
that they are always accessed using virtio_cread and friends.

Maybe I'll look into adding more type safety, but the
issue is not virtio-input specific so, let's not
defer virtio input because of this.

Sorry about wasting your time on this.

-- 
MST
