From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: Re: [PATCH NOTFORMERGE 0/5] Extend remote madvise API to KSM hints
Date: Tue, 10 Dec 2019 11:49:39 +0100
Message-ID: <20191210104939.jauw5hnv3smhtvtr@butterfly.localdomain>
References: <20190616085835.953-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190616085835.953-1-oleksandr@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello, Minchan.

On Sun, Jun 16, 2019 at 10:58:30AM +0200, Oleksandr Natalenko wrote:
> This is a set of commits based on our discussion on your submission [1].
>=20
> First 2 implement minor suggestions just for you to not forget to take
> them into account.
>=20
> uio.h inclusion was needed for me to be able to compile your series
> successfully. Also please note I had to enable "Transparent Hugepage
> Support" as well as "Enable idle page tracking" options, otherwise the
> build failed. I guess this can be addressed by you better since the
> errors are introduced with MADV_COLD introduction.
>=20
> Last 2 commits are the actual KSM hints enablement. The first one
> implements additional check for the case where the mmap_sem is taken for
> write, and the second one just allows KSM hints to be used by the remote
> interface.
>=20
> I'm not Cc'ing else anyone except two mailing lists to not distract
> people unnecessarily. If you are fine with this addition, please use it
> for your next iteration of process_madvise(), and then you'll Cc all the
> people needed.
>=20
> Thanks.
>=20
> [1] https://lore.kernel.org/lkml/20190531064313.193437-1-minchan@kernel.o=
rg/
>=20
> Oleksandr Natalenko (5):
>   mm: rename madvise_core to madvise_common
>   mm: revert madvise_inject_error line split
>   mm: include uio.h to madvise.c
>   mm/madvise: employ mmget_still_valid for write lock
>   mm/madvise: allow KSM hints for remote API
>=20
>  mm/madvise.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>=20
> --=20
> 2.22.0
>=20

This is a gentle ping. Are you still planning to submit process_madvise() s=
olution?

--=20
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
