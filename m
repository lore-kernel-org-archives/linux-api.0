From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v8 09/41] richacl: Update the file masks in chmod()
Date: Tue, 29 Sep 2015 01:42:03 +0200
Message-ID: <CAHc6FU4NXra9okLekNNCx3mQa4TrJhZ8eqCWQ7pBgarHRphg6Q@mail.gmail.com>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
	<1443391772-10171-10-git-send-email-agruenba@redhat.com>
	<20150928152806.GC1358@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150928152806.GC1358@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

2015-09-28 17:28 GMT+02:00 J. Bruce Fields <bfields@fieldses.org>:
> On Mon, Sep 28, 2015 at 12:09:00AM +0200, Andreas Gruenbacher wrote:
>> +         (acl->a_flags & (RICHACL_WRITE_THROUGH | RICHACL_MASKED)))
>
> I think you meant to require both of those bits to be set.

Yes, indeed.

Thanks,
Andreas
