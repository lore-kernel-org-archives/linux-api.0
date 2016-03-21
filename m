From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] block: implement (some of) fallocate for block
 devices
Date: Mon, 21 Mar 2016 11:17:26 -0700
Message-ID: <20160321181726.GA10892@infradead.org>
References: <20160315194221.30093.70506.stgit@birch.djwong.org>
 <20160315194244.30093.6483.stgit@birch.djwong.org>
 <20160321153827.GA27230@infradead.org>
 <20160321175235.GA5812@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160321175235.GA5812-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shane.seymour-ZPxbGqLxI0U@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Mar 21, 2016 at 10:52:35AM -0700, Darrick J. Wong wrote:
> > I don't really understand the comment.  But I think you'd be much
> 
> I don't know of a block device primitive that corresponds to the "default"
> mode of fallocate, as documented in the manpage (i.e. mode == 0).  I agree
> that the whole thing could be simplified in the manner you point out below.

SCSI allows 'anchoring' blocks, which is pretty similar to a normal
fallocate, but we don't support anchoring blocks in Linux yet.
