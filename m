From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Thu, 29 Jan 2015 21:50:38 +0100
Message-ID: <1422564638.3133.198.camel@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	 <20150129182800.GH11842@obsidianresearch.com>
	 <1422557009.3133.172.camel@opteya.com>
	 <20150129191801.GM11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129191801.GM11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 29 janvier 2015 =C3=A0 12:18 -0700, Jason Gunthorpe a =C3=A9cr=
it :
> On Thu, Jan 29, 2015 at 07:43:29PM +0100, Yann Droneaud wrote:
>=20
> > The write() syscall must return the size buffer passed to it, or
> > less, but in such case it would ask for trouble as userspace would
> > be allowed to write() the remaining bytes.  Returning a size bigger
> > than the one passed to write() is not acceptable and would break an=
y
> > expectation.
>=20
> By that logic the 0 return is still wrong, and it should be ucore->in=
_len
>=20

This is handled by ib_uverbs_write() in
drivers/infiniband/core/uverbs_main.c:

    709                 if (err)
    710                         return err;
    711=20
    712                 return written_count;


> But I think we can return less without risking anything breaking, it
> already violates the invariant associated with write() - it mutates
> the buffer passed in!
>=20

I don't think so, as only the response buffer is written to and the
response buffer pointer is provided in the buffer given to write().

AFAIK, no uverbs ever change the content of the input buffer (eg. the
request): I've managed to declare the various input buffers "const" so
it would surprising to find it use for writing to userspace.

Anyway, I recognize that uverb way of abusing write() syscall is=20
borderline (at best) regarding other Linux subsystems and Unix paradigm=
=20
in general. But it's not enough to screw it more.

Regards.

--=20
Yann Droneaud
OPTEYA
