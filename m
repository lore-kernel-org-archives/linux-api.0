From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Fri, 11 Mar 2016 09:07:57 -0500
Message-ID: <20160311140757.GB13178@fieldses.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20160311140134.GA14808@infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 06:01:34AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 29, 2016 at 09:17:05AM +0100, Andreas Gruenbacher wrote:
> > Al,
> > 
> > could you please make sure you are happy with the current version of the
> > richacl patch queue for the next merge window?
> 
> I'm still not happy.
> 
> For one I still see no reason to merge this broken ACL model at all.
> It provides our actualy Linux users no benefit at all, while breaking
> a lot of assumptions, especially by adding allow and deny ACE at the
> same sime.

Could you explain what you mean by "adding allow and deny ACE at the
same time"?

> It also doesn't help with the issue that the main thing it's trying
> to be compatible with (Windows) actually uses a fundamentally different
> identifier to apply the ACLs to - as long as you're still limited
> to users and groups and not guids we'll still have that mapping problem
> anyway.

Agreed, but, one step at a time?  My impression is that the Samba people
still consider this a step forward for Linux compatibility.

--b.

> 
> But besides that fundamental question on the purpose of it I also
> don't think the code is suitable, more in the individual patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
