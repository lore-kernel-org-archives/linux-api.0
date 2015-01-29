From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 1/5] IB/uverbs: ex_query_device: answer must not
 depend on request's comp_mask
Date: Thu, 29 Jan 2015 22:59:01 +0100
Message-ID: <1422568741.3133.247.camel@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
	 <24ceb1fc5b2b6563532e5776b1b2320b1ae37543.1422553023.git.ydroneaud@opteya.com>
	 <20150129182800.GH11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129182800.GH11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 29 janvier 2015 =C3=A0 11:28 -0700, Jason Gunthorpe a =C3=A9cr=
it :
> On Thu, Jan 29, 2015 at 06:59:58PM +0100, Yann Droneaud wrote:
> > As specified in "Extending Verbs API" presentation [1] by Tzahi Ove=
d
> > during OFA International Developer Workshop 2013, the request's
> > comp_mask should describe the request data: it's describe the
> > availability of extended fields in the request.
> > Conversely, the response's comp_mask should describe the presence
> > of extended fields in the response.
>=20
> Roland: I agree with Yann, these patches need to go in, or the ODP
> patches reverted.
>=20

Reverting all On Demand Paging patches seems overkill:
if something as to be reverted it should be commit 5a77abf9a97a
("IB/core: Add support for extended query device caps") and the part of
commit 860f10a799c8 ("IB/core: Add flags for on demand paging support")
which modify ib_uverbs_ex_query_device().

But I wonder about this part of commit 860f10a799c8:

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/=
core/uverbs_cmd.c
index c7a43624c96b..f9326ccda4b5 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -953,6 +953,18 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *fi=
le,
                goto err_free;
        }
=20
+       if (cmd.access_flags & IB_ACCESS_ON_DEMAND) {
+               struct ib_device_attr attr;
+
+               ret =3D ib_query_device(pd->device, &attr);
+               if (ret || !(attr.device_cap_flags &
+                               IB_DEVICE_ON_DEMAND_PAGING)) {
+                       pr_debug("ODP support not available\n");
+                       ret =3D -EINVAL;
+                       goto err_put;
+               }
+       }
+

AFAICT (1 << 6) bit from struct ib_uverbs_reg_mr access_flags field
was not enforced to be 0 previously, as ib_check_mr_access() only check=
=20
for some coherency between a subset of the bits (it's not a function
dedicated to check flags provided by userspace):

include/rdma/ib_verbs.h:

   1094 enum ib_access_flags {
   1095         IB_ACCESS_LOCAL_WRITE   =3D 1,
   1096         IB_ACCESS_REMOTE_WRITE  =3D (1<<1),
   1097         IB_ACCESS_REMOTE_READ   =3D (1<<2),
   1098         IB_ACCESS_REMOTE_ATOMIC =3D (1<<3),
   1099         IB_ACCESS_MW_BIND       =3D (1<<4),
   1100         IB_ZERO_BASED           =3D (1<<5),
   1101         IB_ACCESS_ON_DEMAND     =3D (1<<6),
   1102 };

drivers/infiniband/core/uverbs_cmd.c: ib_uverbs_reg_mr()

    961         ret =3D ib_check_mr_access(cmd.access_flags);
    962         if (ret)
    963                 return ret;

include/rdma/ib_verbs.h:

   2643 static inline int ib_check_mr_access(int flags)
   2644 {
   2645         /*
   2646          * Local write permission is required if remote write o=
r
   2647          * remote atomic permission is also requested.
   2648          */
   2649         if (flags & (IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_REMOTE=
_WRITE) &&
   2650             !(flags & IB_ACCESS_LOCAL_WRITE))
   2651                 return -EINVAL;
   2652=20
   2653         return 0;
   2654 }

drivers/infiniband/core/uverbs_cmd.c: ib_uverbs_reg_mr()

    990         mr =3D pd->device->reg_user_mr(pd, cmd.start, cmd.lengt=
h, cmd.hca_va,
    991                                      cmd.access_flags, &udata);

reg_user_mr() functions may call ib_umem_get() and pass access_flags to
it:

drivers/infiniband/core/umem.c: ib_umem_get()

    114         /*
    115          * We ask for writable memory if any of the following
    116          * access flags are set.  "Local write" and "remote wri=
te"
    117          * obviously require write access.  "Remote atomic" can=
 do
    118          * things like fetch and add, which will modify memory,=
 and
    119          * "MW bind" can change permissions by binding a window=
=2E
    120          */
    121         umem->writable  =3D !!(access &
    122                 (IB_ACCESS_LOCAL_WRITE   | IB_ACCESS_REMOTE_WRI=
TE |
    123                  IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
    124=20
    125         if (access & IB_ACCESS_ON_DEMAND) {
    126                 ret =3D ib_umem_odp_get(context, umem);
    127                 if (ret) {
    128                         kfree(umem);
    129                         return ERR_PTR(ret);
    130                 }
    131                 return umem;
    132         }


As you can see only a few bits in access_flags are checked in the end,
so it may exist a very unlikely possibility that an existing userspace
program is setting this IB_ACCESS_ON_DEMAND bit without the intention
of enabling on demand paging as this would be unnoticed by older kernel=
=2E

In the other hand, a newer program built with on-demand-paging in mind
will set the bit, but when run on older kernel, it will be a no-op,
allowing the program to continue, perhaps thinking on-demand-paging
is available.

That should be avoided as much as possible.

Unfortunately, I think this cannot be fixed as it's was long since=20
IB_ZERO_BASED was added by commit 7083e42ee2 ("IB/core: Add "type 2"=20
memory windows support").
Anyway there was no check for IB_ACCESS_REMOTE_READ, nor=20
IB_ACCESS_MW_BIND in the uverb layer either.

So, just as the second argument of open() syscall (remember O_TMPFILE,
see http://lwn.net/Articles/562294/ ), we will have to live with and be
careful ...

Regards.

--=20
Yann Droneaud
OPTEYA
