From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Tue, 15 Mar 2016 00:14:39 -0700
Message-ID: <20160315071439.GE19747@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
	<CAH2r5mv3OTmPOQBV7xc-uZmB0gWxykXOCEVOcybx3tbHiViTZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <CAH2r5mv3OTmPOQBV7xc-uZmB0gWxykXOCEVOcybx3tbHiViTZg@mail.gmail.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Steve French <smfrench@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 02:05:16PM -0600, Steve French wrote:
> A loosely related question is what can be done for tools around existing
> interfaces for ACLs.  I recently found out NTFS-3g has this xattr:
> 
>     static const char nf_ns_xattr_ntfs_acl[] = "system.ntfs_acl";
> 
> which allows you to query system.ntfs_acl xattr to get their full ACL

Bah.  Filesystems really have no business exposing random system xattrs,
and we really need to add a filter to fs/xattr.c to not expose
arbitrary attrs ouside the user.* prefix.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
