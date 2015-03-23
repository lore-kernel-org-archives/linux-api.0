From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Mon, 23 Mar 2015 15:27:35 +0100
Message-ID: <1427120855.27137.55.camel@nilsson.home.kraxel.org>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	<1426756391-26585-2-git-send-email-kraxel@redhat.com>
	<20150319123940-mutt-send-email-mst@redhat.com>
	<1426847327.32097.60.camel@nilsson.home.kraxel.org>
	<20150321225356-mutt-send-email-mst@redhat.com>
	<1427097238.6365.27.camel@nilsson.home.kraxel.org>
	<1427118292.27137.39.camel@nilsson.home.kraxel.org>
	<20150323144803-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150323144803-mutt-send-email-mst@redhat.com>
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
Cc: virtio-dev@lists.oasis-open.org, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

  Hi,

> > > > You are doing leXXX everywhere, that's VERSION_1 dependency.
> > > > virtio_cread will do byteswaps differently without VERSION_1.
> > > > Just don't go there.

> So to clarify, you dislike using __virtio32 in virtio input header?

Well, as I understand things __virtio32 implies byteorder depends on
whenever we are using VERSION_1 or not.  And non-transitional drivers
should not need it as everything is by definition little endian.

So, yes, your suggestion to just require VERSION_1 in the driver implies
in my eyes that there should be no reason to use __virtio32 instead of
__le32.

Or do I miss something here?

cheers,
  Gerd
