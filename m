From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Sat, 7 Feb 2015 00:52:53 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC201F7@CRSMSX101.amr.corp.intel.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
 <20150129182800.GH11842@obsidianresearch.com>
 <1422557009.3133.172.camel@opteya.com>
 <20150129191801.GM11842@obsidianresearch.com>
 <1422564638.3133.198.camel@opteya.com>
 <20150129211256.GA22099@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC12C30@CRSMSX101.amr.corp.intel.com>
 <54D32933.8080307@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D32933.8080307-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> 
> On 05/02/2015 04:54, Weiny, Ira wrote:
> >>
> >> On Thu, Jan 29, 2015 at 09:50:38PM +0100, Yann Droneaud wrote:
> >>
> >>> Anyway, I recognize that uverb way of abusing write() syscall is
> >>> borderline (at best) regarding other Linux subsystems and Unix
> >>> paradigm in general. But it's not enough to screw it more.
> >>
> >> Then we must return the correct output size explicitly in the struct.
> >
> > I was thinking this very same thing as I read through this thread.
> >
> > I too would like to avoid the use of comp_masks if at all possible.  The query
> call seems to be a verb where the structure size is all you really need to know
> the set of values returned.
> >
> > As Jason says, other calls may require the comp_mask where 0 is not
> sufficient to indicate "missing".
> 
> Would it be okay to return it in the ib_uverbs_cmd_hdr.out_words? That would
> further abuse the write() syscall by writing to the input buffer.

I don't think that is such a great idea.
 
> However, the only other alternative I see is to add it explicitly to every uverb
> response struct.
> 

I think this is the best solution.  There is a 32 bit reserved field in ib_uverbs_ex_query_device_resp.  Could we use all or part of that to be the size?

For other extended commands I'm not sure what to do.

Ira
