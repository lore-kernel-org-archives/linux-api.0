From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 00/13] [PATCH V1 for-next 00/13] IB/core: SG
 IOCTL based RDMA ABI
Date: Sun, 27 Aug 2017 11:00:10 +0300
Message-ID: <e74f6753-24ef-7dca-eefe-6a2b1fc26865@mellanox.com>
References: <1501765627-104860-1-git-send-email-matanb@mellanox.com>
 <1501773437.117042.10.camel@redhat.com>
 <1503612368.78641.69.camel@redhat.com>
 <20170825150812.GA1027@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB1891E9@ORSMSX109.amr.corp.intel.com>
 <alpine.DEB.2.20.1708251325350.7025@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1708251325350.7025@nuc-kabylake>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yaron Gepstein <yarong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 25/08/2017 21:27, Christopher Lameter wrote:
> On Fri, 25 Aug 2017, Hefty, Sean wrote:
>
>>> I think you should wait until after plumbers.
>>
>> I tried to review the code and gave up.  I still find it overly complex for implementing what is conceptually a function dispatch table.
>

Every such an API could be defined as a way to trigger operations 
(functions) from user-space to kernel....
It doesn't necessarily mean that when you take all requirements into 
account it falls into a simple "function dispatch table" (i.e. netlink).

We all know the current uverbs design isn't flexible enough - hfi1 went 
and implemented its own ABI and didn't use the RDMA subsystem default 
one.... The goal of all of this is to have a suitable interface between 
user-space and kernel that fits all the required RDMA consumers and 
user-space drivers. This is mandatory giving the new fabrics and 
features added lately to this subsystem.

Anyway, we established the concepts in the RDMA mailing list, linux 
plumbers, OFVWG and OFA. There were a lot of RFC rounds. V0 of the 
patches got comments, which are fixed here.

> Welll this fixes a long standing major issue in the ABI. No one else is
> working on it so its the only way to go. I think this ought to be merged
> ASAP. If it breaks something then at least everyone is affected and will
> be fixing this thing up so we can finally move beyond the rpc via file ops
> issue.
>
>

I totally agree. Most of the involved people attended at least some of 
the conferences/meetings. The patches and RFCs exist in the ML for a 
long time. It shouldn't break anything as currently it's just an 
experimental interface along what we have now, but it'll allow people to 
start test this infrastructure, port verbs and write new features.
