From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: Re: [PATCH 1/6] pkey.7: New page with overview of Memory Protection
 Keys
Date: Wed, 12 Oct 2016 09:03:13 -0700
Message-ID: <57FE5EC1.6000205@sr71.net>
References: <20160608173351.5CF7B2D3@ray> <20160608173423.A35B7734@ray>
 <ece20e5b-981d-e5c4-7b71-b1bd538c6937@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ece20e5b-981d-e5c4-7b71-b1bd538c6937-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/12/2016 01:41 AM, Florian Weimer wrote:
> On 06/08/2016 07:34 PM, Dave Hansen wrote:
>> +To use this feature, the processor must support it, and Linux
>> +must contain support for the feature on a given processor.
>> +As of early 2016 only future Intel x86 processors are supported,
>> +and this hardware supports 16 protection keys in each process.
>> +However, pkey 0 is used as the default key, so a maximum of 15
>> +are available for actual application use.
> 
> How can we reserve pkeys for use in system libraries?

We are currently in need of a centralized mechanism to track which keys
are allocated/free.  My plan is to go add one to glibc.  I'll add the
documentation to the manpages when I post this functionality.
