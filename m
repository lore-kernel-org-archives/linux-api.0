From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] move_pages.2: not return ENOENT if the page are already on the target nodes
Date: Fri, 6 Dec 2019 13:00:18 -0500
Message-ID: <BE1B9B9B-17C2-4093-A332-183DF3B6F2A3@lca.pw>
References: <5384814f-c937-9622-adbe-c03e199e0267@linux.alibaba.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5384814f-c937-9622-adbe-c03e199e0267@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@kernel.org>, John Hubbard <jhubbard@nvidia.com>, mtk.manpages@gmail.com, cl@linux.com, akpm@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org



> On Dec 6, 2019, at 12:31 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>=20
> It looks since commit e78bbfa82624 ("mm: stop returning -ENOENT from sys_m=
ove_pages() if nothing got migrated") too, which reset err to 0 unconditiona=
lly. It seems it is on purpose by that commit the syscall caller should chec=
k status for the details according to the commit log.

I don=E2=80=99t read it on purpose. =E2=80=9CThere is no point in returning -=
ENOENT from sys_move_pages() if all pages
were already on the right node=E2=80=9D, so this is only taking about the pa=
ges in the desired node. Anyway, but now it is probably the best time to thi=
nk outside the box redesigning this syscalls and nuke this whole mess.=
