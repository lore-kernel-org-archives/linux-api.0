From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [PATCH v4 23/79] rds.h: use __u8, __u16, __s16, __u32 and __s64
 from linux/types.h
Date: Thu, 15 Oct 2015 18:21:05 -0400
Message-ID: <20151015222105.GA12132@oracle.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-24-git-send-email-mikko.rapeli@iki.fi>
 <20151015110614.GL948@oracle.com>
 <20151015220025.GG6104@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151015220025.GG6104@lakka.kapsi.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On (10/16/15 01:00), Mikko Rapeli wrote:
> 
> What kind of portability should exported userspace headers from Linux kernel
> need?
> 
> Reviews to my previous changes NACKed <stdint.h> usage and
> Documentation/CodingStyle chapter 5 says:
> 
>  (e) Types safe for use in userspace.
> 
>      In certain structures which are visible to userspace, we cannot
>      require C99 types and cannot use the 'u32' form above. Thus, we
>      use __u32 and similar types in all structures which are shared
>      with userspace.

Let's be clear: we are not talking about u32 vs __u32, we are talking
about uint32_t vs __u32 in your patch. 

I dont have the context of your "previous changes NACKed.." etc.
Why can we not require C99 types in rds.h?

Why isnt that a problem for, say, <netinet/in.h> which includes
<stdint.h>?

--Sowmini
