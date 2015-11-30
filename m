From: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mtd: Expand the ecc placement locations to 1216
Date: Mon, 30 Nov 2015 13:11:05 -0800
Message-ID: <20151130211105.GO64635@google.com>
References: <1446742735-20824-1-git-send-email-punnaia@xilinx.com>
 <20151120193342.GX64635@google.com>
 <CAGnW=BZzoo1YFyAYx+oKkCPBOCTSz_KYY+t0=2wh4Fscx7e0eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGnW=BZzoo1YFyAYx+oKkCPBOCTSz_KYY+t0=2wh4Fscx7e0eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: punnaiah choudary kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "michals-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org" <michals-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, "linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Punnaiah Choudary <kpc528-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Punnaiah,

On Sat, Nov 21, 2015 at 08:59:15PM +0530, punnaiah choudary kalluri wrote:
> On Sat, Nov 21, 2015 at 1:03 AM, Brian Norris
> <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Thu, Nov 05, 2015 at 10:28:55PM +0530, Punnaiah Choudary Kalluri wrote:
> >> Device like MT29F32G08ABCDBJ4 have a writesize/oobsize of 16K/1216 Bytes.
> >> So, increasing the maximum ecc placement locations to 1216
> >
> > I'd really prefer not increasing the size of the internal arrays any
> > more. The structures should be rewritten to be dynamic.
> 
> Ok. I have seen the comment "nand_ecclayout should be expandable in the
> future simply by the above macros" and so increased the macro sizes.
> As you said, it is ideal to have memory allocated dynamically for eccpos and
> oobfree fields.

Yes, it *can* be done. Previously, we couldn't do this, because any
change there would also change the ABI, which is off limits, but I fixed
that by separating the 'nand_ecclayout' and 'nand_ecclayout_user'
structs. That still doesn't make it preferable. These structs are
getting pretty big, and they hold a very low density of information...

> >
> >> Signed-off-by: Punnaiah Choudary Kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  include/linux/mtd/mtd.h    | 2 +-
> >>  include/uapi/mtd/mtd-abi.h | 4 ++--
> >>  2 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> >> index f17fa75..1fd3cc6 100644
> >> --- a/include/linux/mtd/mtd.h
> >> +++ b/include/linux/mtd/mtd.h
> >> @@ -95,7 +95,7 @@ struct mtd_oob_ops {
> >>  };
> >>
> >>  #define MTD_MAX_OOBFREE_ENTRIES_LARGE        32
> >> -#define MTD_MAX_ECCPOS_ENTRIES_LARGE 640
> >> +#define MTD_MAX_ECCPOS_ENTRIES_LARGE 1216
> >>  /*
> >>   * Internal ECC layout control structure. For historical reasons, there is a
> >>   * similar, smaller struct nand_ecclayout_user (in mtd-abi.h) that is retained
> >> diff --git a/include/uapi/mtd/mtd-abi.h b/include/uapi/mtd/mtd-abi.h
> >> index 763bb69..c4d592c 100644
> >> --- a/include/uapi/mtd/mtd-abi.h
> >> +++ b/include/uapi/mtd/mtd-abi.h
> >> @@ -220,8 +220,8 @@ struct nand_oobfree {
> >>       __u32 length;
> >>  };
> >>
> >> -#define MTD_MAX_OOBFREE_ENTRIES      8
> >> -#define MTD_MAX_ECCPOS_ENTRIES       64
> >> +#define MTD_MAX_OOBFREE_ENTRIES      32
> >> +#define MTD_MAX_ECCPOS_ENTRIES       1216
> >
> > NAK. This is part of the ABI, and changing this will break user space.
> > If you actually bothered to read code, you might understand why there
> > are now internal and external versions of this struct. The external
> > (user space) version cannot be changed. The internal version can be
> > refactored, as long as the external version still maintains some sanity,
> > at least for old/small devices.
> 
> Sorry, I am confused here.
> Arasan nand controller supports 24 bit ecc and uses BCH algorithm. So,
> it requires
> 672 ecc positions. in this case, how the user space know which are the free
> slots available in spare area?
> because as per the above definitions only 64 positions can be defined.

If you actually need to know this info from user space, then you need to
define a new interface to expose that. The existing one is legacy, and
it is insufficient for most modern use cases. It won't work for you.

Other mechanisms can already help you though. For one, auto-placed OOB
(e.g., 'nandwrite --autoplace') can let the MTD layer automatically put
your data into the available spare area.

Why do you need to access the spare area anyway? Modern NAND filesystems
shouldn't really be storing anything there anyway.

Brian
