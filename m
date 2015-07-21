From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v4 1/5] pagemap: check permissions and capabilities at
 open time
Date: Tue, 21 Jul 2015 08:06:27 +0000
Message-ID: <20150721080626.GB4490@hori1.linux.bs1.fc.nec.co.jp>
References: <20150714152516.29844.69929.stgit@buzz>
 <20150714153735.29844.38428.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150714153735.29844.38428.stgit@buzz>
Content-Language: ja-JP
Content-ID: <A81DE86E3939F047A0A5DED82AC44DC0@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Williamson <mwilliamson@undo-software.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 06:37:35PM +0300, Konstantin Khlebnikov wrote:
> This patch moves permission checks from pagemap_read() into pagemap_open(=
).
>=20
> Pointer to mm is saved in file->private_data. This reference pins only
> mm_struct itself. /proc/*/mem, maps, smaps already work in the same way.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Link: http://lkml.kernel.org/r/CA+55aFyKpWrt_Ajzh1rzp_GcwZ4=3D6Y=3DkOv8hB=
z172CFJp6L8Tg@mail.gmail.com

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
