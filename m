From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] driver: add PPI support in tpm driver
Date: Tue, 12 Jun 2012 12:00:38 -0700
Message-ID: <4FD791D6.5050503@zytor.com>
References: <953B7F5DA8C0F44CBD2621D8763F4F6005F79F@SHSMSX101.ccr.corp.intel.com> <CAM0nabHV6CepQyXeVZiv2XT9WHPgMy=prdK-8fNgyrCZ4v6dSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAM0nabHV6CepQyXeVZiv2XT9WHPgMy=prdK-8fNgyrCZ4v6dSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Yoder <shpedoikal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Zhang, Xiaoyan" <xiaoyan.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <debora-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <srajiv-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org" <m.selhorst-iBygD9l97zzQT0dZR+AlfA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Cihula, Joseph" <joseph.cihula-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wei, Gang" <gang.wei-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/12/2012 11:57 AM, Kent Yoder wrote:
> 
>   This code looks clean - my only suggestion would be to add an #ifdef
> CONFIG_ACPI around it so it compiles out on ppc.
> 

Better yet, any way to separate it out in a separate source file?

	-hpa
