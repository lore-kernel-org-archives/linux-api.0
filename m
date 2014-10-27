From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v5 5/5] Adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface
 support for ext4
Date: Mon, 27 Oct 2014 09:09:19 +0800
Message-ID: <CAPTn0cAAbfnqYgnCEESZeY8XaK=DSGB673Srn_TVYxETG89_OQ@mail.gmail.com>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
	<1414300973-1118-6-git-send-email-lixi@ddn.com>
	<20141026215626.GC4317@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20141026215626.GC4317@dastard>
Sender: linux-ext4-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@infradead.org" <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 27, 2014 at 5:56 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Oct 26, 2014 at 01:22:53PM +0800, Li Xi wrote:
>> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
>> support for ext4. The interface is kept consistent with
>> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
>
> What you haven't mentioned is that you also changed the fsxattr
> interface structure to add functionality and new behaviours that
> isn't supported by XFS or existing applications that use the
> interface.
>
> There is no need to modify the interface *at all* for ext4 to use
> it. Fields that ext4 does not use can be zeroed on getxattr, and
> ignored on setxattr - you do not need to add new fields to say what
> fields are valid.
Sorry, I don't want to change the interfaces either. But, the problem
is that zero might be valid value for some fields. How can we
distinguish an unsupported attribute and an attribute whose value
is zero? It is common case the only part of the fields are supported.
So, for example, if we don't have valid flags, how can use space
application tell kernel which attributes should be skipped when it
tries to set only a part of atrributes?

Regards,
Li Xi
