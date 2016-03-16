From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v18 11/22] vfs: Cache base_acl objects in inodes
Date: Wed, 16 Mar 2016 23:31:38 +0100
Message-ID: <CAHc6FU54E9EnsK3H==VyK3htXMNb4pPR4jcLi1GcOF+nb4Sw+g@mail.gmail.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-12-git-send-email-agruenba@redhat.com>
	<20160311140746.GC14808@infradead.org>
	<CAHc6FU7hSDBa51mJZZZ=q3agzWXk=DZicnyuPriKHnC2Nxr8rw@mail.gmail.com>
	<20160315071256.GD19747@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20160315071256.GD19747@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>, jaegeuk@kernel.org, chao2.yu@samsung.com
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 8:12 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 11, 2016 at 05:24:45PM +0100, Andreas Gruenbacher wrote:
>> POSIX ACLs and RichACLs are different objects, with different members
>> and different algorithms operating on them. The only commonality is
>> that they are both kmalloc()ed, reference counted objects, and when an
>> inode is destroyed, both kinds of ACLs can be put in the same way,
>> avoiding an unnecessary if. What kind of common-code container beyond
>> that are you still dreaming about?
>
> We still have a main object that is simply a list of ACEs.  But if that
> doesn't work out (I suspect it should) I don't think the common base
> object is a good idea.  It just leads to a lot of crazy container_of
> calls.

There are two such container_of calls for POSIX ACLs in fs/jffs2/acl.c
[which could be replaced by get_acl()], two in fs/posix_acl.c for
POSIX ACLs, and two in fs/richacl.c for RichACLs. That's it.

> If the common object abstraction doesn't work out we'll need
> a procedural one instead that has common acl_* calls that decide what
> do to based on the file system acl flag.

I've already made such abstractions where it made sense; if you can
find more, I don't see why we shouldn't add them.

Thanks,
Andreas
