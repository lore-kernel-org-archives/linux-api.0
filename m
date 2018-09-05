From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH 05/11] UAPI: coda: Don't use internal kernel structs in
 UAPI
Date: Wed, 05 Sep 2018 19:12:37 +0200
Message-ID: <1c57005277ac723ebb670a1dc847a205f0529d53.camel@opteya.com>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
         <153616291029.23468.16421004714304578585.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153616291029.23468.16421004714304578585.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, codalist@coda.cs.cmu.edu, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Le mercredi 05 septembre 2018 à 16:55 +0100, David Howells a écrit :
> The size and layout of internal kernel structures may not be relied
> upon outside of the kernel and may even change in a containerised
> environment if a container image is frozen and shifted to another
> machine.
> 
> Excise these from Coda's upc_req struct.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jan Harkes <jaharkes@cs.cmu.edu>
> cc: coda@cs.cmu.edu
> cc: codalist@coda.cs.cmu.edu
> cc: linux-fsdevel@vger.kernel.org
> ---
> 
>  include/uapi/linux/coda_psdev.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/uapi/linux/coda_psdev.h b/include/uapi/linux/coda_psdev.h
> index aa6623efd2dd..9c3acde393cd 100644
> --- a/include/uapi/linux/coda_psdev.h
> +++ b/include/uapi/linux/coda_psdev.h
> @@ -10,14 +10,18 @@
>  
>  /* messages between coda filesystem in kernel and Venus */
>  struct upc_req {
> +#ifdef __KERNEL__
>  	struct list_head    uc_chain;
> +#endif
>  	caddr_t	            uc_data;
>  	u_short	            uc_flags;
>  	u_short             uc_inSize;  /* Size is at most 5000 bytes */
>  	u_short	            uc_outSize;
>  	u_short	            uc_opcode;  /* copied from data to save lookup */
>  	int		    uc_unique;
> +#ifdef __KERNEL__
>  	wait_queue_head_t   uc_sleep;   /* process' wait queue */
> +#endif
>  };
>  

This structure should not have been exposed to userspace in the first
place: it's unusable by userspace as it is. It was incorrect to have it
outside of #ifdef __KERNEL__ before commit 607ca46e97a1b ... 

... and it's not exchanged between kernel and userspace, see
coda_psdev_write():

        struct upc_req *req = NULL;

        ...

        if (copy_from_user(req->uc_data, buf, nbytes)) {
                req->uc_flags |= CODA_REQ_ABORT;
                wake_up(&req->uc_sleep);
                retval = -EFAULT;
                goto out;
        }

Only data, a caddr_t, is read from userspace.

So the structure can be moved back to <linux/coda_psdev.h>.

>  #define CODA_REQ_ASYNC  0x1
> 

All CODA_REQ_* defines internals to kernel side and not exchanged with userspace.

Please move them back to <linux/coda_psdev.h>

Regards.

-- 
Yann Droneaud
OPTEYA
