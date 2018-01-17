From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: aio fsync revisited
Date: Wed, 17 Jan 2018 20:47:46 +0100
Message-ID: <20180117194747.1631-1-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, linux-aio-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi all,

this patch adds workqueue based fsync offload.  Version of this
patch have been floating around for a couple years, but we now
have a user with seastar used by ScyllaDB (who sponsored this
work) that really wants this in addition to the aio poll support.
More details are in the patch itself.

Because the iocb types have been defined sine day one (and probably
were supported by RHEL3) libaio already supports these calls as-is.

As the patch is on top of of the aio.c changes in the aio poll
series I've also provided a git tree:

    git://git.infradead.org/users/hch/vfs.git aio-fsync

Gitweb:

    http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/aio-fsync
