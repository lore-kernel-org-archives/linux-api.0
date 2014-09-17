From: Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Tue, 16 Sep 2014 17:21:27 -0700
Message-ID: <CABgu+=Na7A5amf_=QACrkgAAccf_VUaZMPJtzXb4K3D0FEasBw@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<8738brhzoc.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8738brhzoc.fsf-KWJ+5VKanrL29G5dvP0v1laTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 16, 2014 at 5:13 PM, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:
> Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
>
> Perhaps I'm missing something, but how do you modify the AUX vector
> for the children?
>
>> +config VDSO_DISABLE_PRCTL
>> +     depends on X86
>> +     bool "prctl to disable VDSO loading"
>> +     ---help---
>> +       Enabling this option adds support for prctl calls that
>> +       set and retrieve a per-process flag to disable VDSO loading on
>> +       exec() for this process and all of its children.
>
> I don't think it makes any sense to have a config for a simple
> feature like this. Just do it unconditionally.
>
> -Andi
>
> --
> ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

The AUX vector issue is a mistake on my part.

Speaking of mistakes, the IDs in the commit message do not match those
in the patch itself.  That needs to be fixed, too.

Point taken about the config.  I'll remove it in the next version of the patch.

Thanks for the feedback.
