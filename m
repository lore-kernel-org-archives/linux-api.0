From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Thu, 7 May 2015 13:06:08 -0700
Message-ID: <CALCETrX2s-26B1O5yFewhpCZtO2WRm9=3XtW8YHnC8dZszP_cQ@mail.gmail.com>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
 <20150507002617.GJ4327@dastard> <20150507172053.GA659@lenny.home.zabbo.net>
 <CAFLxGvw8ESrM6vZ4iB70JFQN-qR-Trs3j1O_+y36tSOn0GVH4A@mail.gmail.com>
 <CALCETrWNDMq0nK3ac-uZweV5BKK_yWTQHH5D0YkyEu7bcONo9g@mail.gmail.com> <554BC4D8.9010507@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <554BC4D8.9010507@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Zach Brown <zab@redhat.com>, Dave Chinner <david@fromorbit.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sweil@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 7, 2015 at 1:02 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 07.05.2015 um 21:53 schrieb Andy Lutomirski:
>> On Thu, May 7, 2015 at 12:09 PM, Richard Weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> On Thu, May 7, 2015 at 7:20 PM, Zach Brown <zab@redhat.com> wrote:
>>>> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
>>>>> On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
>>>>>> Add the O_NOMTIME flag which prevents mtime from being updated which can
>>>>>> greatly reduce the IO overhead of writes to allocated and initialized
>>>>>> regions of files.
>>>>>
>>>>> Hmmm. How do backup programs now work out if the file has changed
>>>>> and hence needs copying again? ie. applications using this will
>>>>> break other critical infrastructure in subtle ways.
>>>>
>>>> By using backup infrastructure that doesn't use cmtime.  Like btrfs
>>>> send/recv.  Or application level backups that know how to do
>>>> incrementals from metadata in giant database files, say, without
>>>> walking, comparing, and copying the entire thing.
>>>
>>> But how can Joey random user know that some of his
>>> applications are using O_NOMTIME and his KISS backup
>>> program does no longer function as expected?
>>>
>>
>> Joey random user can't have a working KISS backup anyway, though,
>> because we screw up mtime updates on mmap writes.  I have patches
>> gathering dust that fix that, though.
>
> Hmmm, I thought mtime will be updated upon msync()?
> Assuming a sane application is using msync()...
>

So would I.  Unfortunately, mtime is updated on the page fault that
makes an mmapped page writeable, thus guaranteeing that the resulting
mtime is stale if you mmap a file, write to it, unmap it, and close
it.  It's much more stale if you mmap it, write, wait for a while but
not long enough that the page is automatically written back, write
again, unmap, and close.

--Andy
