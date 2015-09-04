From: Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v1 3/8] btrfs: add .copy_file_range file operation
Date: Fri, 4 Sep 2015 17:02:31 -0400
Message-ID: <55EA06E7.9060306@fb.com>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1441397823-1203-4-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441397823-1203-4-git-send-email-Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/04/2015 04:16 PM, Anna Schumaker wrote:
> From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> This rearranges the existing COPY_RANGE ioctl implementation so that the
> .copy_file_range file operation can call the core loop that copies file
> data extent items.
>
> The extent copying loop is lifted up into its own function.  It retains
> the core btrfs error checks that should be shared.
>
> Signed-off-by: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>

This bit looks fine to me,

Reviewed-by: Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>

Thanks,

Josef
