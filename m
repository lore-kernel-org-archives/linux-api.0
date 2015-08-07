From: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH V6 3/6] mm: Introduce VM_LOCKONFAULT
Date: Fri, 7 Aug 2015 14:34:45 +0200
Message-ID: <20150807123444.GA25792@ulmo>
References: <1438184575-10537-1-git-send-email-emunson@akamai.com>
 <1438184575-10537-4-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1398851848=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1438184575-10537-4-git-send-email-emunson@akamai.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Eric B Munson <emunson@akamai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, "Kirill A. Shutemov" <kirill@shutemov.name>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org


--===============1398851848==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2015 at 11:42:52AM -0400, Eric B Munson wrote:
[...]
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index ca1e091..38d69fc 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -579,6 +579,7 @@ static void show_smap_vma_flags(struct seq_file *m, s=
truct vm_area_struct *vma)
>  #ifdef CONFIG_X86_INTEL_MPX
>  		[ilog2(VM_MPX)]		=3D "mp",
>  #endif
> +		[ilog2(VM_LOCKONFAULT)]	=3D "lf",
>  		[ilog2(VM_LOCKED)]	=3D "lo",
>  		[ilog2(VM_IO)]		=3D "io",
>  		[ilog2(VM_SEQ_READ)]	=3D "sr",
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2e872f9..c2f3551 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -127,6 +127,7 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page=
", just pure PFN */
>  #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
> =20
> +#define VM_LOCKONFAULT	0x00001000	/* Lock the pages covered when they ar=
e faulted in */
>  #define VM_LOCKED	0x00002000
>  #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
> =20

This clashes with another change currently in linux-next:

	81d056997385 userfaultfd: add VM_UFFD_MISSING and VM_UFFD_WP

Adding Andrea for visibility.

I noticed this because I was trying to make selftests/vm/mlock2-tests
work to see if the new mlock2 syscall would work on ARM. It didn't, so I
had to investigate and noticed that two symbolic names resolve to the
same value, which results in the mnemonics table (first hunk above)
overwriting the VM_LOCKONFAULT entry with the VM_UFFD_WP entry.

I've applied the following patch locally to fix this up.

Andrew, I think both of those patches came in via your tree, so perhaps
the best thing would be to squash the below (provided everybody agrees
that it's the right fix) into Eric's patch, adding the VM_LOCKONFAULT
flag?

Thierry

---- >8 ----
=46rom a0003ebfeb15f91094d17961633cabb4e1beed21 Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <treding@nvidia.com>
Date: Fri, 7 Aug 2015 14:23:42 +0200
Subject: [PATCH] mm: Fix VM_LOCKONFAULT clash with VM_UFFD_WP

Currently two patches in linux-next add new VM flags and unfortunately
two flags end up using the same value. This results for example in the
/proc/pid/smaps file not listing the VM_LOCKONFAULT flag, which breaks
tools/testing/selftests/vm/mlock2-tests.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 fs/proc/task_mmu.c | 2 +-
 include/linux/mm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index bdd7e48a85f0..893e4b9bb2da 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -592,13 +592,13 @@ static void show_smap_vma_flags(struct seq_file *m, s=
truct vm_area_struct *vma)
 #ifdef CONFIG_X86_INTEL_MPX
 		[ilog2(VM_MPX)]		=3D "mp",
 #endif
-		[ilog2(VM_LOCKONFAULT)]	=3D "lf",
 		[ilog2(VM_LOCKED)]	=3D "lo",
 		[ilog2(VM_IO)]		=3D "io",
 		[ilog2(VM_SEQ_READ)]	=3D "sr",
 		[ilog2(VM_RAND_READ)]	=3D "rr",
 		[ilog2(VM_DONTCOPY)]	=3D "dc",
 		[ilog2(VM_DONTEXPAND)]	=3D "de",
+		[ilog2(VM_LOCKONFAULT)]	=3D "lf",
 		[ilog2(VM_ACCOUNT)]	=3D "ac",
 		[ilog2(VM_NORESERVE)]	=3D "nr",
 		[ilog2(VM_HUGETLB)]	=3D "ht",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 363ea2cda35f..cb4e1737d669 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -129,7 +129,6 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
=20
-#define VM_LOCKONFAULT	0x00001000	/* Lock the pages covered when they are =
faulted in */
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
=20
@@ -139,6 +138,7 @@ extern unsigned int kobjsize(const void *objp);
=20
 #define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
 #define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
+#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are =
faulted in */
 #define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
 #define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
 #define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
--=20
2.4.5


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVxKXiAAoJEN0jrNd/PrOhvCIP/1I80WiuuIpSZ5ifYvc661N2
JBoZerfBRNdTjA4E7EAtMO2xvaJ1xvdEoIp5kyG7uDTzkJOWflvWdrtZnK56I7RQ
pC8Ue9Iz2mr63fX5HEdYJTZ80IV9QQ8bPiHthxgzDfl4e24lRBSTbhdT9T9wzht7
kLGmvX7RnlIkANSG02EHe37DrZCgHhQJqiiXHj7iGTKE59U/QrY8DMHLB22EhCRW
5kBnDYI7iNzNwwX4J3Pcct6UaFPO+DiuPqpFw+g4Rpp4Wq+x1fkXHTSRSpMzw2kR
cx3QGba+DA/fWszHkCLBRqQd6IaQmfZv/3nnOJiXgTGCF9CAxG5UwtV0RsaFhJpe
+fv3MtccTZ4fIBvzVdTZkOjGNfAazGHgi/Ms+De9nxICnBDiq3WLB+VTE3aZucnV
db6gUncbghoWg5VUsoEsQY435pviaV3+CMkiUdLcv6xZWRAiWaQATCIVyVQze848
jUVvjaqYcsq5pvNU2WAkwkm+GsX7Qsj7TFUStzrj0meNq3XsrpzRftP+615RY4U6
voMDkLGExYRGWyLb8wuHpbu/P+QVvPcwwac+BUwc3U1GuzdB4cj3HZ/EL5FYoC/a
ydu7mjhMz2f/TYmwPujk2DD2LaoPH4Q9JFMO4vcohyjdBSVHEGaM+Zlem2OTGlx2
EWDdDt0AkdhuKFMuMZln
=Aeys
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--

--===============1398851848==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK

--===============1398851848==--
