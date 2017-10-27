From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Add /proc/PID/{smaps, numa_maps} support for DAX
Date: Fri, 27 Oct 2017 03:31:46 -0700
Message-ID: <CAPcyv4jCPE4NRGH2MmbKWbNOSZe4feVDQmJwozJBTYMRg2uqjQ@mail.gmail.com>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
 <1508891255-15427-2-git-send-email-fan.du@intel.com> <20171025093045.s3rpcuovld22bhqu@dhcp22.suse.cz>
 <1f673f36-74b0-3321-32a4-a8031d5f268a@intel.com> <20171026141604.susqkaniglc5aqw2@dhcp22.suse.cz>
 <97774073-1df0-328a-68f8-f59667bce168@intel.com> <20171026143133.7rm5wcgikjgmx4sc@dhcp22.suse.cz>
 <83cb9f0e-cd37-5355-9b03-aef9e62e7200@intel.com> <5A90DA2E42F8AE43BC4A093BF06788481AA514EA@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5A90DA2E42F8AE43BC4A093BF06788481AA514EA-0J0gbvR4kTg/UvCtAeCM4rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Du, Fan" <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hansen, Dave" <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 26, 2017 at 9:00 PM, Du, Fan <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>
>>-----Original Message-----
>>From: linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>[mailto:linux-kernel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dave Hansen
>>Sent: Thursday, October 26, 2017 10:51 PM
>>To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>Cc: Du, Fan <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org; hch-jcswGhMUV9g@public.gmane.org;
>>Williams, Dan J <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
>>linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>Subject: Re: [PATCH 2/2] Add /proc/PID/{smaps, numa_maps} support for DAX
>>
>>On 10/26/2017 07:31 AM, Michal Hocko wrote:
>>> On Thu 26-10-17 07:24:14, Dave Hansen wrote:
>>>> Actually, I don't remember whether it was tooling or just confused
>>>> humans.  I *think* Dan was trying to write test cases for huge page DAX
>>>> support and couldn't figure out whether or not it was using large pages.
>>>
>>> That sounds like a very weak justification to adding new stuff to smaps
>>> to be honest.
>>
>>Yep, agreed.  It can't go in _just_ for DAX, and Fan and the other DAX
>>folks need to elaborate on their needs here.
>
> If user creates device DAX /dev/dax with some capacity like 512G, mmap it and
> Use it will, or touched 128G. To my best knowledge at this part, there is no
> statistics reported how much memory behind DAX actually used.
>
> This is the problem our customer is facing right now.

I'm not sure I understand, DAX is statically allocated. There's no
private memory taken from the page allocator to back device-dax
mappings. Unless you are trying to determine memory usage of page
tables?
