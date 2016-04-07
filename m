From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: add RWF_(D)SYNC flag to preadv2/pwritev2 V2
Date: Thu,  7 Apr 2016 08:51:54 -0700
Message-ID: <1460044324-5298-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add per-I/O sync flags, which are very useful for all kinds of file servers
or storage targets.  To properly do this refactor lots of direct I/O code
to not pass pointless argument, which makes the whole series a net negative
in terms of lines of code.

Changes since V1:
 - fix RWF_SYNC defintion
 - fix a comment
