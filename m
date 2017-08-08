From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v06 30/36] uapi rdma/rdma_user_rxe.h: include in.h and
 in6.h
Date: Tue, 8 Aug 2017 17:13:06 -0600
Message-ID: <20170808231306.GH29372@obsidianresearch.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-31-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-31-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 06, 2017 at 06:44:21PM +0200, Mikko Rapeli wrote:
> Fixes these userspace compilation errors when rdma_user_rxe.h is compiled
> alone:
> 
> rdma/rdma_user_rxe.h:59:20: error: field ???_sockaddr??? has incomplete type
>    struct sockaddr  _sockaddr;
>                     ^~~~~~~~~
> rdma/rdma_user_rxe.h:60:22: error: field ???_sockaddr_in??? has incomplete type
>    struct sockaddr_in _sockaddr_in;
>                       ^~~~~~~~~~~~
> rdma/rdma_user_rxe.h:61:23: error: field ???_sockaddr_in6??? has incomplete type
>    struct sockaddr_in6 _sockaddr_in6;
>                        ^~~~~~~~~~~~~

I'm not sure this is a good idea, linux/in.h should not be included in
userspace users of this file, 'sockaddr_in' needs to come from glibc's
'netinet/in.h' instead..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
