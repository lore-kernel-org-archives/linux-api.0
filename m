From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/2] hoist btrfs' label set/get ioctls to vfs, and document
Date: Wed, 9 May 2018 10:56:45 -0500
Message-ID: <d2979d75-5e45-b145-9ca5-2c315d8ead9c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: fsdevel <linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

I'm planning to add online label set/get support to xfs, and to do so
I plan to re-use the existing btrfs ioctls, BTRFS_IOC_[SG]ET_FSLABEL

We're still working out minor details on the xfs side, but I'd like to
start the conversation regarding the new more generic interface ASAP,
so here goes - patches to move the ioctls to the vfs and document them.

(Other filesystems may wish to use this interface in the future as well)

Thanks,
-Eric
