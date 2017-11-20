From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Provision for filesystem specific open flags
Date: Mon, 20 Nov 2017 08:53:41 -0500
Message-ID: <1511186021.4228.20.camel@kernel.org>
References: <BN3PR0801MB2257E7D90F26A85C1D16730EAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
         <20171110172344.GA15288@lst.de>
         <BN3PR0801MB2257E71C2A12EA41C77FF7EBAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
         <20171110192902.GA10339@bombadil.infradead.org>
         <BN3PR0801MB22576444104088CEDD24DE7DAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
         <20171113004855.GV4094@dastard>
         <BN3PR0801MB225771FD9BBD14A99A9358F7AB2B0@BN3PR0801MB2257.namprd08.prod.outlook.com>
         <20171113215847.GY4094@dastard>
         <BN3PR0801MB2257BBAA9D7CA6CEDCA04DECAB280@BN3PR0801MB2257.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR0801MB2257BBAA9D7CA6CEDCA04DECAB280-1I06WyKSH1RpbkYrVjfdjVJr2SjL+wq6nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Fu, Rodney" <rfu-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2017-11-14 at 17:35 +0000, Fu, Rodney wrote:
> > The filesystem can still choose to do that for O_DIRECT if it wants - look at
> > all the filesystems that have a "fall back to buffered IO because this is too
> > hard to implement in the direct Io path".
> 
> Yes, I agree that the filesystem can still decide to buffer IO even with
> O_DIRECT, but the application's intent is that the effects of caching are
> minimized.  Whereas with O_CONCURRENT_WRITE, the intent is to maximize caching.
> 
> > IOWs, you've got another set of custom userspace APIs that are needed to make
> > proper use of this open flag?
> 
> Yes and no.  Applications can make ioctls to the filesystem to query or set
> layout details but don't have to.  Directory level default layout attributes can
> be set up by an admin to meet the requirements of the application.
> 
> > > In panfs, a well behaved CONCURRENT_WRITE application will consider 
> > > the file's layout on storage.  Access from different machines will not 
> > > overlap within the same RAID stripe so as not to cause distributed 
> > > stripe lock contention.  Writes to the file that are page aligned can 
> > > be cached and the filesystem can aggregate multiple such writes before 
> > > writing out to storage.  Conversely, a CONCURRENT_WRITE application 
> > > that ends up colliding on the same stripe will see worse performance.  
> > > Non page aligned writes are treated by panfs as write-through and 
> > > non-cachable, as the filesystem will have to assume that the region of 
> > > the page that is untouched by this machine might in fact be written to 
> > > on another machine.  Caching such a page and writing it out later might lead to data corruption.
> > That seems to fit the expected behaviour of O_DIRECT pretty damn closely - if
> > the app doesn't do correctly aligned and sized IO then performance is going to
> > suck, and if the apps doesn't serialize access to the file correctly it can and
> > will corrupt data in the file....
> 
> I make the same case as above, that O_DIRECT and O_CONCURRENT_WRITE have
> opposite intents with respect to caching.  Our filesystem handles them
> differently, so we need to distinguish between the two.
> 
> > > The benefit of CONCURRENT_WRITE is that unlike O_DIRECT, the 
> > > application does not have to implement any caching to see good performance.
> > Sure, but it has to be aware of layout and where/how it can write, which is
> > exactly the same constraints that local filesystems place on O_DIRECT access.
> > Not convinced. The use case fits pretty neatly into expected O_DIRECT semantics
> > and behaviour, IMO.
> 
> I'd like to make a slight adjustment to my proposal.  The HPC community had
> talked about extensions to POSIX to include O_LAZY as a way for filesystems to
> relax data coherency requirements.  There is code in the ceph filesystem that
> uses that flag if defined.  Can we get O_LAZY defined?
> 
> HEC POSIX extension:
> http://www.pdsw.org/pdsw06/resources/hec-posix-extensions-sc2006-workshop.pdf
> 
> Ceph usage of O_LAZY:
> https://github.com/ceph/ceph-client/blob/1e37f2f84680fa7f8394fd444b6928e334495ccc/net/ceph/ceph_fs.c#L78


O_LAZY support was removed from cephfs userland client in 2013:

    commit 94afedf02d07ad4678222aa66289a74b87768810
    Author: Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>
    Date:   Mon Jul 8 11:24:48 2013 -0700

        client: remove O_LAZY

...part of the problem (and this may just be my lack of understanding)
is that it's not clear what O_LAZY semantics actually are. The ceph
sources have a textfile with this in it:

"-- lazy i/o integrity

  FIXME: currently missing call to flag an Fd/file has lazy.  used to be
O_LAZY on open, but no more.

  * relax data coherency
  * writes may not be visible until lazyio_propagate, fsync, close

  lazyio_propagate(int fd, off_t offset, size_t count);
   * my writes are safe

  lazyio_synchronize(int fd, off_t offset, size_t count);
   * i will see everyone else's propagated writes


lazyio_propagate / lazyio_synchronize. Those seem like they could be
implemented as ioctls if you don't care about other filesystems.

It is possible to add new open flags (we're running low, but that's a
problem we'll hit sooner or later anyway), but before we can do anything
here, O_LAZY needs to be defined in a way that makes sense for
application developers across filesystems.

How does this change behavior on ext4, xfs or btrfs, for instance? What
about nfs or cifs?

I suggest that before you even dive into writing patches for any of
this, that you draft a small manpage update for open(2). What would an
O_LAZY entry look like?

-- 
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
