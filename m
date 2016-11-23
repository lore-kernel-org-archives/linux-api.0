From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] fideduperange.2: fix the discussion of maximum sizes
Date: Wed, 23 Nov 2016 08:06:46 +0100
Message-ID: <5ad80a74-15c6-548c-3de9-757a5ae77de9@gmail.com>
References: <20161123044816.GG16807@birch.djwong.org>
 <20161123044941.GB27107@mew>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161123044941.GB27107@mew>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/23/2016 05:49 AM, Omar Sandoval wrote:
> On Tue, Nov 22, 2016 at 08:48:16PM -0800, Darrick J. Wong wrote:
>> Fix the discussion of the limitations on the dest_count and src_length
>> parameters to the fideduperange ioctl to reflect what's actually in the
>> kernel.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  man2/ioctl_fideduperange.2 |   20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
>> index 2112d10..057229d 100644
>> --- a/man2/ioctl_fideduperange.2
>> +++ b/man2/ioctl_fideduperange.2

[...]

> Reviewed-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>

Thanks Omar!

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
