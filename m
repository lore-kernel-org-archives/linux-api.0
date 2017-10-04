From: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [RFC] mmap(MAP_CONTIG)
Date: Wed, 04 Oct 2017 13:54:05 +0200
Message-ID: <xa1tk20bxh5u.fsf@mina86.com>
References: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21f1ec96-2822-1189-1c95-79a2bb491571@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Guy Shattah <sguy@mellanox.com>, Christoph Lameter <cl@linux.com>, Mike Kravetz <mike.kravetz@oracle.com>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 03 2017, Mike Kravetz wrote:
> At Plumbers this year, Guy Shattah and Christoph Lameter gave a presentat=
ion
> titled 'User space contiguous memory allocation for DMA' [1].  The slides
> point out the performance benefits of devices that can take advantage of
> larger physically contiguous areas.

Issue I have is that kind of memory needed may depend on a device.  Some
may require contiguous blocks.  Some may support scatter-gather.  Some
may be behind IO-MMU and not care either way.

Furthermore, I feel d=C3=A9j=C3=A0 vu.  Wasn=E2=80=99t dmabuf supposed to a=
ddress this
issue?

--=20
Best regards
=E3=83=9F=E3=83=8F=E3=82=A6 =E2=80=9C=F0=9D=93=B6=F0=9D=93=B2=F0=9D=93=B7=
=F0=9D=93=AA86=E2=80=9D =E3=83=8A=E3=82=B6=E3=83=AC=E3=83=B4=E3=82=A4=E3=83=
=84
=C2=ABIf at first you don=E2=80=99t succeed, give up skydiving=C2=BB
