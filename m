From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 00/13] [PATCH V1 for-next 00/13] IB/core:
 SG IOCTL based RDMA ABI
Date: Thu, 31 Aug 2017 09:44:53 -0400
Message-ID: <1504187093.109926.24.camel@redhat.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
         <1501773437.117042.10.camel@redhat.com>
         <1503612368.78641.69.camel@redhat.com>
         <20170825150812.GA1027@obsidianresearch.com>
         <1828884A29C6694DAF28B7E6B8A82373AB1891E9@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB1891E9-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2017-08-25 at 17:20 +0000, Hefty, Sean wrote:
> > > This has now been on the linux-api mailing list for 21 days with
> > > no
> > > objections.  I very well may take this into my for-next branch,
> > > so
> > > should anyone want to look at this before hand, now is the time.
> > > Thanks.
> > 
> > I think you should wait until after plumbers.
> 
> I tried to review the code and gave up.  I still find it overly
> complex for implementing what is conceptually a function dispatch
> table.

Maybe, but it's encased in a Kconfig item that marks it experimental,
so including it doesn't freeze it in stone.  As such, I took it because
we really need to make progress on this and not just keep pushing it on
out.  Now is the time to focus and raise objections, send fixes, etc. 
Otherwise it'll be what it'll be.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
