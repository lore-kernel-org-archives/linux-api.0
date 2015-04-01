From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 1/6] virtio_balloon: transitional interface
Date: Wed, 1 Apr 2015 12:49:02 +0200
Message-ID: <20150401124539-mutt-send-email-mst@redhat.com>
References: <1427884468-23930-1-git-send-email-mst@redhat.com>
	<1427884468-23930-2-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1427884468-23930-2-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: virtio-dev@lists.oasis-open.org, Pawel Moll <pawel.moll@arm.com>, linux-api@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 01, 2015 at 12:35:45PM +0200, Michael S. Tsirkin wrote:
> Virtio 1.0 doesn't include a modern balloon device.
> But it's not a big change to support a transitional
> balloon device: this has the advantage of supporting
> existing drivers, transparently.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_balloon.h | 11 ++++++++--
>  drivers/virtio/virtio_balloon.c     | 43 +++++++++++++++++++++++++++++--------
>  2 files changed, 43 insertions(+), 11 deletions(-)

So all in all 32 LOC added, and 9 out of these
deal with endian-ness differences.

Seems like a small cost for guests to pay for a clean spec, no?

-- 
MST
