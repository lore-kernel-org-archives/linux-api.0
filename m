From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v3] ipc: Modify message queue accounting to not take
 kernel data structures into account
Date: Wed, 08 Jul 2015 14:49:16 -0700
Message-ID: <1436392156.12255.99.camel@stgolabs.net>
References: <20150622222546.GA32432@ramsey.localdomain>
	 <1435211229.11852.23.camel@stgolabs.net>
	 <CAKgNAkieR5zdpKm=P2dcTDJ_3X4HMRoeOQ2D8yghYVKOjDsYAg@mail.gmail.com>
	 <1435256484.11852.30.camel@stgolabs.net>
	 <20150706154928.GA19828@ramsey.localdomain>
	 <1436246210.12255.71.camel@stgolabs.net>
	 <CAKgNAkjy-+2TkN=0Fe11bVea4q6uLcUx=++Mf1eFxhmPmZoc9w@mail.gmail.com>
	 <559D7760.1020909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559D7760.1020909-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Marcus Gelderie <redmnic-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, John Duffy <jb_duffy-FhtRXb7CoQBt1OO0OYaSVA@public.gmane.org>, Arto Bendiken <arto-TQ6thHYR8Svk1uMJSBkQmQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2015-07-08 at 15:17 -0400, Doug Ledford wrote:
> I responded yesterday in the v2 patch thread I believe.  In any case, I
> think this patch is fine, and can go to stable.  This patch doesn't
> actually change the math related to the rlimit checks (which is the main
> thing I wanted to correct in my original patches), instead it corrects a
> mistake I made.  At the time, I mistakenly thought that the qsize
> included the current message data total + the struct msg_msg size total.
>  It didn't, it was just the current user data total.  I added the rbtree
> nodes in order to keep the total accurate but I shouldn't have added the
> rbtree nodes to this total because none of the other kernel usage was
> previously included.

Exactly, this is what I was referring to when I suggested staying clear
from rlimit modifications. It just makes 0 sense to account for each
rbtree.

Thanks for taking a look!

> 
> Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
