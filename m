From: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MIPS,prctl: add PR_[GS]ET_FP_MODE prctl options for MIPS
Date: Sun, 18 Jan 2015 13:47:57 -0800
Message-ID: <20150118214757.GU28594@NP-P-BURTON>
References: <1420719457-690-1-git-send-email-paul.burton@imgtec.com>
 <54B519B6.5040604@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54B519B6.5040604-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markos Chandras <Markos.Chandras-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Matthew Fortune <matthew.fortune-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 13, 2015 at 01:12:22PM +0000, Markos Chandras wrote:
> Hi,
> 
> I think the "MIPS,prctl" in the title should be "MIPS: prctl"

I used the comma to denote a list - that is, this change affects both
MIPS & the generic prctl code. To me your "MIPS: prctl" suggestion would
indicate that the changes are confined to arch/mips.

> I have also CC'd the LKML and the linux-api mailing lists since this
> touches the kernel ABI with the new PR_[GS]ET_FP_MODE definitions.

Thanks,
    Paul
