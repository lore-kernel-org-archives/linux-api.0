From: Azat Khuzhin <a3at.mail-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC v2 2/2] vfs: add O_NOCMTIME
Date: Sun, 17 May 2015 00:50:30 +0300
Message-ID: <20150516215030.GI11068@azat>
References: <1431725028-24071-1-git-send-email-zab@zabbo.net>
 <1431725028-24071-3-git-send-email-zab@zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431725028-24071-3-git-send-email-zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
Cc: Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, May 15, 2015 at 02:23:48PM -0700, Zach Brown wrote:
> Add a O_NOCMTIME flag which prevents inode time updates on writes and
> can greatly reduce the IO overhead of writes to allocated and
> initialized regions of files.

> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h

You may also want to resolve this:

/*
 * Don't update ctime and mtime.
 *
 * Currently a special hack for the XFS open_by_handle ioctl, but we'll
 * hopefully graduate it to a proper O_CMTIME flag supported by open(2) soon.
 */
#define FMODE_NOCMTIME      ((__force fmode_t)0x800)
