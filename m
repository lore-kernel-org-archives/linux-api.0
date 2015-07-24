From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v4 1/5] pagemap: check permissions and capabilities at
 open time
Date: Fri, 24 Jul 2015 19:16:39 +0100
Message-ID: <CAEVpBaKsFLRx-tfy_zC-3Yqp++wKMKjULEKN-Mq5mnZK2bjS1Q@mail.gmail.com>
References: <20150714152516.29844.69929.stgit@buzz>
	<20150714153735.29844.38428.stgit@buzz>
	<20150721080626.GB4490@hori1.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150721080626.GB4490-CFvn+FByjrC01j0XV7yAGhjPlmGC1jup6qtp775pBPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

(within the limits of my understanding of the mm code)
Reviewed-by: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>

On Tue, Jul 21, 2015 at 9:06 AM, Naoya Horiguchi
<n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org> wrote:
> On Tue, Jul 14, 2015 at 06:37:35PM +0300, Konstantin Khlebnikov wrote:
>> This patch moves permission checks from pagemap_read() into pagemap_open().
>>
>> Pointer to mm is saved in file->private_data. This reference pins only
>> mm_struct itself. /proc/*/mem, maps, smaps already work in the same way.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
>> Link: http://lkml.kernel.org/r/CA+55aFyKpWrt_Ajzh1rzp_GcwZ4=6Y=kOv8hBz172CFJp6L8Tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
>
> Reviewed-by: Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>
