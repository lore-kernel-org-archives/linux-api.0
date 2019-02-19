From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Date: Mon, 18 Feb 2019 20:04:47 -0800
Message-ID: <20190219040447.GX12668@bombadil.infradead.org>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
 <20190217175450.psaesabv3vlzvjv4@angband.pl>
 <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Adam Borowski <kilobyte@angband.pl>, Boaz Harrosh <openosd@gmail.com>, Dave Chinner <david@fromorbit.com>, Omar Sandoval <osandov@osandov.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Feb 17, 2019 at 12:40:09PM -0800, Andy Lutomirski wrote:
> So I'm highly in favor of this patch.  If XFS wants to disallow
> writing the birth time, fine, but I think that behavior should be
> overridable.

Please, no.  We need to have consistent behaviour between at least
Linux local filesystems.  Not "Chris thinks this is a good idea,
while Dave and Ted think its a bad idea, so btrfs supports it and
XFS and ext4 disallow it".
