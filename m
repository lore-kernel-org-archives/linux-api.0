From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v13 12/51] vfs: Cache richacl in struct inode
Date: Wed, 4 Nov 2015 23:10:43 +0100
Message-ID: <CAHc6FU7+UpYGA991zPLyzG2L5pDgkD93L7BXak-TDJT_E_E2YA@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-13-git-send-email-agruenba@redhat.com>
	<713E53A4-D073-4745-B57D-77AD07E89957@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <713E53A4-D073-4745-B57D-77AD07E89957@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Andreas,

On Wed, Nov 4, 2015 at 3:03 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>> @@ -33,7 +33,7 @@ richacl_alloc(int count, gfp_t gfp)
>>       struct richacl *acl = kzalloc(size, gfp);
>>
>>       if (acl) {
>> -             atomic_set(&acl->a_refcount, 1);
>> +             atomic_set(&acl->a_base.ba_refcount, 1);
>>               acl->a_count = count;
>>       }
>>       return acl;
>> @@ -52,7 +52,7 @@ richacl_clone(const struct richacl *acl, gfp_t gfp)
>>
>>       if (dup) {
>>               memcpy(dup, acl, size);
>> -             atomic_set(&dup->a_refcount, 1);
>> +             atomic_set(&dup->a_base.ba_refcount, 1);
>
> These two calls should be base_acl_init().

Yes. This should all be fixed in the next snapshot.

Thanks,
Andreas
