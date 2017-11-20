From: Jeff Layton <jlayton@kernel.org>
Subject: Re: Provision for filesystem specific open flags
Date: Mon, 20 Nov 2017 08:38:16 -0500
Message-ID: <1511185096.4228.8.camel@kernel.org>
References: <BN3PR0801MB2257E7D90F26A85C1D16730EAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
         <20171110172344.GA15288@lst.de>
         <BN3PR0801MB2257E71C2A12EA41C77FF7EBAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
         <20171110192902.GA10339@bombadil.infradead.org>
         <BN3PR0801MB22576444104088CEDD24DE7DAB540@BN3PR0801MB2257.namprd08.prod.outlook.com>
         <20171111003721.GA9546@bombadil.infradead.org>
         <BN3PR0801MB2257249A7388086676CBA811AB2B0@BN3PR0801MB2257.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BN3PR0801MB2257249A7388086676CBA811AB2B0@BN3PR0801MB2257.namprd08.prod.outlook.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Fu, Rodney" <rfu@panasas.com>, Matthew Wilcox <willy@infradead.org>
Cc: "hch@lst.de" <hch@lst.de>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2017-11-13 at 15:16 +0000, Fu, Rodney wrote:
> > > > No.  If you want new flags bits, make a public proposal.  Maybe some 
> > > > other filesystem would also benefit from them.
> > > 
> > > Ah, I see what you mean now, thanks.
> > > 
> > > I would like to propose O_CONCURRENT_WRITE as a new open flag.  It is 
> > > currently used in the Panasas filesystem (panfs) and defined with value:
> > > 
> > > #define O_CONCURRENT_WRITE 020000000000
> > > 
> > > This flag has been provided by panfs to HPC users via the mpich 
> > > package for well over a decade.  See:
> > > 
> > > https://github.com/pmodels/mpich/blob/master/src/mpi/romio/adio/ad_pan
> > > fs/ad_panfs_open6.c#L344
> > > 
> > > O_CONCURRENT_WRITE indicates to the filesystem that the application 
> > > doing the open is participating in a coordinated distributed manner 
> > > with other such applications, possibly running on different hosts.  
> > > This allows the panfs filesystem to delegate some of the cache 
> > > coherency responsibilities to the application, improving performance.
> > > 
> > > The reason this flag is used on open as opposed to having a post-open 
> > > ioctl or fcntl SETFL is to allow panfs to catch and reject opens by 
> > > applications that attempt to access files that have already been 
> > > opened by applications that have set O_CONCURRENT_WRITE.
> > OK, let me just check I understand.  Once any application has opened the inode
> > with O_CONCURRENT_WRITE, all subsequent attempts to open the same inode without
> > O_CONCURRENT_WRITE will fail.  Presumably also if somebody already has the inode
> > open without O_CONCURRENT_WRITE set, the first open with O_CONCURRENT_WRITE will
> > fail?
> 
> Yes on both counts.  Opening with O_CONCURRENT_WRITE, followed by an open
> without will fail.  Opening without O_CONCURRENT_WRITE followed by one with it
> will also fail.
> 
> > Are opens with O_RDONLY also blocked?
> 
> No they are not.  The decision to grant access is based solely on the
> O_CONCURRENT_WRITE flag.
> 
> > This feels a lot like leases ... maybe there's an opportunity to give better
> > semantics here -- rather than rejecting opens without O_CONCURRENT_WRITE, all
> > existing users could be forced to use the stricter coherency model?
> 
> I don't think that will work, at least not from the perspective of trying to
> maintain good performance.  A user that does not open with O_CONCURRENT_WRITE
> does not know how to adhere to the proper access patterns that maintain
> coherency.  To continue to allow all users access after that point, the
> filesystem will have to force all users into a non-cacheable mode.  Instead, we
> reject stray opens to allow any existing CONCURRENT_WRITE application to
> complete in a higher performance mode.
> 

(added linux-api@vger.kernel.org to the cc list...)

Actually, it feels more like O_EXLOCK / O_SHLOCK to me:

    https://www.gnu.org/software/libc/manual/html_node/Open_002dtime-Flags.html

Those are not quite the same semantics as what you're describing for
O_CONCURRENT_WRITE, but the handling of conflicts would be similar. 

Maybe it's possible to dovetail your new flag on top of a credible
O_EXLOCK/O_SHLOCK implementation? It'd be nice to have those to
implement VFS-level share/deny locking. Most NFS and SMB servers could
make good use of it.


-- 
Jeff Layton <jlayton@kernel.org>
