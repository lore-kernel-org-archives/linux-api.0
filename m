From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH v8 4/4] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Tue, 10 Nov 2015 00:56:45 +0000
Message-ID: <20151110005645.GX22011@ZenIV.linux.org.uk>
References: <1446844701-848-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1446844701-848-5-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446844701-848-5-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 06, 2015 at 04:18:20PM -0500, Anna Schumaker wrote:

> I moved the rw_verify_area() calls into the fallback code since some
> filesystems can handle reflinking a large range.


Take a look at rw_verify_area() - it does a lot more than "trim down to
2Gb" - starting with "deal with mandatory locks".  LSM checks as well...

So that one is bogus, IMO.  I've no problem with fallback per se, but
rw_verify_area() should be unconditional here.  If anything, we might
add a variant that would skip the "trim down to 2Gb" and use it there,
but skipping it entirely is wrong.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
