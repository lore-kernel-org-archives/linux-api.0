From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v4 2/5] pagemap: switch to the new format and do some
 cleanup
Date: Tue, 21 Jul 2015 07:44:24 +0000
Message-ID: <20150721074424.GB2475@hori1.linux.bs1.fc.nec.co.jp>
References: <20150714152516.29844.69929.stgit@buzz>
 <20150714153737.29844.33895.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150714153737.29844.33895.stgit@buzz>
Content-Language: ja-JP
Content-ID: <EC0F28FC27E1164F9ECF5E62A84AB942@gisp.nec.co.jp>
Sender: owner-linux-mm@kvack.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Mark Williamson <mwilliamson@undo-software.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 06:37:37PM +0300, Konstantin Khlebnikov wrote:
> This patch removes page-shift bits (scheduled to remove since 3.11) and
> completes migration to the new bit layout. Also it cleans messy macro.
>=20
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
