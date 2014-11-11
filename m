From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v6 2/4] ext4: adds project ID support
Date: Tue, 11 Nov 2014 15:34:40 +0800
Message-ID: <CAPTn0cBYOcsgVmYuhWCZnsf8=t8Hbo+d35PPbn_sUspQAurDmQ@mail.gmail.com>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com>
	<1415468619-31851-3-git-send-email-lixi@ddn.com>
	<20141111042606.GA17027@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141111042606.GA17027@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@infradead.org" <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 11, 2014 at 12:26 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Nov 09, 2014 at 01:43:37AM +0800, Li Xi wrote:
>> This patch adds a new internal field of ext4 inode to save project
>> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
>> inheriting project ID from parent directory.
>
> What would be the downside of simply always inhereiting the project ID
> from the parent directory?  I see that if the flag is not set, the
> project id will be 0 instead.  I'm not sure when that would actually
> be desirable.
>
> To the extent that the project ID is designed to implement a quota
> over a directory extent, the fact that the owner can clear the
> EXT4_PROJINHERET_FL and then arrange to have the quota charged to
> project 0 seems to me to be a bug, not a feature.
>
Yeah, if we only intend to implement quota over directories, always inheriting
project ID from parent directory is fine. But we want this to be more flexible,
thus more powerful to enable other use cases. Always inheriting project ID
from parent means inodes uner the same subtree has the same project ID,
which might limit some use cases.

For example, if the administrator wants to track the disk usages of files
which scatter under different directories yet has similar attributes (e.g.
the sizes of them are really big), they can use project quota to archive
this goal. Combining 'find' command with setting project ID is really
convenient for this use case. And obviously, it wounldn't be possible,
if we don't have a mutable EXT4_INODE_PROJINHERIT flag.

Please note that project ID can only be change by administrator,
which means even the owners of the files can't change the project IDs.
The idea behinds it is that project quota is a tool for administrators, not
for common users.

And EXT4_INODE_PROJINHERIT is introduced into Ext4 in oder to keep
compatibile with XFS too. Otherwise, they would have different semantics. ;)

Regards,
                                                - Li Xi
