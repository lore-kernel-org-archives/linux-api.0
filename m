From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
Date: Fri, 16 Oct 2015 19:41:30 +0200
Message-ID: <CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <5621346E.5000500@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> I would like to re-iterate, on both XFS and ext4, I _really_ think this
> should be a ro_compat flag, and not an incompat one.  If a person has the
> ability to mount the FS (even if it's a read-only mount), then they by
> definition have read access to the file or partition that the filesystem is
> contained in, which means that any ACL's stored on the filesystem are
> functionally irrelevant,

It is unfortunately not safe to make such a file system accessible to
other users, so the feature is not strictly read-only compatible.

Andreas
