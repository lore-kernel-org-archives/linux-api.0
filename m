From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v27 02/21] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
 permission flags
Date: Mon, 13 Feb 2017 16:34:53 +0100
Message-ID: <CAHc6FU5yqwpa-=G3eNBL11YU6k-Kk7-Scaz-ZUb7KcjtGRQK6Q@mail.gmail.com>
References: <1476190256-1677-1-git-send-email-agruenba@redhat.com>
 <1476190256-1677-3-git-send-email-agruenba@redhat.com> <CAELBmZAF7stgY3DxaeZLd2Nt+c5rTnVC_yFORGxxN1HHoctPaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAELBmZAF7stgY3DxaeZLd2Nt+c5rTnVC_yFORGxxN1HHoctPaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Miklos,

On Fri, Dec 2, 2016 at 10:22 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Oct 11, 2016 at 2:50 PM, Andreas Gruenbacher
> <agruenba@redhat.com> wrote:
>> Richacls distinguish between creating non-directories and directories. To
>> support that, add an isdir parameter to may_create(). When checking
>> inode_permission() for create permission, pass in an additional
>> MAY_CREATE_FILE or MAY_CREATE_DIR mask flag.
>>
>> Add may_replace() to allow checking for delete and create access when
>> replacing an existing file in vfs_rename().
>
> That works for plain rename, but not for RENAME_EXCHANGE: is_dir and
> new_is_dir may be different, which means we can be deleting a
> non-directory *and* creating a directory in one dir and vice versa in
> the other.

ok, I see now. Should be fixed in the latest posting from just now.

Thanks a lot,
Andreas
