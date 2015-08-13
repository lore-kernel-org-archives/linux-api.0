From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH 1/2] usb: gadget: configfs: add MTP function
Date: Thu, 13 Aug 2015 12:57:48 -0700
Message-ID: <20150813195748.GB30092@kroah.com>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
 <1439493140-22207-2-git-send-email-amit.pundir@linaro.org>
 <55CCF156.8010302@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55CCF156.8010302@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: Amit Pundir <amit.pundir@linaro.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Mike Lockwood <lockwood@android.com>, Benoit Goby <benoit@android.com>, Colin Cross <ccross@android.com>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Peter Oh <poh@broadcom.com>, Greg Hackmann <ghackmann@google.com>, Badhri Jagan Sridharan <Badhri@google.com>, Android Kernel Team <kernel-team@android.com>, Jonathan Corbet <corbet@lwn.net>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Yegor Yefremov <yegorslists@googlemail.com>, Philippe Reynes <tremyfr@gmail.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 13, 2015 at 09:34:46PM +0200, Krzysztof Opasiak wrote:
> Hello,
>=20
> On 08/13/2015 09:12 PM, Amit Pundir wrote:
> >his MTP function is based on years of work originally done in the
> >Android kernel tree by:
> >     Mike Lockwood<lockwood@android.com>
> >     Benoit Goby<benoit@android.com>
> >     Colin Cross<ccross@android.com>
> >     Arve Hj=F8nnev=E5g<arve@android.com>
> >     Peter Oh<poh@broadcom.com>
> >     Greg Hackmann<ghackmann@google.com>
> >     Badhri Jagan Sridharan<Badhri@google.com>
> >I've folded the series up to make it easier to review, and to provid=
e
> >a coherent patch description.
> >
> >Post Gingerbread (Android v2.3), Android dropped USB Mass Storage
> >in favor of Media Transfer Protocal (MTP), which is widely used for
> >transferring media files to digital music players and similar
> >applications. This USB gadget function implements MTP functionalty.
> >
> >Historically this function has been a part of Android composite
> >gadget driver. Android composite driver was Android's solution
> >for dynamic gadget function switching prior to the ConfigFS gadget
> >being merged. There were failed few attempts in past
> >http://marc.info/?l=3Dlinux-usb&m=3D132451695808552  to upstream And=
roid
> >composite driver as well. Now this Android MTP gadget function has b=
een
> >re-implemented so as to be used as a generic ConfigFS function inste=
ad.
> >
> >Again, many thanks to Mike, Benoit, Colin, Arve, Peter, Greg and Bad=
hri,
> >as they are the real authors of this work. However, I've folded thei=
r
> >patches together and modified it enough that I don't want them to be
> >blamed for any mistakes I've made condensing their patches down.
> >
> >Cc: Mike Lockwood<lockwood@android.com>
> >Cc: Benoit Goby<benoit@android.com>
> >Cc: Colin Cross<ccross@android.com>
> >Cc: Arve Hj=F8nnev=E5g<arve@android.com>
> >Cc: Peter Oh<poh@broadcom.com>
> >Cc: Greg Hackmann<ghackmann@google.com>
> >Cc: Badhri Jagan Sridharan<Badhri@google.com>
> >Cc: Android Kernel Team<kernel-team@android.com>
> >Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> >Cc: Jonathan Corbet<corbet@lwn.net>
> >Cc: Felipe Balbi<balbi@ti.com>
> >Cc: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
> >Cc: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> >Cc: Yegor Yefremov<yegorslists@googlemail.com>
> >Cc: Philippe Reynes<tremyfr@gmail.com>
> >Cc: John Stultz<john.stultz@linaro.org>
> >Cc: Sumit Semwal<sumit.semwal@linaro.org>
> >Signed-off-by: Amit Pundir<amit.pundir@linaro.org>
>=20
> In my humble opinion adding such function to Linux kernel doesn't mak=
e any
> sense. By design, MTP is a protocol which requires access to userspac=
e
> features esp. file system. It is very important to run MTP daemon wit=
h
> suitable user and LSM label and many many other issues which should b=
e
> handled by userspace access policy.
>=20
> Moreover this is not a fully functional USB function but only some in=
terface
> which can be used by mtp-responder (mtp-daemon - call it as you like)=
 to
> communicate with host. As we have FunctionFS which allows to implemen=
t any
> USB function in as a userspace service. As MTP nature is more related=
 to
> userspace I think that porting MTP daemon to use this is a right way =
to go.
> This should be much more reasonable than adding new function which al=
so
> requires daemon for proper working. So why add another interface whil=
e we
> can use a generic one?

Isn't there already a userspace MTP daemon that uses the existing
functionfs for usb gadgets?  I thought I remember seeing that
somewhere...

thanks,

greg k-h
