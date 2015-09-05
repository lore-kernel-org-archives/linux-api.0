From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH v1 0/8] VFS: In-kernel copy system call
Date: Sat, 5 Sep 2015 09:33:42 +0100
Message-ID: <20150905083342.GG22011@ZenIV.linux.org.uk>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <4B41043F-5D85-42D6-8F20-2DCC45930EF4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B41043F-5D85-42D6-8F20-2DCC45930EF4-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 04, 2015 at 04:25:27PM -0600, Andreas Dilger wrote:

> This is a bit of a surprising result, since in my testing in the
> past, copy_{to/from}_user() is a major consumer of CPU time (50%
> of a CPU core at 1GB/s).  What backing filesystem did you test on?

While we are at it, was cp(1) using read(2)/write(2) loop or was it using
something else (sendfile(2), for example)?
