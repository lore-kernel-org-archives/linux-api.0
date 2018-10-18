From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/3] uapi: get rid of STATX_ALL
Date: Thu, 18 Oct 2018 16:34:30 +0200
Message-ID: <CAJfpegsW27EGyCkoWMgh5V4hoyU-D3MffLq_2zDgybc66zev2g@mail.gmail.com>
References: <20181018131125.6303-1-mszeredi@redhat.com> <20181018131125.6303-2-mszeredi@redhat.com>
 <875zxzxuo9.fsf@mid.deneb.enyo.de> <CAJfpeguM-TU=nxj=T4t1DshniiEFBGq6yo+qo7Cx1QDnoNocMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpeguM-TU=nxj=T4t1DshniiEFBGq6yo+qo7Cx1QDnoNocMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 18, 2018 at 4:32 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Oct 18, 2018 at 3:15 PM, Florian Weimer <fw@deneb.enyo.de> wrote:
>> * Miklos Szeredi:
>>
>>>  #define STATX__RESERVED              0x80000000U     /* Reserved for future struct statx expansion */
>>
>> What about this?  Isn't it similar to STATX_ALL in the sense that we
>> don't know yet what it will mean?
>
> Kernel will return -EINVAL if request_mask contains STATX__RESERVED,
> so it's definitely different from other flag values.
>
> Specifying this in the UAPI sort of implies that other flag values
> will *not* need a struct statx expansion, so it's safe to pass in any
> random value not containing STATX__RESERVED on any past or future
> kernel and it will not write beyond the current struct statx boundary.
> Not sure if that's a useful thing or not, but it's not actively
> harmful, like the STATX_ALL flag.

In other words, if STATX_ALL was defined as 0x7fffffff, then that
would mean the same thing, and I wouldn't complain about it.

Thanks,
Miklos
