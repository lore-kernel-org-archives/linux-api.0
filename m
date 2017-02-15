From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] ioctl_list.2: BLKRASET/BLKRAGET take unsigned long
Date: Wed, 15 Feb 2017 15:29:07 +0100
Message-ID: <20170215142907.GA28937@rei.lan>
References: <20170215112015.GA27080@rei.lan>
 <20170215112205.GA27269@rei.lan>
 <CAK8P3a0KzhqFZqvPH4q7_Nb6+TMmhCWXDi_-wQG=mi-1U=Ccxw@mail.gmail.com>
 <20170215125946.GA27511@rei.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170215125946.GA27511-2UyX9mZUyMU@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi!
> So as far as I can tell we depend here on a fact that upper part of $rdx
> is zeroed. Not sure if that is guaranteed or not.

Which seems to be the case for x86_64 processors, so passing int value
to ioctl() will work fine there. Not sure about the rest of 64bit archs.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
