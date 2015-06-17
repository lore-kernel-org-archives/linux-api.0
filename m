From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v3 1/4] pagemap: check permissions and capabilities at
 open time
Date: Wed, 17 Jun 2015 07:58:10 +0000
Message-ID: <20150617075809.GB384@hori1.linux.bs1.fc.nec.co.jp>
References: <20150609195333.21971.58194.stgit@zurg>
 <20150609200015.21971.25692.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150609200015.21971.25692.stgit@zurg>
Content-Language: ja-JP
Content-ID: <4D66D730AA62554CA938E4CF12CCA0A0@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Mark Williamson <mwilliamson@undo-software.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 09, 2015 at 11:00:15PM +0300, Konstantin Khlebnikov wrote:
> From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>=20
> This patch moves permission checks from pagemap_read() into pagemap_open(=
).
>=20
> Pointer to mm is saved in file->private_data. This reference pins only
> mm_struct itself. /proc/*/mem, maps, smaps already work in the same way.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Link: http://lkml.kernel.org/r/CA+55aFyKpWrt_Ajzh1rzp_GcwZ4=3D6Y=3DkOv8hB=
z172CFJp6L8Tg@mail.gmail.com
                                                          =20
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>   =

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
