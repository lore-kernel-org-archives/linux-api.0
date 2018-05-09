From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2] fs: hoist BTRFS_IOC_[SG]ET_FSLABEL to vfs
Date: Wed, 9 May 2018 23:35:04 +0200
Message-ID: <20180509213504.GC6649@twin.jikos.cz>
References: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
 <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b8c7feca-68ce-b1a8-3a96-a99b50457a84@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 09, 2018 at 11:01:21AM -0500, Eric Sandeen wrote:
> Move the btrfs label ioctls up to the vfs for general use.
> 
> This retains 256 chars as the maximum size through the interface, which
> is the btrfs limit and AFAIK exceeds any other filesystem's maximum
> label size.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

The btrfs changes and new ioctl naming looks good to me,

Reviewed-by: David Sterba <dsterba@suse.com>
