From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [patch] MAINTAINERS: trim the file triggers for ABI/API
Date: Thu, 4 Feb 2016 07:34:15 -0800
Message-ID: <20160204153415.GB6066@x>
References: <56B35A9F.1080303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B35A9F.1080303@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Shuah Khan <shuahkh@osg.samsung.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 04, 2016 at 03:05:19PM +0100, Michael Kerrisk (man-pages) wrote:
> Josh Tripplett's commit ea8f8fc8631d9f890580a94d57a18bfeb827fa2e

s/Tripplett/Triplett/

> was well intentioned (I even Acked it), but in practice it has mostly
> generated (a lot of) useless noise on linux-api as developers of
> drivers and implementers of other uninteresting changes run
> scripts/get-maintainers.pl and unthinkingly paste the results
> into their email clients. And that commit didn't really
> help catch the really important API changes (new system calls,
> new options to existing system calls, new pseudofile entries,
> and so on). So, trim the 'F:' triggers for the "ABI/API" entry
> in MAINTAINERS right back to the minimum.

This change makes sense, but I don't think this commit message explains
the specific changes to the file triggers.  (Also, there's a convention
for referencing past commits.)  Might I suggest an alternate commit
message?

"""
Commit ea8f8fc8631 ("MAINTAINERS: add linux-api for review of API/ABI
changes") added file triggers for various paths that likely indicated
API/ABI changes.  However, catching all changes in Documentation/ABI/
and include/uapi/ produces a large volume of mail to linux-api, rather
than only API/ABI changes.  Drop those two entries, but leave
include/linux/syscalls.h and kernel/sys_ni.c to catch syscall-related
changes.
"""

> Signed-off-by: Michael Kerrisk <mtk.man-pages@gmail.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f678c37..56f7a4f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -223,9 +223,7 @@ F:  drivers/scsi/aacraid/
> 
>  ABI/API
>  L:     linux-api@vger.kernel.org
> -F:     Documentation/ABI/
>  F:     include/linux/syscalls.h
> -F:     include/uapi/
>  F:     kernel/sys_ni.c
> 
>  ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
> -- 
> 2.5.0
