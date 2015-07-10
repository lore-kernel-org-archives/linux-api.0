From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [RFCv3 0/5] enable migration of driver pages
Date: Fri, 10 Jul 2015 09:02:12 +0900
Message-ID: <559F0B84.6020908@lge.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com> <20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org> <559C68B3.3010105@lge.com> <20150707170746.1b91ba0d07382cbc9ba3db92@linux-foundation.org> <559C6CA6.1050809@lge.com> <CAPM=9txmUJ58=CAxDhf12Y3Y8wz7CGBy-Bd4pQ8YAAKDsCxU8w@mail.gmail.com> <559DB86D.40000@lge.com> <20150709130848.GD21858@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150709130848.GD21858@phenom.ffwll.local>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Airlie <airlied@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, Al Viro <viro@zeniv.linux.org.uk>, "Michael S. Tsirkin" <mst@redhat.com>, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, "open list:VIRTIO CORE, NET..." <virtualization@lists.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, open@kvack.org, "list@kvack.org: ABI/API" <linux-api@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, gunho.lee@lge.com, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org



2015-07-09 =EC=98=A4=ED=9B=84 10:08=EC=97=90 Daniel Vetter =EC=9D=B4(=EA=
=B0=80) =EC=93=B4 =EA=B8=80:
> Also there's a bit a lack of gpu drivers from the arm world in upstre=
am,
> which is probabyl why this patch series doesn't come with a user. Mig=
ht be
> better to first upstream the driver before talking about additional
> infrastructure that it needs.
> -Daniel

I'm not from ARM but I just got the idea of driver page migration
during I worked with ARM gpu driver.
I'm sure this patch is good for zram and balloon
and hope it can be applied to drivers consuming many pages and generati=
ng fragmentation,
such as GPU or gfx driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
