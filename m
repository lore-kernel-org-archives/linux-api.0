From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 5/5] nfs: don't clear STATX_ATIME from result_mask
Date: Fri, 19 Oct 2018 22:48:35 +0200
Message-ID: <CAJfpeguFe=KcahJmZire52TPppMk8amiTJFiBZuv=97bRbCj8g@mail.gmail.com>
References: <20181019122049.27121-1-mszeredi@redhat.com> <20181019122049.27121-5-mszeredi@redhat.com>
 <2ca365ec330cf918188e8c47b26e741073382d9d.camel@primarydata.com>
 <CAJfpegtq1+vZ+uXwzFs20GeSPCR9UbtqD5-fOn8ynoJUJYx25g@mail.gmail.com> <05184f29b5778563519174769c675c5f6c5b2dd3.camel@hammerspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <05184f29b5778563519174769c675c5f6c5b2dd3.camel@hammerspace.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Trond Myklebust <trondmy@hammerspace.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "amir73il@gmail.com" <amir73il@gmail.com>, "mszeredi@redhat.com" <mszeredi@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "adilger@dilger.ca" <adilger@dilger.ca>, "dhowells@redhat.com" <dhowells@redhat.com>, "fw@deneb.enyo.de" <fw@deneb.enyo.de>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 19, 2018 at 8:14 PM, Trond Myklebust
<trondmy@hammerspace.com> wrote:
> On Fri, 2018-10-19 at 19:46 +0200, Miklos Szeredi wrote:

>> How is it then that only STATX_ATIME is cleared and not the other
>> fields?
>
> It isn't just the atime. We can also fail to revalidate the ctime and
> mtime if they are not being requested by the user.
>
>>
>> Note: junk != stale.  The statx definition doesn't talk about the
>> fields being up-to-date, except for AT_STATX_FORCE_SYNC, so stale
>> attributes are okay, and do not warrant clearing the result_mask.
>>
>
> I disagree. stale == junk here, because the default of
> AT_STATX_SYNC_AS_STAT is described by the manpage as "Do  whatever
> stat(2) does." which this is not.

Ah, you are talking about this:

    /* Is the user requesting attributes that might need revalidation? */
    if (!(request_mask & (STATX_MODE|STATX_NLINK|STATX_ATIME|STATX_CTIME|
                    STATX_MTIME|STATX_UID|STATX_GID|
                    STATX_SIZE|STATX_BLOCKS)))
        goto out_no_update;

Well, if this is triggered for statx(...,  STATX_ATIME,
AT_STATX_SYNC_AS_STAT) and MNT_NOATIME, then yes, result will be junk.
Which means that the code is wrong, it shouldn't do that.

Otherwise (if something other than STATX_ATIME or STATX_INO or
STATX_TYPE is given as well) it *will* do the same thing as what
stat(2) does, so in that case STATX_ATIME should not  be cleared (yet
it is cleared).

I can do a patch, but not tonight...

Thanks,
Miklos


Thanks,
Miklos
