From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v4 3/5] pagemap: rework hugetlb and thp report
Date: Tue, 21 Jul 2015 08:00:47 +0000
Message-ID: <20150721080046.GC2475@hori1.linux.bs1.fc.nec.co.jp>
References: <20150714152516.29844.69929.stgit@buzz>
 <20150714153738.29844.39039.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150714153738.29844.39039.stgit@buzz>
Content-Language: ja-JP
Content-ID: <31281EC041F59B4EA73DE6DE7E05E657@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Williamson <mwilliamson@undo-software.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 06:37:39PM +0300, Konstantin Khlebnikov wrote:
> This patch moves pmd dissection out of reporting loop: huge pages
> are reported as bunch of normal pages with contiguous PFNs.
>=20
> Add missing "FILE" bit in hugetlb vmas.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

With reflecting Kirill's comment about #ifdef, I'm OK for this patch.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
