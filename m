From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: Does anyone know when FUTEX_WAIT can fail with EAGAIN?
Date: Sun, 17 Aug 2014 08:48:00 -0700
Message-ID: <1408290480.3306.17.camel@buesod1.americas.hpqcorp.net>
References: <fb82d1d46d8f.53d8186c@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fb82d1d46d8f.53d8186c-BTv7Ps/Sm75C8prJL3GQQw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk-ASgREoAs3yw@public.gmane.org, davidlohr-VXdhtT5mjnY@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-07-29 at 21:55 +0000, Steven Stewart-Gallus wrote:
> Hello,
> 
> I'm trying to debug a hangup where my program loops with FUTEX_WAIT (actually
> FUTEX_WAIT_PRIVATE but same thing)  endlessly erring out with EAGAIN. I would
> like to know if anyone on the mailing list knows when FUTEX_WAIT can fail with
> EAGAIN.

You're probably running into the EWOULDBLOCK return -- which on Linux is
just another name for EAGAIN. So if you didn't know this, and were
reading the code related to FUTEX_WAIT, you'd get mislead by this.

The check is there to avoid userspace misusing futexes and screwing up
applications. When the futex_wait() call is issued, a lot can happen in
the kernel before the task is blocked (key hashing, reference counting,
acquire internal spinlock, etc.). At any point while preparing to block,
another userspace thread could have changed the futex value, and thus
the condition for which futex_wait() call was issued in the first place
might no longer be true.

Thanks,
Davidlohr
