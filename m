From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Tue, 15 Mar 2016 00:09:10 -0700
Message-ID: <20160315070910.GA19747@infradead.org>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
 <20160311140134.GA14808@infradead.org>
 <20160311140757.GB13178@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160311140757.GB13178@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 09:07:57AM -0500, J. Bruce Fields wrote:
> Could you explain what you mean by "adding allow and deny ACE at the
> same time"?

NFSv4/rich ACLs have both ALLOW and DENY ACE, which is contrary to
the model how we've operated since the dawn of time.
