From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 0/4] VFS: In-kernel copy system call
Date: Wed, 11 Nov 2015 09:00:11 -0500
Message-ID: <564349EB.7030900@Netapp.com>
References: <1447192413-15376-1-git-send-email-Anna.Schumaker@Netapp.com>
 <20151111033827.GJ22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151111033827.GJ22011-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/10/2015 10:38 PM, Al Viro wrote:
> On Tue, Nov 10, 2015 at 04:53:29PM -0500, Anna Schumaker wrote:
>> Copy system calls came up during Plumbers a while ago, mostly because several
>> filesystems (including NFS and XFS) are currently working on copy acceleration
>> implementations.  We haven't heard from Zach Brown in a while, so I volunteered
>> to push his patches upstream so individual filesystems don't need to keep
>> writing their own ioctls.
> 
> OK, taken for the next cycle.  FWIW, I'm going to toss COMPAT_SYSCALL_DEFINE
> counterpart in as well - right now it's doing only native, AFAICS.
> 

Thanks, Al!
