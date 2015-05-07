From: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Thu, 7 May 2015 21:09:58 +0200
Message-ID: <CAFLxGvw8ESrM6vZ4iB70JFQN-qR-Trs3j1O_+y36tSOn0GVH4A@mail.gmail.com>
References: <1430949612-21356-1-git-send-email-zab@redhat.com>
	<20150507002617.GJ4327@dastard>
	<20150507172053.GA659@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150507172053.GA659-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Sage Weil <sweil-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, May 7, 2015 at 7:20 PM, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, May 07, 2015 at 10:26:17AM +1000, Dave Chinner wrote:
>> On Wed, May 06, 2015 at 03:00:12PM -0700, Zach Brown wrote:
>> > Add the O_NOMTIME flag which prevents mtime from being updated which can
>> > greatly reduce the IO overhead of writes to allocated and initialized
>> > regions of files.
>>
>> Hmmm. How do backup programs now work out if the file has changed
>> and hence needs copying again? ie. applications using this will
>> break other critical infrastructure in subtle ways.
>
> By using backup infrastructure that doesn't use cmtime.  Like btrfs
> send/recv.  Or application level backups that know how to do
> incrementals from metadata in giant database files, say, without
> walking, comparing, and copying the entire thing.

But how can Joey random user know that some of his
applications are using O_NOMTIME and his KISS backup
program does no longer function as expected?

-- 
Thanks,
//richard
