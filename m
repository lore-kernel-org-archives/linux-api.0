From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 5/9] vfs: Copy shouldn't forbid ranges inside the same
 file
Date: Wed, 14 Oct 2015 14:27:54 -0400
Message-ID: <561E9EAA.5000808@Netapp.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-6-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142233.GC31867@infradead.org> <561E92C9.7040205@Netapp.com>
 <20151014182523.GA31225@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014182523.GA31225-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/14/2015 02:25 PM, Christoph Hellwig wrote:
> On Wed, Oct 14, 2015 at 01:37:13PM -0400, Anna Schumaker wrote:
>> I would have folded this and patch 4 earlier if I had written patch 1,
>> but I didn't feel comfortable modifying Zach's work too much.  I can
>> make that change if it's not really a problem.
> 
> Folding the changes is perfectly fine, just make it clear you changed
> it, e.g.
> 
> Signed-off-by: Original Author <original-/77Cqtjy9Dqh6J55Ss3d3w@public.gmane.org>
> [anna: fixed foo & bar, rewrote changelog]
> Signed-off-by: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
> 

Okay, I'll do that.  Thanks!

Anna
