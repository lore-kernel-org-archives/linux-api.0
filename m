From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 13/42] virtio_blk: v1.0 support
Date: Wed, 26 Nov 2014 17:48:43 +0200
Message-ID: <20141126154843.GC10568@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-14-git-send-email-mst@redhat.com>
	<20141125185516.7570c6e7.cornelia.huck@de.ibm.com>
	<20141125214342.GE22343@redhat.com>
	<20141126164045.0e9bfadd@thinkpad-w530>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20141126164045.0e9bfadd@thinkpad-w530>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Thomas Huth <thuth@linux.vnet.ibm.com>, rusty@au1.ibm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2014 at 04:40:45PM +0100, David Hildenbrand wrote:
> > On Tue, Nov 25, 2014 at 06:55:16PM +0100, Cornelia Huck wrote:
> > > On Tue, 25 Nov 2014 18:42:18 +0200
> > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > > > Based on patch by Cornelia Huck.
> > > > 
> > > > Note: for consistency, and to avoid sparse errors,
> > > >       convert all fields, even those no longer in use
> > > >       for virtio v1.0.
> > > > 
> > > > Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>
> > > > Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
> > > > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >  include/uapi/linux/virtio_blk.h | 15 ++++-----
> > > >  drivers/block/virtio_blk.c      | 70 ++++++++++++++++++++++++-----------------
> > > >  2 files changed, 49 insertions(+), 36 deletions(-)
> > > > 
> > > 
> > > Is this sufficiently unchanged so that the original r-bs still hold?
> > 
> > You are right, I'm afraid I'll have to drop these.
> > Thomas, David, care to comment?
> 
> I've got this on my list, will try to find some spare time tomorrow!
> 
> > Even better - have the cycles to review the latest version?
> 
> Yes, will try.
> 
> > 

Thanks!
If/when you do, pls make sure to pick the latest version.
You can always get it from vhost-net branch in my tree.

I will likely post another version tomorrow: Cornelia
found a bug in virtio-scsi.


-- 
MST
