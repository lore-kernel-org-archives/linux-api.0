From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 00/13] [PATCH V1 for-next 00/13] IB/core:
 SG IOCTL based RDMA ABI
Date: Fri, 25 Aug 2017 13:27:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1708251325350.7025@nuc-kabylake>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com> <1501773437.117042.10.camel@redhat.com> <1503612368.78641.69.camel@redhat.com> <20170825150812.GA1027@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1891E9@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1891E9-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 25 Aug 2017, Hefty, Sean wrote:

> > I think you should wait until after plumbers.
>
> I tried to review the code and gave up.  I still find it overly complex for implementing what is conceptually a function dispatch table.

Welll this fixes a long standing major issue in the ABI. No one else is
working on it so its the only way to go. I think this ought to be merged
ASAP. If it breaks something then at least everyone is affected and will
be fixing this thing up so we can finally move beyond the rpc via file ops
issue.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
