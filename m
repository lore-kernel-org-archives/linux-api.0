From: Sowmini Varadhan <sowmini.varadhan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 23/79] rds.h: use __u8, __u16, __s16, __u32 and __s64
 from linux/types.h
Date: Thu, 15 Oct 2015 19:03:32 -0400
Message-ID: <20151015230332.GB12132@oracle.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-24-git-send-email-mikko.rapeli@iki.fi>
 <20151015110614.GL948@oracle.com>
 <20151015220025.GG6104@lakka.kapsi.fi>
 <20151015222105.GA12132@oracle.com>
 <20151015223911.GH6104@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151015223911.GH6104-dqH1CgrzRhOk/eJAJmRu5A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On (10/16/15 01:39), Mikko Rapeli wrote:
> "uint32_t vs __u32" nail is:
> https://lkml.org/lkml/2015/6/1/160

shrug. BTW, doesn't having the exported rds.h use __foo everywhere
actually end up with the result that "the kernel use the same names
as user space"

--Sowmini
