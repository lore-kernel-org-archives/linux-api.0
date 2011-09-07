From: Paul Clements <paul.clements-eviPjrN/1CxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/3] nbd: add support for feature negotiation
Date: Wed, 7 Sep 2011 17:54:01 -0400
Message-ID: <CAECXXi6NO1gvmREr_31ve-k67fsirqerdm7=ZX0tYqx+Yj52Sw@mail.gmail.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
	<1315406503-7883-3-git-send-email-pbonzini@redhat.com>
	<CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com>
	<4E67AF6A.9090400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <4E67AF6A.9090400-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=nbd-general>
List-Post: <mailto:nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/nbd-general>,
	<mailto:nbd-general-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: nbd-general-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: nbd-general-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 7, 2011 at 1:52 PM, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 09/07/2011 06:30 PM, Paul Clements wrote:
>>
>> Could you name this as NBD_SET_FLAGS, as that's more consistent with
>> what it's really doing?
>
> I named it differently intentionally, actually, because it should not use
> the flags field from the network protocol as is. =A0Also, "features" soun=
ds
> more like something that is optional, while unrecognized "flags" should
> probably cause a failure.

Alright, I can buy that argument -- I don't feel that strongly about it...

This looks good to me, then.

--
Paul

---------------------------------------------------------------------------=
---
Using storage to extend the benefits of virtualization and iSCSI
Virtualization increases hardware utilization and delivers a new level of
agility. Learn what those decisions are and how to modernize your storage =

and backup environments for virtualization.
http://www.accelacomm.com/jaw/sfnl/114/51434361/
