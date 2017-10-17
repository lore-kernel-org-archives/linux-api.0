From: Michal Nazarewicz <mina86-deATy8a+UHjQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm/map_contig: Add mmap(MAP_CONTIG) support
Date: Tue, 17 Oct 2017 15:22:39 +0200
Message-ID: <xa1tlgk9c3j4.fsf@mina86.com>
References: <20171013084054.me3kxhgbxzgm2lpr@dhcp22.suse.cz> <alpine.DEB.2.20.1710131015420.3949@nuc-kabylake> <20171013152801.nbpk6nluotgbmfrs@dhcp22.suse.cz> <alpine.DEB.2.20.1710131040570.4247@nuc-kabylake> <20171013154747.2jv7rtfqyyagiodn@dhcp22.suse.cz> <alpine.DEB.2.20.1710131053450.4400@nuc-kabylake> <20171013161736.htumyr4cskfrjq64@dhcp22.suse.cz> <752b49eb-55c6-5a34-ab41-6e91dd93ea70@mellanox.com> <20171016082456.no6ux63uy2rmj4fe@dhcp22.suse.cz> <0e238c56-c59d-f648-95fc-c8cb56c3652e@mellanox.com> <20171016123248.csntl6luxgafst6q@dhcp22.suse.cz> <AM6PR0502MB378375AF8B569DBCCFE20D7DBD4C0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM6PR0502MB378375AF8B569DBCCFE20D7DBD4C0-md96bDB8+JV1k1TWM4Wt8cDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-mm@kvack.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api@vger.kernel.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "Aneesh Kumar K . V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 17 2017, Guy Shattah wrote:
> Are you going to be OK with kernel API which implements contiguous
> memory allocation?  Possibly with mmap style?  Many drivers could
> utilize it instead of having their own weird and possibly non-standard
> way to allocate contiguous memory.  Such API won't be available for
> user space.

What you describe sounds like CMA.  It may be far from perfect but it=E2=80=
=99s
there already and drivers which need contiguous memory can allocate it.

--=20
Best regards
=E3=83=9F=E3=83=8F=E3=82=A6 =E2=80=9C=F0=9D=93=B6=F0=9D=93=B2=F0=9D=93=B7=
=F0=9D=93=AA86=E2=80=9D =E3=83=8A=E3=82=B6=E3=83=AC=E3=83=B4=E3=82=A4=E3=83=
=84
=C2=ABIf at first you don=E2=80=99t succeed, give up skydiving=C2=BB
