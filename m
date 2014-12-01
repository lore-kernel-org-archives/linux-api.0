From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Date: Mon, 1 Dec 2014 14:51:26 +0200
Message-ID: <20141201125126.GB18106@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092658.GC15607@redhat.com>
	<20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
	<20141201114645.GA17505@redhat.com>
	<20141201130258.6f01c1e3.cornelia.huck@de.ibm.com>
	<20141201123455.GA17958@redhat.com>
	<20141201134036.726e7386.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20141201134036.726e7386.cornelia.huck@de.ibm.com>
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
Cc: thuth@linux.vnet.ibm.com, rusty@au1.ibm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, David Hildenbrand <dahi@linux.vnet.ibm.com>, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 01, 2014 at 01:40:36PM +0100, Cornelia Huck wrote:
> On Mon, 1 Dec 2014 14:34:55 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Mon, Dec 01, 2014 at 01:02:58PM +0100, Cornelia Huck wrote:
> > > On Mon, 1 Dec 2014 13:46:45 +0200
> > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > > > On Mon, Dec 01, 2014 at 12:33:15PM +0100, Cornelia Huck wrote:
> > > > > On Mon, 1 Dec 2014 11:26:58 +0200
> > > > > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > > 
> > > > > > For some places on data path, it might be worth it
> > > > > > to cache the correct value e.g. as part of device
> > > > > > structure. This replaces a branch with a memory load,
> > > > > > so the gain would have to be measured, best done
> > > > > > separately?
> > > > > 
> > > > > I think we'll want to do some measuring once the basic structure is
> > > > > in place anyway.
> > > > 
> > > > What's meant by in place here?
> > > 
> > > That this patchset is ready :)
> > 
> > Also it's ready to the level where benchmarking is possible, right?  I
> > don't think you should wait until we finish polishing up commit
> > messages.
> 
> My point is that I haven't even found time yet to test this
> thouroughly :(

If my experience shows anything, it's unlikely we'll get appropriate
testing without code being upstream first.
That's why I pushed on with sparse tagging btw.
This way we can be reasonably sure we didn't miss some path.

-- 
MST
