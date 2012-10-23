From: Andreas Jaeger <aj-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
Date: Tue, 23 Oct 2012 21:15:42 +0200
Message-ID: <5086ECDE.4030300@suse.com>
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <5086D27F.1000007@adobe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5086D27F.1000007-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Cc: "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Holland <pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/23/2012 07:23 PM, Paton J. Lewis wrote:
> [Re-sending without HTML formatting; all vger.kernel.org destination
> addresses bounced my original response.]
>
> On 10/16/12 8:12 AM, Michael Kerrisk (man-pages) wrote:
>> [CC +=3D linux-api@]
>
> Thank you; is this sufficient to coordinate the required changes to t=
he
> glibc version of epoll.h?

Paton, we normally review the diffs between kernel versions but noticin=
g=20
us via libc-alpha is great.

So, you ask to get this added to <sys/epoll.h>?

#define EPOLL_CTL_DISABLE 4

Once 3.7 is out and contains it, we will add it. A friendly reminder=20
once the patch is in would be nice so that we don't miss it during the=20
review.

thanks,
Andreas
--=20
  Andreas Jaeger aj@{suse.com,opensuse.org} Twitter/Identica: jaegerand=
i
   SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
    GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCr=
nberg)
     GPG fingerprint =3D 93A3 365E CE47 B889 DF7F  FED1 389A 563C C272 =
A126
