From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not depend
 on request's comp_mask
Date: Sun, 1 Feb 2015 09:39:16 +0200
Message-ID: <54CDD824.3020701@mellanox.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
 <20150129182800.GH11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129182800.GH11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 29/01/2015 20:28, Jason Gunthorpe wrote:
> On Thu, Jan 29, 2015 at 06:59:58PM +0100, Yann Droneaud wrote:
>> > -		resp.odp_caps.general_caps = attr.odp_caps.general_caps;
>> > -		resp.odp_caps.per_transport_caps.rc_odp_caps =
>> > -			attr.odp_caps.per_transport_caps.rc_odp_caps;
>> > -		resp.odp_caps.per_transport_caps.uc_odp_caps =
>> > -			attr.odp_caps.per_transport_caps.uc_odp_caps;
>> > -		resp.odp_caps.per_transport_caps.ud_odp_caps =
>> > -			attr.odp_caps.per_transport_caps.ud_odp_caps;
>> > -		resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
>> > -	}
>> > +	resp.odp_caps.general_caps = attr.odp_caps.general_caps;
>> > +	resp.odp_caps.per_transport_caps.rc_odp_caps =
>> > +		attr.odp_caps.per_transport_caps.rc_odp_caps;
>> > +	resp.odp_caps.per_transport_caps.uc_odp_caps =
>> > +		attr.odp_caps.per_transport_caps.uc_odp_caps;
>> > +	resp.odp_caps.per_transport_caps.ud_odp_caps =
>> > +		attr.odp_caps.per_transport_caps.ud_odp_caps;
>> >  #endif
>> > +	resp.comp_mask |= IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
> Not sure about this - if 0 is a valid null answer for all the _caps
> then it is fine, and the comp_mask bit should just be removed as the
> size alone should be enough.

Zero is indeed a valid answer. There the IB_ODP_SUPPORT bit in the
general_caps field that says whether or not ODP is supported in general.
The per transport capabilities are also default to not supported.

However, I think we should keep the comp_mask field for future
extensions. The current code doesn't report the size of the response to
user space, and in addition, comp_mask being a bit mask has the
advantage of allowing only part of the structure to be marked valid.

Regards,
Haggai
