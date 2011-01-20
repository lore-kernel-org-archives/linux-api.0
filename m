From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Thu, 20 Jan 2011 10:48:33 +0800
Message-ID: <1295491713.1949.898.camel@sli10-conroe>
References: <1295399718.1949.864.camel@sli10-conroe>
	 <20110119124158.b0348c44.akpm@linux-foundation.org>
	 <1295490647.1949.890.camel@sli10-conroe>
	 <20110119184240.b0a6a016.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110119184240.b0a6a016.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-20 at 10:42 +0800, Andrew Morton wrote:
> On Thu, 20 Jan 2011 10:30:47 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > > I don't know if this is worth addressing.  Perhaps require that the
> > > filp refers to the root of the fs?
> > I didn't see why this is needed, but I can limit the fip to the root of
> > the fs.
> 
> I don't think it matters much either.  The only problem I can see is if
> we were to later try to extend the ioctl into a per-file thing.
since we return page range, a metadata page might be shared by several
files, which makes the per-file thing doesn't work. For a fs using
trees, it's even more hard to distinguish a file's metadata

> > > Also, is this a privileged operation?  If not, then that might be a
> > > problem - could it be used by unprivileged users to work out which
> > > files have been opened recently or something like that?
> > it's harmless even a unprivileged user uses it. I don't think
> > unprivileged user can decode the data returned from the ioctl.
> 
> um.
> 
> Well, by doing a before-and-after thing I can use this ioctl to work
> out what metadata blocks are used when someone reads
> /my/super/secret-directory/foo.  Then I can write a program which sits
> there waiting until someone else reads /my/super/secret-directory/foo. 
> Then I can use that information to start WWIII or something.
> 
> I dunno, strange things happen.  Unless there's a good *need* to make
> this available to unprivileged users then we should not do so.
ok, looks interesting, I'll update the patch to limit unprivileged
users.

Thanks,
Shaohua

