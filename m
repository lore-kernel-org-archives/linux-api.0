From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/3] uapi: get rid of STATX_ALL
Date: Thu, 18 Oct 2018 17:51:54 +0300
Message-ID: <CAOQ4uxiFrtphwYhDMpsiENV8zkHHKmthb7cB2T0PKU5BA_YTWw@mail.gmail.com>
References: <20181018131125.6303-1-mszeredi@redhat.com> <20181018131125.6303-2-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018131125.6303-2-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, fw@deneb.enyo.de
List-Id: linux-api@vger.kernel.org

On Thu, Oct 18, 2018 at 4:11 PM Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> Constants of the *_ALL type can be actively harmful due to the fact that
> developers will usually fail to consider the possible effects of future
> changes to the definition.
>
> Remove STATX_ALL from the uapi, while no damage has been done yet.
>

Look. When Linus says "let's see if somebody notices" and referring to ABI
it means sooner or later someone will upgrade to newer kernel and complain
if something breaks.

But what does it mean with UAPI change?
How often do people re-build existing programs?
I, for one, build master for my testing, but never install uapi
headers from master.
I just can't wrap my head around the backward compatibiltiy nightmare a change
like this could create.

How about just leave  STATX_ALL in uapi header to rot forever
mark it with a "deprecated" comment and #undef it out in include/linux/stat.h,
so we can't use it in the kernel anymore.
No use experimenting with pain.

BTW, man page needs to be fixes as well, because man page promotes
STATX_ALL.

Thanks,
Amir.
