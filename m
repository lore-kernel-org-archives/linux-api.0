From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH v5] Add virtio-input driver.
Date: Sat, 28 Mar 2015 20:07:14 +0100
Message-ID: <20150328200631-mutt-send-email-mst@redhat.com>
References: <1427366965-32549-1-git-send-email-kraxel@redhat.com>
	<20150326130644-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20150326130644-mutt-send-email-mst@redhat.com>
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

On Thu, Mar 26, 2015 at 01:10:40PM +0100, Michael S. Tsirkin wrote:
> On Thu, Mar 26, 2015 at 11:49:25AM +0100, Gerd Hoffmann wrote:
> > virtio-input is basically evdev-events-over-virtio, so this driver isn't
> > much more than reading configuration from config space and forwarding
> > incoming events to the linux input layer.
> > 
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> Still a bit worried about using input.h as host/guest
> interface (can't we use some formal standard, e.g. USB HID?),
> but I'll let Rusty decide that.
> 
> Otherwise mostly looks good. One nit below.

Forgot to include:
Acked-by: Michael S. Tsirkin <mst@redhat.com>


> 
> > ---
> 
> Could you pls include changelog in the future?
> You are sending multiple versions per day and it's hard to keep up.
> 
> > +static unsigned int features[] = {
> > +	/* none */
> > +};
> 
> An empty line wouldn't hurt here about variable definition.
> 
> > +static struct virtio_device_id id_table[] = {
> > +	{ VIRTIO_ID_INPUT, VIRTIO_DEV_ANY_ID },
> > +	{ 0 },
> > +};
> 
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
