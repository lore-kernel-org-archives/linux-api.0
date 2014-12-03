From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH RFC 1/2] virtio_balloon: convert to virtio 1.0 endian-ness
Date: Wed, 3 Dec 2014 16:02:28 +0200
Message-ID: <20141203140228.GA12370@redhat.com>
References: <1417520617-2135-1-git-send-email-mst@redhat.com>
	<20141202193930.2b8750f7.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20141202193930.2b8750f7.cornelia.huck@de.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 02, 2014 at 07:39:30PM +0100, Cornelia Huck wrote:
> On Tue, 2 Dec 2014 13:44:06 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > balloon device is not part of virtio 1.0 spec.  Still, it's easy enough
> > to make it handle endian-ness exactly as other virtio 1.0 devices: what
> > we gain from this, is that there's no need to special-case it in virtio
> > core.
> 
> Well, the balloon is weird in a number of ways, including its always
> little-endian config space.

Hmm yes, I forgot about that.

> But I'm not quite sure the spec covers this?

The spec does not cover balloon.  It merely includes a reference section
about legacy balloon device.  What to do when that device sets VERSION_1
is really up to us.

Patchset v8 simply makes balloon tell core it's legacy_only.
This is I guess fine as far as it goes.
I was still looking for the best way that involves minimal noise
in core. This looked like the best way: change 4 lines,
and drop all special casing in core, but given the config space
endian-ness mess, I'm not sure anymore.
I guess we'll just stick to what v8 does for now.

> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/uapi/linux/virtio_balloon.h | 5 +++--
> >  drivers/virtio/virtio_balloon.c     | 4 ++--
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> > 
> 
> >  struct virtio_balloon_stat {
> > -	__u16 tag;
> > -	__u64 val;
> > +	__virtio16 tag;
> > +	__virtio64 val;
> >  } __attribute__((packed));
> 
> Would the respective fields in the spec need updating? While it is
> actually talking about legacy requirements, the fields are not
> specified as __virtio{16,64}.
> 
> Also, is changing the stat fields enough? I've not looked into balloon
> operation, but does the payload need some endianess conversion as well?
