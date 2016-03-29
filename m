From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: add RWF_(D)SYNC flag to preadv2/pwritev2
Date: Tue, 29 Mar 2016 19:37:24 +0200
Message-ID: <1459273054-13478-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add per-I/O sync flags, which are very useful for all kinds of file servers
or storage targets.  To properly do this refactor lots of direct I/O code
to not pass pointless argument, which makes the whole series a net negative
in terms of lines of code.
