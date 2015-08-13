From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC][PATCH 1/2] usb: gadget: configfs: add MTP function
Date: Thu, 13 Aug 2015 21:34:46 +0200
Message-ID: <55CCF156.8010302@samsung.com>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
 <1439493140-22207-2-git-send-email-amit.pundir@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1439493140-22207-2-git-send-email-amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Lockwood <lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Benoit Goby <benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Peter Oh <poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Badhri Jagan Sridharan <Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Andrzej Pietrasiewicz <andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Yegor Yefremov <yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Philippe Reynes <tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On 08/13/2015 09:12 PM, Amit Pundir wrote:
> his MTP function is based on years of work originally done in the
> Android kernel tree by:
>      Mike Lockwood<lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>      Benoit Goby<benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>      Colin Cross<ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>      Arve Hj=C3=B8nnev=C3=A5g<arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
>      Peter Oh<poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>      Greg Hackmann<ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>      Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> I've folded the series up to make it easier to review, and to provide
> a coherent patch description.
>
> Post Gingerbread (Android v2.3), Android dropped USB Mass Storage
> in favor of Media Transfer Protocal (MTP), which is widely used for
> transferring media files to digital music players and similar
> applications. This USB gadget function implements MTP functionalty.
>
> Historically this function has been a part of Android composite
> gadget driver. Android composite driver was Android's solution
> for dynamic gadget function switching prior to the ConfigFS gadget
> being merged. There were failed few attempts in past
> http://marc.info/?l=3Dlinux-usb&m=3D132451695808552  to upstream Andr=
oid
> composite driver as well. Now this Android MTP gadget function has be=
en
> re-implemented so as to be used as a generic ConfigFS function instea=
d.
>
> Again, many thanks to Mike, Benoit, Colin, Arve, Peter, Greg and Badh=
ri,
> as they are the real authors of this work. However, I've folded their
> patches together and modified it enough that I don't want them to be
> blamed for any mistakes I've made condensing their patches down.
>
> Cc: Mike Lockwood<lockwood-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Benoit Goby<benoit-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Colin Cross<ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Arve Hj=C3=B8nnev=C3=A5g<arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Peter Oh<poh-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Cc: Greg Hackmann<ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Badhri Jagan Sridharan<Badhri-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Android Kernel Team<kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
> Cc: Greg Kroah-Hartman<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: Jonathan Corbet<corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: Felipe Balbi<balbi-l0cyMroinI0@public.gmane.org>
> Cc: Andrzej Pietrasiewicz<andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Cc: Laurent Pinchart<laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
> Cc: Yegor Yefremov<yegorslists-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> Cc: Philippe Reynes<tremyfr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: John Stultz<john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Sumit Semwal<sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Amit Pundir<amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

In my humble opinion adding such function to Linux kernel doesn't make=20
any sense. By design, MTP is a protocol which requires access to=20
userspace features esp. file system. It is very important to run MTP=20
daemon with suitable user and LSM label and many many other issues whic=
h=20
should be handled by userspace access policy.

Moreover this is not a fully functional USB function but only some=20
interface which can be used by mtp-responder (mtp-daemon - call it as=20
you like) to communicate with host. As we have FunctionFS which allows=20
to implement any USB function in as a userspace service. As MTP nature=20
is more related to userspace I think that porting MTP daemon to use thi=
s=20
is a right way to go. This should be much more reasonable than adding=20
new function which also requires daemon for proper working. So why add=20
another interface while we can use a generic one?

Best regards,
--=20
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
