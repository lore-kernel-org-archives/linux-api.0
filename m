From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] nbd: add support for feature negotiation
Date: Thu, 08 Sep 2011 09:00:37 +0200
Message-ID: <4E686815.9060901@redhat.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
	<1315406503-7883-3-git-send-email-pbonzini@redhat.com>
	<CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com>
	<4E67AF6A.9090400@redhat.com>
	<CAECXXi6NO1gvmREr_31ve-k67fsirqerdm7=ZX0tYqx+Yj52Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CAECXXi6NO1gvmREr_31ve-k67fsirqerdm7=ZX0tYqx+Yj52Sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Paul Clements <paul.clements-eviPjrN/1CxBDgjK7y7TUQ@public.gmane.org>
Cc: nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/07/2011 11:54 PM, Paul Clements wrote:
>> >  I named it differently intentionally, actually, because it should not use
>> >  the flags field from the network protocol as is.  Also, "features" sounds
>> >  more like something that is optional, while unrecognized "flags" should
>> >  probably cause a failure.
> Alright, I can buy that argument -- I don't feel that strongly about it...
>
> This looks good to me, then.

Actually no, I can do better. :)

Paolo

------------------------------------------------------------------------------
Doing More with Less: The Next Generation Virtual Desktop 
What are the key obstacles that have prevented many mid-market businesses
from deploying virtual desktops?   How do next-generation virtual desktops
provide companies an easier-to-deploy, easier-to-manage and more affordable
virtual desktop model.http://www.accelacomm.com/jaw/sfnl/114/51426474/
