From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH 2/3] uapi: get rid of STATX_ALL
Date: Thu, 18 Oct 2018 18:11:26 +0200
Message-ID: <87va5zw7yp.fsf@mid.deneb.enyo.de>
References: <20181018131125.6303-1-mszeredi@redhat.com>
        <20181018131125.6303-2-mszeredi@redhat.com>
        <CAOQ4uxiFrtphwYhDMpsiENV8zkHHKmthb7cB2T0PKU5BA_YTWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiFrtphwYhDMpsiENV8zkHHKmthb7cB2T0PKU5BA_YTWw@mail.gmail.com>
        (Amir Goldstein's message of "Thu, 18 Oct 2018 17:51:54 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>
List-Id: linux-api@vger.kernel.org

* Amir Goldstein:

> On Thu, Oct 18, 2018 at 4:11 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>>
>> Constants of the *_ALL type can be actively harmful due to the fact that
>> developers will usually fail to consider the possible effects of future
>> changes to the definition.
>>
>> Remove STATX_ALL from the uapi, while no damage has been done yet.
>>
>
> Look. When Linus says "let's see if somebody notices" and referring to ABI
> it means sooner or later someone will upgrade to newer kernel and complain
> if something breaks.
>
> But what does it mean with UAPI change?  How often do people
> re-build existing programs?  I, for one, build master for my
> testing, but never install uapi headers from master.  I just can't
> wrap my head around the backward compatibiltiy nightmare a change
> like this could create.

So it appears that people use #ifdef STATX_ALL to check for struct
statx availability.  So the backwards compatibility impact is that you
silently lose features in a consistent manner, which is very hard to
spot. 8-(

Probably not a good idea, then.
