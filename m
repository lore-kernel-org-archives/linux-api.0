From: Dave Airlie <airlied@gmail.com>
Subject: Re: [RFCv3 0/5] enable migration of driver pages
Date: Thu, 9 Jul 2015 08:47:57 +1000
Message-ID: <CAPM=9txmUJ58=CAxDhf12Y3Y8wz7CGBy-Bd4pQ8YAAKDsCxU8w@mail.gmail.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>
	<20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org>
	<559C68B3.3010105@lge.com>
	<20150707170746.1b91ba0d07382cbc9ba3db92@linux-foundation.org>
	<559C6CA6.1050809@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <559C6CA6.1050809@lge.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Gioh Kim <gioh.kim@lge.com>, dri-devel <dri-devel@lists.freedesktop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, Al Viro <viro@zeniv.linux.org.uk>, "Michael S. Tsirkin" <mst@redhat.com>, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, gunho.lee@lge.com, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org

>>
>>
>> Can the various in-kernel GPU drivers benefit from this?  If so, wiring
>> up one or more of those would be helpful?
>
>
> I'm sure that other in-kernel GPU drivers can have benefit.
> It must be helpful.
>
> If I was familiar with other in-kernel GPU drivers code, I tried to patch
> them.
> It's too bad.

I'll bring dri-devel into the loop here.

ARM GPU developers please take a look at this stuff, Laurent, Rob,
Eric I suppose.

Daniel Vetter you might have some opinions as well.

Dave.
