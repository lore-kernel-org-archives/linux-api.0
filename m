From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend
 on request's comp_mask
Date: Thu, 5 Feb 2015 10:26:27 +0200
Message-ID: <54D32933.8080307@mellanox.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
 <20150129182800.GH11842@obsidianresearch.com>
 <1422557009.3133.172.camel@opteya.com>
 <20150129191801.GM11842@obsidianresearch.com>
 <1422564638.3133.198.camel@opteya.com>
 <20150129211256.GA22099@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0CC12C30@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E0CC12C30-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05/02/2015 04:54, Weiny, Ira wrote:
>>
>> On Thu, Jan 29, 2015 at 09:50:38PM +0100, Yann Droneaud wrote:
>>
>>> Anyway, I recognize that uverb way of abusing write() syscall is
>>> borderline (at best) regarding other Linux subsystems and Unix
>>> paradigm in general. But it's not enough to screw it more.
>>
>> Then we must return the correct output size explicitly in the struct.
> 
> I was thinking this very same thing as I read through this thread.
> 
> I too would like to avoid the use of comp_masks if at all possible.  The query call seems to be a verb where the structure size is all you really need to know the set of values returned.
> 
> As Jason says, other calls may require the comp_mask where 0 is not sufficient to indicate "missing".

Would it be okay to return it in the ib_uverbs_cmd_hdr.out_words? That
would further abuse the write() syscall by writing to the input buffer.
However, the only other alternative I see is to add it explicitly to
every uverb response struct.

Haggai
