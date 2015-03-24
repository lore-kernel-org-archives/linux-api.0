From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH v3] Add virtio-input driver.
Date: Tue, 24 Mar 2015 16:25:14 +0100
Message-ID: <1427210714.18768.23.camel@nilsson.home.kraxel.org>
References: <1427182321-19451-1-git-send-email-kraxel@redhat.com>
	<20150324105829-mutt-send-email-mst@redhat.com>
	<1427197581.18768.16.camel@nilsson.home.kraxel.org>
	<20150324135908-mutt-send-email-mst@redhat.com>
	<1427204244.18768.21.camel@nilsson.home.kraxel.org>
	<20150324143839-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150324143839-mutt-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>
List-Id: linux-api@vger.kernel.org

On Di, 2015-03-24 at 15:14 +0100, Michael S. Tsirkin wrote:
> On Tue, Mar 24, 2015 at 02:37:24PM +0100, Gerd Hoffmann wrote:
> >   Hi,
> > 
> > > > input layer checks it and ignores events not supported (according to the
> > > > support bitmaps).
> > > 
> > > Right but support bitmaps come from host too, no?
> > 
> > Yes, but the driver will not set invalid bits (bitcount argument for the
> > virtinput_cfg_bits() function is the number of valid bits of the
> > specific bitmap).
> > 
> > cheers,
> >   Gerd
> > 
> > 
> > 
> 
> Question: does linux ever get such events from userspace
> as opposed to sending them to userspace?

Yes, it's possible using the userspace input driver
(CONFIG_INPUT_UINPUT)

cheers,
  Gerd
